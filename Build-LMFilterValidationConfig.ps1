<#
.SYNOPSIS
Development tool to generate filter field validation configuration from Swagger.

.DESCRIPTION
This script fetches the LogicMonitor public Swagger JSON endpoint and extracts API
endpoints and their response schemas. It then maps each endpoint to the properties
available in the response model, creating a validation configuration file that can be
used at runtime to validate filter fields before sending API requests.

.EXAMPLE
.\Build-LMFilterValidationConfig.ps1

This will generate Private/LMFilterValidationConfig.psd1 with all endpoint-to-fields mappings.

.NOTES
This is a development-time tool and should be run whenever endpoint filter fields
need to be refreshed from the latest public Swagger spec.
#>

[CmdletBinding()]
param(
    [Parameter()]
    [String]$SwaggerUrl = 'https://www.logicmonitor.com/swagger-ui-master/api-v3/dist/swagger.json',

    [Parameter()]
    [String]$OutputPath = (Join-Path $PSScriptRoot 'Private/LMFilterValidationConfig.psd1')
)

Write-Host "Fetching Swagger file: $SwaggerUrl" -ForegroundColor Cyan
try {
    $Swagger = Invoke-RestMethod -Uri $SwaggerUrl -Method Get -ErrorAction Stop
}
catch {
    Write-Error "Failed to fetch Swagger from '$SwaggerUrl'. $($_.Exception.Message)"
    return
}

if (-not $Swagger.definitions -or -not $Swagger.paths) {
    Write-Error "Unexpected Swagger format. Expected Swagger 2.0 with 'definitions' and 'paths'."
    return
}

$Definitions = @{}
foreach ($definitionProperty in $Swagger.definitions.PSObject.Properties) {
    $Definitions[$definitionProperty.Name] = $definitionProperty.Value
}

Write-Host "Extracting API endpoints and schemas..." -ForegroundColor Cyan

# Build endpoint to schema mapping
$EndpointToSchema = @{}
$SchemaProperties = @{}

function Get-SwaggerRefName {
    param(
        [Parameter(Mandatory)]
        [String]$RefPath
    )

    if ($RefPath -match '^#/definitions/(?<name>.+)$') {
        return $Matches.name
    }

    return $null
}

function Get-SchemaPropertyNames {
    param(
        [Parameter(Mandatory)]
        [Object]$Schema,

        [Parameter(Mandatory)]
        [hashtable]$AllDefinitions,

        [Parameter()]
        [hashtable]$Visited = @{}
    )

    $properties = @()
    if ($null -eq $Schema) {
        return $properties
    }

    if ($Schema.properties) {
        $properties += @($Schema.properties.PSObject.Properties.Name)
    }

    if ($Schema.allOf) {
        foreach ($allOfItem in $Schema.allOf) {
            if ($allOfItem.properties) {
                $properties += @($allOfItem.properties.PSObject.Properties.Name)
            }

            if ($allOfItem.'$ref') {
                $refSchemaName = Get-SwaggerRefName -RefPath $allOfItem.'$ref'
                if ($refSchemaName -and -not $Visited.ContainsKey($refSchemaName) -and $AllDefinitions.ContainsKey($refSchemaName)) {
                    $Visited[$refSchemaName] = $true
                    $properties += Get-SchemaPropertyNames -Schema $AllDefinitions[$refSchemaName] -AllDefinitions $AllDefinitions -Visited $Visited
                }
            }
        }
    }

    if ($Schema.'$ref') {
        $refSchemaName = Get-SwaggerRefName -RefPath $Schema.'$ref'
        if ($refSchemaName -and -not $Visited.ContainsKey($refSchemaName) -and $AllDefinitions.ContainsKey($refSchemaName)) {
            $Visited[$refSchemaName] = $true
            $properties += Get-SchemaPropertyNames -Schema $AllDefinitions[$refSchemaName] -AllDefinitions $AllDefinitions -Visited $Visited
        }
    }

    return @($properties | Sort-Object -Unique)
}

# First, extract all schema properties
foreach ($schemaName in $Swagger.definitions.PSObject.Properties.Name) {
    $schema = $Definitions[$schemaName]
    $properties = Get-SchemaPropertyNames -Schema $schema -AllDefinitions $Definitions
    if ($properties.Count -gt 0) {
        $SchemaProperties[$schemaName] = $properties
    }
}

Write-Host "Found $($SchemaProperties.Count) schemas with properties" -ForegroundColor Green

