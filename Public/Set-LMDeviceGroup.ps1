<#
.SYNOPSIS
Updates a LogicMonitor device group configuration.

.DESCRIPTION
The Set-LMDeviceGroup function modifies an existing device group in LogicMonitor, allowing updates to its name, description, properties, and various other settings.

.PARAMETER Id
Specifies the ID of the device group to modify.

.PARAMETER Name
Specifies the current name of the device group.

.PARAMETER NewName
Specifies the new name for the device group.

.PARAMETER Description
Specifies the new description for the device group.

.PARAMETER Properties
Specifies a hashtable of custom properties for the device group.

.PARAMETER PropertiesMethod
Specifies how to handle existing properties. Valid values are "Add", "Replace", or "Refresh". Default is "Replace".

.PARAMETER DisableAlerting
Specifies whether to disable alerting for the device group.

.PARAMETER EnableNetFlow
Specifies whether to enable NetFlow for the device group.

.PARAMETER AppliesTo
Specifies the applies to expression for the device group.

.PARAMETER ParentGroupId
Specifies the ID of the parent group.

.PARAMETER ParentGroupName
Specifies the name of the parent group.

.EXAMPLE
Set-LMDeviceGroup -Id 123 -NewName "Updated Group" -Description "New description"
Updates the device group with ID 123 with a new name and description.

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns a LogicMonitor.DeviceGroup object containing the updated group information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
function Set-LMDeviceGroup {

    [CmdletBinding(DefaultParameterSetName = "Id-ParentGroupId", SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id-ParentGroupId', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Id-ParentGroupName')]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name-ParentGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-ParentGroupName')]
        [String]$Name,

        [String]$NewName,

        [String]$Description,

        [Hashtable]$Properties,

        [Nullable[Int]]$DefaultCollectorId,

        [Nullable[Int]]$DefaultAutoBalancedCollectorGroupId,

        [Nullable[Int]]$DefaultCollectorGroupId,

        [ValidateSet("Add", "Replace", "Refresh")] # Add will append to existing prop, Replace will update existing props if specified and add new props, refresh will replace existing props with new
        [String]$PropertiesMethod = "Replace",

        [Nullable[boolean]]$DisableAlerting,

        [Nullable[boolean]]$EnableNetFlow,

        [String]$AppliesTo,

        [Parameter(ParameterSetName = 'Id-ParentGroupId')]
        [Parameter(ParameterSetName = 'Name-ParentGroupId')]
        [Nullable[Int]]$ParentGroupId,

        [Parameter(ParameterSetName = 'Id-ParentGroupName')]
        [Parameter(ParameterSetName = 'Name-ParentGroupName')]
        [String]$ParentGroupName
    )
    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Lookup Group Id
            if ($Name) {
                $LookupResult = (Get-LMDeviceGroup -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Lookup ParentGroupId
            if ($ParentGroupName) {
                $LookupResult = (Get-LMDeviceGroup -Name $ParentGroupName).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $ParentGroupName) {
                    return
                }
                $ParentGroupId = $LookupResult
            }

            #Build custom props hashtable
            $customProperties = @()
            if ($Properties) {
                foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }

            #Build header and uri
            $ResourcePath = "/device/groups/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name) | Path: $($PSItem.fullPath)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name)"
            }
            else {
                $Message = "Id: $Id"
            }

            $Data = @{
                name             = $NewName
                description      = $Description
                appliesTo        = $AppliesTo
                disableAlerting  = $DisableAlerting
                defaultAutoBalancedCollectorGroupId = $DefaultAutoBalancedCollectorGroupId
                defaultCollectorGroupId             = $DefaultCollectorGroupId
                defaultCollectorId                  = $DefaultCollectorId
                enableNetflow    = $EnableNetFlow
                customProperties = $customProperties
                parentId         = $ParentGroupId
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                -ConditionalKeep @{ 'name' = 'NewName' } `
                -ConditionalValueKeep @{ 'PropertiesMethod' = @(@{ Value = 'Refresh'; KeepKeys = @('customProperties') }) } `
                -Context @{ PropertiesMethod = $PropertiesMethod }

            if ($PSCmdlet.ShouldProcess($Message, "Set Device Group")) {
                
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + "?opType=$($PropertiesMethod.ToLower())"

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request using new centralized method with retry logic
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceGroup" )

            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
