<#
.SYNOPSIS
Development tool to generate filter field validation configuration from swagger YAML.

.DESCRIPTION
This script parses the logicmonitor-api.yaml file to extract all API endpoints and their
response schemas. It then maps each endpoint to the properties available in the response
model, creating a validation configuration file that can be used at runtime to validate
filter fields before sending API requests.

.EXAMPLE
.\Build-LMFilterValidationConfig.ps1

This will generate Private/LMFilterValidationConfig.psd1 with all endpoint-to-fields mappings.

.NOTES
This is a development-time tool and should be run whenever the swagger file is updated.
Requires the powershell-yaml module for parsing YAML files.
#>

[CmdletBinding()]
param()

# Check if powershell-yaml module is available
if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
    Write-Warning "The powershell-yaml module is required to parse the swagger YAML file."
    Write-Warning "Install it with: Install-Module -Name powershell-yaml"
    Write-Warning "Attempting to install now..."
    try {
        Install-Module -Name powershell-yaml -Scope CurrentUser -Force -AllowClobber
        Write-Host "Successfully installed powershell-yaml module" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to install powershell-yaml module. Please install it manually."
        return
    }
}

Import-Module powershell-yaml

$SwaggerPath = Join-Path $PSScriptRoot "logicmonitor-api.yaml"
$OutputPath = Join-Path $PSScriptRoot "Private/LMFilterValidationConfig.psd1"

if (-not (Test-Path $SwaggerPath)) {
    Write-Error "Swagger file not found at: $SwaggerPath"
    return
}

Write-Host "Parsing swagger file: $SwaggerPath" -ForegroundColor Cyan

# Parse the YAML file
$SwaggerContent = Get-Content -Path $SwaggerPath -Raw
$Swagger = ConvertFrom-Yaml -Yaml $SwaggerContent

Write-Host "Extracting API endpoints and schemas..." -ForegroundColor Cyan

# Build endpoint to schema mapping
$EndpointToSchema = @{}
$SchemaProperties = @{}

# First, extract all schema properties
foreach ($schemaName in $Swagger.components.schemas.Keys) {
    $schema = $Swagger.components.schemas[$schemaName]
    $properties = @()
    
    if ($schema.properties) {
        $properties += $schema.properties.Keys
    }
    
    # Handle allOf (inheritance)
    if ($schema.allOf) {
        foreach ($allOfItem in $schema.allOf) {
            if ($allOfItem.properties) {
                $properties += $allOfItem.properties.Keys
            }
            # Handle $ref in allOf
            if ($allOfItem.'$ref') {
                $refSchema = $allOfItem.'$ref' -replace '#/components/schemas/', ''
                # We'll resolve these in a second pass
            }
        }
    }
    
    if ($properties.Count -gt 0) {
        $SchemaProperties[$schemaName] = $properties | Sort-Object -Unique
    }
}

Write-Host "Found $($SchemaProperties.Count) schemas with properties" -ForegroundColor Green

# Now map endpoints to their response schemas
foreach ($path in $Swagger.paths.Keys) {
    $pathItem = $Swagger.paths[$path]
    
    # We're primarily interested in GET endpoints for filtering
    if ($pathItem.get) {
        $getOp = $pathItem.get
        
        # Check if it has a filter parameter
        $hasFilter = $false
        if ($getOp.parameters) {
            foreach ($param in $getOp.parameters) {
                if ($param.name -eq 'filter') {
                    $hasFilter = $true
                    break
                }
            }
        }
        
        if ($hasFilter) {
            # Extract the response schema
            if ($getOp.responses.'200'.content.'application/json'.schema.'$ref') {
                $responseSchemaRef = $getOp.responses.'200'.content.'application/json'.schema.'$ref'
                $responseSchemaName = $responseSchemaRef -replace '#/components/schemas/', ''
                
                # For pagination responses, we need to get the items schema
                if ($responseSchemaName -match 'PaginationResponse$') {
                    $paginationSchema = $Swagger.components.schemas[$responseSchemaName]
                    if ($paginationSchema.properties.items.items.'$ref') {
                        $itemsSchemaRef = $paginationSchema.properties.items.items.'$ref'
                        $itemsSchemaName = $itemsSchemaRef -replace '#/components/schemas/', ''
                        
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
Filter field validation configuration generated from logicmonitor-api.yaml

.DESCRIPTION
This file contains a mapping of API endpoints to their valid filterable fields.
It is automatically generated by Build-LMFilterValidationConfig.ps1 and should not be manually edited.

Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Swagger endpoints processed: $($EndpointToSchema.Count)

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