# Now map endpoints to their response schemas
foreach ($path in $Swagger.paths.PSObject.Properties.Name) {
    $pathItem = $Swagger.paths.$path
    
    # We're primarily interested in GET endpoints for filtering
    if ($pathItem.get) {
        $getOp = $pathItem.get
        
        # Check if it has a filter parameter
        $hasFilter = $false
        $parameters = @($pathItem.parameters) + @($getOp.parameters)
        if ($parameters) {
            foreach ($param in $parameters) {
                if ($param.name -eq 'filter') {
                    $hasFilter = $true
                    break
                }
            }
        }
        
        if ($hasFilter) {
            # Extract the Swagger 2.0 response schema
            $responseSchema = $null
            if ($getOp.responses -and $getOp.responses.'200' -and $getOp.responses.'200'.schema) {
                $responseSchema = $getOp.responses.'200'.schema
            }

            if ($responseSchema -and $responseSchema.'$ref') {
                $responseSchemaName = Get-SwaggerRefName -RefPath $responseSchema.'$ref'
                if (-not $responseSchemaName) {
                    continue
                }
                
                # For pagination responses, we need to get the items schema
                if ($responseSchemaName -match 'PaginationResponse$') {
                    $paginationSchema = $Definitions[$responseSchemaName]
                    if ($paginationSchema.properties.items.items.'$ref') {
                        $itemsSchemaRef = $paginationSchema.properties.items.items.'$ref'
                        $itemsSchemaName = Get-SwaggerRefName -RefPath $itemsSchemaRef
                        
                        if ($SchemaProperties[$itemsSchemaName]) {
                            $EndpointToSchema[$path] = @{
                                Schema = $itemsSchemaName
                                Properties = $SchemaProperties[$itemsSchemaName]
                            }
                        }
                    }
                }
                # For non-pagination responses, use the schema directly
                elseif ($SchemaProperties[$responseSchemaName]) {
                    $EndpointToSchema[$path] = @{
                        Schema = $responseSchemaName
                        Properties = $SchemaProperties[$responseSchemaName]
                    }
                }
            }
        }
    }
}

Write-Host "Mapped $($EndpointToSchema.Count) endpoints to schemas" -ForegroundColor Green

# Build the final configuration hashtable
$Config = @{}

foreach ($endpoint in $EndpointToSchema.Keys | Sort-Object) {
    $properties = $EndpointToSchema[$endpoint].Properties
    $schema = $EndpointToSchema[$endpoint].Schema
    
    # Only include properties that actually exist in the schema
    # Don't add special properties if they're not defined in the API
    $Config[$endpoint] = $properties | Sort-Object -Unique
    
    Write-Verbose "Endpoint: $endpoint -> Schema: $schema -> Properties: $($properties.Count)"
}

# Generate the PSD1 file
Write-Host "Generating configuration file: $OutputPath" -ForegroundColor Cyan

$PSD1Content = @"
<#
.SYNOPSIS
Filter field validation configuration generated from public Swagger JSON

.DESCRIPTION
This file contains a mapping of API endpoints to their valid filterable fields.
It is automatically generated by Build-LMFilterValidationConfig.ps1 and should not be manually edited.

Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Swagger endpoints processed: $($EndpointToSchema.Count)
Swagger URL: $SwaggerUrl

.NOTES
To regenerate this file, run: .\Build-LMFilterValidationConfig.ps1
#>

@{
"@

foreach ($endpoint in $Config.Keys | Sort-Object) {
    $properties = $Config[$endpoint]
    $propertiesString = ($properties | ForEach-Object { "'$_'" }) -join ', '
    $PSD1Content += "`n    '$endpoint' = @($propertiesString)"
}

$PSD1Content += "`n}`n"

# Write the file
Set-Content -Path $OutputPath -Value $PSD1Content -Encoding UTF8

Write-Host "Successfully generated configuration file!" -ForegroundColor Green
Write-Host "  Endpoints: $($Config.Keys.Count)" -ForegroundColor Green
Write-Host "  Output: $OutputPath" -ForegroundColor Green

# Display some sample mappings
Write-Host "`nSample mappings:" -ForegroundColor Cyan
$sampleEndpoints = @('/device/devices', '/device/groups', '/alert/alerts') | Where-Object { $Config[$_] }
foreach ($endpoint in $sampleEndpoints) {
    Write-Host "  $endpoint" -ForegroundColor Yellow
    Write-Host "    Fields: $($Config[$endpoint] -join ', ')" -ForegroundColor Gray
}

