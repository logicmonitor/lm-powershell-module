<#
.SYNOPSIS
Creates a new LogicMonitor Service template.

.DESCRIPTION
The New-LMServiceTemplate function creates a new LogicMonitor Service template with the specified parameters.

.PARAMETER Name
The name of the Service template. This parameter is mandatory.

.PARAMETER Description
The description of the Service template.

.PARAMETER Cardinality
Array of cardinality properties with name and type properties.

.PARAMETER PropertySelector
Array of property selector objects for filtering.

.PARAMETER Properties
Array of properties to add to the services with id, value, and type.

.PARAMETER ServiceNamingPattern
Array of strings defining the service naming pattern.

.PARAMETER CreateGroup
Specifies whether to create groups for the service. Default is $true.

.PARAMETER GroupNamingPattern
Array of strings defining the group naming pattern.

.PARAMETER DefaultCriticality
The default criticality level. Default is "Medium".

.PARAMETER MembershipEvaluationInterval
The membership evaluation interval in minutes. Default is 30.

.PARAMETER FilterType
The filter type. Default is "2".

.EXAMPLE
New-LMServiceTemplate -Name "Application Services by Site" -Description "Default LM service template for application services"

This example creates a new LogicMonitor Service template with basic parameters.

.NOTES
This function requires a valid LogicMonitor API authentication. Use Connect-LMAccount to authenticate before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.ServiceTemplate object.
#>
function New-LMServiceTemplate {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [Array]$Cardinality,

        [Array]$PropertySelector,

        [Array]$Properties,

        [Array]$ServiceNamingPattern,

        [Boolean]$CreateGroup = $true,

        [Array]$GroupNamingPattern,

        [String]$DefaultCriticality = "Medium",

        [String]$MembershipEvaluationInterval = "30",

        [String]$FilterType = "2",

        [Array]$ResourceGroupRecords = @(),

        [Array]$Criticality = @(),

        [Array]$StaticGroup = @()
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/serviceTemplates/create"

        #Build the service template data structure
        $ServiceTemplateData = @{
            description = $Description
            filterType = $FilterType
            cardinality = $Cardinality
            propertySelector = $PropertySelector
            membershipEvaluationInterval = $MembershipEvaluationInterval
            resourceGroupRecords = $ResourceGroupRecords
            properties = $Properties
            serviceNamingPattern = $ServiceNamingPattern
            groupNamingPattern = $GroupNamingPattern
            model = "RestServiceTemplate"
            name = $Name
            defaultCriticality = $DefaultCriticality
            createGroup = $CreateGroup
            criticality = $Criticality
            staticGroup = $StaticGroup
        }

        #Build the complete payload structure
        $Data = @{
            data = @{
                items = @($ServiceTemplateData)
            }
            meta = @{
                addFromWizard = $false
            }
        }

        $Data = ($Data | ConvertTo-Json -Depth 10)

        $Message = "Name: $Name"

        if ($PSCmdlet.ShouldProcess($Message, "Create Service Template")) {
            
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Version 4
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.ServiceTemplate" )

        }
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}