<#
.SYNOPSIS
    Creates a new Logic Monitor role with specified privileges.

.DESCRIPTION
    The New-LMRole function creates a new Logic Monitor role with the specified privileges and settings. It allows you to customize various permissions and options for the role.

.PARAMETER Name
    Specifies the name of the role.

.PARAMETER CustomHelpLabel
    Specifies a custom label for the help button in the Logic Monitor UI.

.PARAMETER CustomHelpURL
    Specifies a custom URL for the help button in the Logic Monitor UI.

.PARAMETER Description
    Specifies a description for the role.

.PARAMETER RequireEULA
    Indicates whether the user must accept the End User License Agreement (EULA) before using the role.

.PARAMETER TwoFARequired
    Indicates whether two-factor authentication is required for the role. Default value is $true.

.PARAMETER RoleGroupId
    Specifies the ID of the role group to which the role belongs. Default value is 1.

.PARAMETER DashboardsPermission
    Specifies the permission level for dashboards. Valid values are "view", "manage", or "none". Default value is "none".

.PARAMETER ResourcePermission
    Specifies the permission level for resources. Valid values are "view", "manage", or "none". Default value is "none".

.PARAMETER LogsPermission
    Specifies the permission level for logs. Valid values are "view", "manage", or "none". Default value is "none".

.PARAMETER WebsitesPermission
    Specifies the permission level for websites. Valid values are "view", "manage", or "none". Default value is "none".

.PARAMETER SavedMapsPermission
    Specifies the permission level for saved maps. Valid values are "view", "manage", or "none". Default value is "none".

.PARAMETER ReportsPermission
    Specifies the permission level for reports. Valid values are "view", "manage", or "none". Default value is "none".

.PARAMETER LMXToolBoxPermission
    Specifies the permission level for LMX Toolbox. Valid values are "view", "manage", "commit", "publish", or "none". Default value is "none".

.PARAMETER LMXPermission
    Specifies the permission level for LMX. Valid values are "view", "install", or "none". Default value is "none".

.PARAMETER SettingsPermission
    Specifies the permission level for settings. Valid values are "view", "manage", "none", "manage-collectors", or "view-collectors". Default value is "none".

.PARAMETER CreatePrivateDashboards
    Indicates whether the role can create private dashboards.

.PARAMETER AllowWidgetSharing
    Indicates whether the role can share widgets.

.PARAMETER ConfigTabRequiresManagePermission
    Indicates whether the role requires manage permission for the Config tab.

.PARAMETER AllowedToViewMapsTab
    Indicates whether the role can view the Maps tab.

.PARAMETER AllowedToManageResourceDashboards
    Indicates whether the role can manage resource dashboards.

.PARAMETER ViewTraces
    Indicates whether the role can view traces.

.PARAMETER ViewSupport
    Indicates whether the role can view support.

.PARAMETER EnableRemoteSessionForResources
    Indicates whether the role can enable remote session for resources.

.PARAMETER CustomPrivilegesObject
    Specifies a custom privileges object for the role.

.EXAMPLE
    New-LMRole -Name "MyRole" -Description "Custom role with limited permissions" -DashboardsPermission "view" -ResourcePermission "manage"

    This example creates a new Logic Monitor role named "MyRole" with a description and limited permissions for dashboards and resources.

.NOTES
    You must run Connect-LMAccount before running this command.

.INPUTS
    None. You cannot pipe objects to this command.

.OUTPUTS
    Returns LogicMonitor.Role object.

