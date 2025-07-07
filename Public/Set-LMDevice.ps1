<#
.SYNOPSIS
Updates a LogicMonitor device configuration.

.DESCRIPTION
The Set-LMDevice function modifies an existing device in LogicMonitor, allowing updates to its name, display name, description, collector settings, and various other properties.

.PARAMETER Id
Specifies the ID of the device to modify. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the current name of the device. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER NewName
Specifies the new name for the device.

.PARAMETER DisplayName
Specifies the new display name for the device.

.PARAMETER Description
Specifies the new description for the device.

.PARAMETER PreferredCollectorId
Specifies the ID of the preferred collector for the device.

.PARAMETER PreferredCollectorGroupId
Specifies the ID of the preferred collector group for the device.

.PARAMETER AutoBalancedCollectorGroupId
Specifies the ID of the auto-balanced collector group for the device.

.PARAMETER Properties
Specifies a hashtable of custom properties for the device.

.PARAMETER PropertiesMethod
Specifies how to handle existing properties. Valid values are "Add", "Replace", or "Refresh". Default is "Replace".

.PARAMETER HostGroupIds
Specifies an array of host group IDs to associate with the device.

.PARAMETER Link
Specifies the URL link associated with the device.

.PARAMETER DisableAlerting
Specifies whether to disable alerting for the device.

.PARAMETER EnableNetFlow
Specifies whether to enable NetFlow for the device.

.PARAMETER NetflowCollectorGroupId
Specifies the ID of the NetFlow collector group.

.PARAMETER NetflowCollectorId
Specifies the ID of the NetFlow collector.

.PARAMETER EnableLogCollector
Specifies whether to enable log collection for the device.

.PARAMETER LogCollectorGroupId
Specifies the ID of the log collector group.

.PARAMETER LogCollectorId
Specifies the ID of the log collector.

.EXAMPLE
Set-LMDevice -Id 123 -NewName "UpdatedDevice" -Description "New description"
Updates the device with ID 123 with a new name and description.

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns a LogicMonitor.Device object containing the updated device information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
function Set-LMDevice {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [String]$NewName,

        [String]$DisplayName,

        [String]$Description,

        [Nullable[Int]]$PreferredCollectorId,

        [Nullable[Int]]$PreferredCollectorGroupId,

        [Nullable[Int]]$AutoBalancedCollectorGroupId,

        [Hashtable]$Properties,

        [String[]]$HostGroupIds, #Dynamic group ids will be ignored, operation will replace all existing groups

        [ValidateSet("Add", "Replace", "Refresh")] # Add will append to existing prop, Replace will update existing props if specified and add new props, refresh will replace existing props with new
        [String]$PropertiesMethod = "Replace",

        [String]$Link,

        [Nullable[boolean]]$DisableAlerting,

        [Nullable[boolean]]$EnableNetFlow,

        [Nullable[Int]]$NetflowCollectorGroupId,

        [Nullable[Int]]$NetflowCollectorId,

        [Nullable[boolean]]$EnableLogCollector,

        [Nullable[Int]]$LogCollectorGroupId,

        [Nullable[Int]]$LogCollectorId
    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Lookup ParentGroupName
            if ($Name) {
                $LookupResult = (Get-LMDevice -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build custom props hashtable
            $customProperties = @()
            if ($Properties) {
                foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }

            #Build header and uri
            $ResourcePath = "/device/devices/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name) | DisplayName: $($PSItem.displayName)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            else {
                $Message = "Id: $Id"
            }

            $Data = @{
                name                              = $NewName
                displayName                       = $DisplayName
                description                       = $Description
                disableAlerting                   = $DisableAlerting
                enableNetflow                     = $EnableNetFlow
                customProperties                  = $customProperties
                preferredCollectorId              = $PreferredCollectorId
                preferredCollectorGroupId         = $PreferredCollectorGroupId
                autoBalancedCollectorGroupId      = $AutoBalancedCollectorGroupId
                link                              = $Link
                netflowCollectorGroupId           = $NetflowCollectorGroupId
                netflowCollectorId                = $NetflowCollectorId
                isPreferredLogCollectorConfigured = $EnableLogCollector
                logCollectorGroupId               = $LogCollectorGroupId
                logCollectorId                    = $LogCollectorId
                hostGroupIds                      = $HostGroupIds -join ","
            }


            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                -ConditionalKeep @{ 'name' = 'NewName' } `
                -ConditionalValueKeep @{ 'PropertiesMethod' = @(@{ Value = 'Refresh'; KeepKeys = @('customProperties') }) } `
                -Context @{ PropertiesMethod = $PropertiesMethod }

            if ($PSCmdlet.ShouldProcess($Message, "Set Device")) {
                
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + "?opType=$($PropertiesMethod.ToLower())"

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request using new centralized method with retry logic
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Device" )

            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