#>
function New-LMRole {

    [CmdletBinding(DefaultParameterSetName = 'Default', SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Custom')]
        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Custom')]
        [String]$CustomHelpLabel,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Custom')]
        [String]$CustomHelpURL,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Custom')]
        [String]$Description,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Custom')]
        [Switch]$RequireEULA,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Custom')]
        [Boolean]$TwoFARequired = $true,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Custom')]
        [String]$RoleGroupId = 1,

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("view", "manage", "none")]
        [String]$DashboardsPermission = "none",

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("view", "manage", "none")]
        [String]$ResourcePermission = "none",

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("view", "manage", "none")]
        [String]$LogsPermission = "none",

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("view", "manage", "none")]
        [String]$WebsitesPermission = "none",

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("view", "manage", "none")]
        [String]$SavedMapsPermission = "none",

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("view", "manage", "none")]
        [String]$ReportsPermission = "none",

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("view", "manage", "commit", "publish", "none")]
        [String]$LMXToolBoxPermission = "none",

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("view", "install", "none")]
        [String]$LMXPermission = "none",

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("view", "manage", "none", "manage-collectors", "view-collectors")]
        [String]$SettingsPermission = "none",

        [Parameter(ParameterSetName = 'Default')]
        [Switch]$CreatePrivateDashboards,

        [Parameter(ParameterSetName = 'Default')]
        [Switch]$AllowWidgetSharing,

        [Parameter(ParameterSetName = 'Default')]
        [Switch]$ConfigTabRequiresManagePermission,

        [Parameter(ParameterSetName = 'Default')]
        [Switch]$AllowedToViewMapsTab,

        [Parameter(ParameterSetName = 'Default')]
        [Switch]$AllowedToManageResourceDashboards,

        [Parameter(ParameterSetName = 'Default')]
        [Switch]$ViewTraces,

        [Parameter(ParameterSetName = 'Default')]
        [Switch]$ViewSupport,

        [Parameter(ParameterSetName = 'Default')]
        [Switch]$EnableRemoteSessionForResources,

        [Parameter(Mandatory, ParameterSetName = 'Custom')]
        [PSCustomObject]$CustomPrivilegesObject

    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {


        #Build header and uri
        $ResourcePath = "/setting/roles"
        $Privileges = @()

        if (!$CustomPrivilegesObject) {

            if ($ViewTraces) {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "tracesManageTab"
                    operation    = "read"
                    subOperation = ""
                }
            }

            if ($EnableRemoteSessionForResources) {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "remoteSession"
                    operation    = "write"
                    subOperation = ""
                }
            }

            if ($AllowedToViewMapsTab) {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "resourceMapTab"
                    operation    = "read"
                    subOperation = ""
                }
            }

            if ($AllowWidgetSharing) {
                $Privileges += [PSCustomObject]@{
                    objectId     = "sharingwidget"
                    objectName   = "sharingwidget"
                    objectType   = "dashboard_group"
                    operation    = "write"
                    subOperation = ""
                }
            }

            if ($CreatePrivateDashboards) {
                $Privileges += [PSCustomObject]@{
                    objectId     = "private"
                    objectName   = "private"
                    objectType   = "dashboard_group"
                    operation    = "write"
                    subOperation = ""
                }
            }

            if ($LMXToolBoxPermission) {
                $Privileges += [PSCustomObject]@{
                    objectId   = "allinstalledmodules"
                    objectName = "All installed modules"
                    objectType = "module"
                    operation  = $LMXToolBoxPermission
                }
            }

            if ($LMXPermission) {
                $Privileges += [PSCustomObject]@{
                    objectId   = "All exchange modules"
                    objectName = "private"
                    objectType = "module"
                    operation  = $LMXPermission
                }
            }

            if ($ViewSupport) {
                $Privileges += [PSCustomObject]@{
                    objectId     = "chat"
                    objectName   = "help"
                    objectType   = "help"
                    operation    = "write"
                    subOperation = ""
                }
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "help"
                    objectType   = "help"
                    operation    = "read"
                    subOperation = ""
                }
            }
            else {
                $Privileges += [PSCustomObject]@{
                    objectId     = "chat"
                    objectName   = "help"
                    objectType   = "help"
                    operation    = "read"
                    subOperation = ""
                }
            }

            $Privileges += [PSCustomObject]@{
                objectId     = ""
                objectName   = "configNeedDeviceManagePermission"
                objectType   = "configNeedDeviceManagePermission"
                operation    = if ($ConfigTabRequiresManagePermission) { "write" }else { "read" }
                subOperation = ""
            }

            $Privileges += [PSCustomObject]@{
                objectId     = ""
                objectName   = "deviceDashboard"
                objectType   = "deviceDashboard"
                operation    = if ($AllowedToManageResourceDashboards) { "write" }else { "read" }
                subOperation = ""
            }

            if ($DashboardsPermission -ne "none") {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "dashboard_group"
                    operation    = if ($DashboardsPermission -eq "manage") { "write" }else { "read" }
                    subOperation = ""
                }
            }

            if ($ResourcePermission -ne "none") {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "host_group"
                    operation    = if ($ResourcePermission -eq "manage") { "write" }else { "read" }
                    subOperation = ""
                }
            }

            if ($LogsPermission -ne "none") {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "logs"
                    operation    = if ($LogsPermission -eq "manage") { "write" }else { "read" }
                    subOperation = ""
                }
            }

            if ($WebsitesPermission -ne "none") {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "website_group"
                    operation    = if ($WebsitesPermission -eq "manage") { "write" }else { "read" }
                    subOperation = ""
                }
            }

            if ($SavedMapsPermission -ne "none") {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "map"
                    operation    = if ($SavedMapsPermission -eq "manage") { "write" }else { "read" }
                    subOperation = ""
                }
            }

            if ($ReportsPermission -ne "none") {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "report_group"
                    operation    = if ($ReportsPermission -eq "manage") { "write" }else { "read" }
                    subOperation = ""
                }
            }

            if ($SettingsPermission -ne "none") {
                if ($SettingsPermission -ne "manage-collectors" -and $SettingsPermission -ne "view-collectors") {
                    $Privileges += [PSCustomObject]@{
                        objectId     = "*"
                        objectName   = "*"
                        objectType   = "setting"
                        operation    = if ($SettingsPermission -eq "manage") { "write" }else { "read" }
                        subOperation = ""
                    }

                    $Privileges += [PSCustomObject]@{
                        objectId     = "useraccess.*"
                        objectName   = "useraccess.*"
                        objectType   = "setting"
                        operation    = if ($ResourcePermission -eq "manage") { "write" }else { "read" }
                        subOperation = ""
                    }
                }
                else {
                    $Privileges += [PSCustomObject]@{
                        objectId   = "collectorgroup.*"
                        objectName = "Collectors"
                        objectType = "setting"
                        operation  = if ($SettingsPermission -eq "manage-collectors") { "write" }else { "read" }
                    }
                }
            }

        }

        $Data = @{
            customHelpLabel = $CustomHelpLabel
            customHelpURL   = $CustomHelpURL
            description     = $Description
            name            = $Name
            requireEULA     = $RequireEULA.IsPresent
            roleGroupId     = $RoleGroupId
            twoFARequired   = $TwoFARequired
            privileges      = if ($CustomPrivilegesObject) { $CustomPrivilegesObject }else { $Privileges }
        }

        #Remove empty keys so we dont overwrite them
        $Data = Format-LMData `
            -Data $Data `
            -UserSpecifiedKeys @()

        $Message = "Name: $Name"

        if ($PSCmdlet.ShouldProcess($Message, "Create Role")) {
            
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Role" )

        }
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
