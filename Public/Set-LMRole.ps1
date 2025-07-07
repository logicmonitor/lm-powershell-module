<#
.SYNOPSIS
Updates a LogicMonitor role configuration.

.DESCRIPTION
The Set-LMRole function modifies an existing role in LogicMonitor, including its permissions and privileges.

.PARAMETER Id
Specifies the ID of the role to modify.

.PARAMETER Name
Specifies the current name of the role.

.PARAMETER NewName
Specifies the new name for the role.

.PARAMETER CustomHelpLabel
Specifies the custom help label for the role.

.PARAMETER CustomHelpURL
Specifies the custom help URL for the role.

.PARAMETER Description
Specifies the description for the role.

.PARAMETER RequireEULA
Indicates whether to require EULA acceptance.

.PARAMETER TwoFARequired
Indicates whether to require two-factor authentication.

.PARAMETER RoleGroupId
Specifies the role group ID.

.PARAMETER CustomPrivilegesObject
Specifies custom privileges for the role.

.PARAMETER DashboardsPermission
Specifies dashboard permissions. Valid values: "view", "manage", "none".

.PARAMETER ResourcePermission
Specifies resource permissions. Valid values: "view", "manage", "none".

.PARAMETER SettingsPermission
Specifies settings permissions. Valid values: "view", "manage", "none", "manage-collectors", "view-collectors".

.EXAMPLE
Set-LMRole -Id 123 -NewName "Updated Role" -Description "New description" -DashboardsPermission "view"
Updates the role with new name, description, and dashboard permissions.

.INPUTS
None.

.OUTPUTS
Returns a LogicMonitor.Role object containing the updated role configuration.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
function Set-LMRole {

    [CmdletBinding(DefaultParameterSetName = 'Default', SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id-Custom', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Id-Default', ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name-Custom')]
        [Parameter(Mandatory, ParameterSetName = 'Name-Default')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Id-Custom')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [Parameter(ParameterSetName = 'Name-Custom')]
        [Parameter(ParameterSetName = 'Name-Default')]
        [String]$NewName,

        [Parameter(ParameterSetName = 'Id-Custom')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [Parameter(ParameterSetName = 'Name-Custom')]
        [Parameter(ParameterSetName = 'Name-Default')]
        [String]$CustomHelpLabel,

        [Parameter(ParameterSetName = 'Id-Custom')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [Parameter(ParameterSetName = 'Name-Custom')]
        [Parameter(ParameterSetName = 'Name-Default')]
        [String]$CustomHelpURL,

        [Parameter(ParameterSetName = 'Id-Custom')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [Parameter(ParameterSetName = 'Name-Custom')]
        [Parameter(ParameterSetName = 'Name-Default')]
        [String]$Description,

        [Parameter(ParameterSetName = 'Id-Custom')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [Parameter(ParameterSetName = 'Name-Custom')]
        [Parameter(ParameterSetName = 'Name-Default')]
        [Switch]$RequireEULA,

        [Parameter(ParameterSetName = 'Id-Custom')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [Parameter(ParameterSetName = 'Name-Custom')]
        [Parameter(ParameterSetName = 'Name-Default')]
        [Switch]$TwoFARequired,

        [Parameter(ParameterSetName = 'Id-Custom')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [Parameter(ParameterSetName = 'Name-Custom')]
        [Parameter(ParameterSetName = 'Name-Default')]
        [String]$RoleGroupId,

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [ValidateSet("view", "manage", "none")]
        [String]$DashboardsPermission = "none",

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [ValidateSet("view", "manage", "none")]
        [String]$ResourcePermission = "none",

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [ValidateSet("view", "manage", "commit", "publish", "none")]
        [String]$LMXToolBoxPermission = "none",

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [ValidateSet("view", "install", "none")]
        [String]$LMXPermission = "none",

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [ValidateSet("view", "manage", "none")]
        [String]$LogsPermission = "none",

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [ValidateSet("view", "manage", "none")]
        [String]$WebsitesPermission = "none",

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [ValidateSet("view", "manage", "none")]
        [String]$SavedMapsPermission = "none",

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [ValidateSet("view", "manage", "none")]
        [String]$ReportsPermission = "none",

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [ValidateSet("view", "manage", "none", "manage-collectors", "view-collectors")]
        [String]$SettingsPermission = "none",

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [Switch]$CreatePrivateDashboards,

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [Switch]$AllowWidgetSharing,

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [Switch]$ConfigTabRequiresManagePermission,

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [Switch]$AllowedToViewMapsTab,

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [Switch]$AllowedToManageResourceDashboards,

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [Switch]$ViewTraces,

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [Switch]$ViewSupport,

        [Parameter(ParameterSetName = 'Name-Default')]
        [Parameter(ParameterSetName = 'Id-Default')]
        [Switch]$EnableRemoteSessionForResources,

        [Parameter(Mandatory, ParameterSetName = 'Name-Custom')]
        [Parameter(Mandatory, ParameterSetName = 'Id-Custom')]
        [PSCustomObject]$CustomPrivilegesObject

    )

    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Lookup Id if supplying username
            if ($Name) {
                $LookupResult = (Get-LMRole -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/setting/roles/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            else {
                $Message = "Id: $Id"
            }

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

                if ($ConfigTabRequiresManagePermission) {
                    $Privileges += [PSCustomObject]@{
                        objectId     = ""
                        objectName   = "configNeedDeviceManagePermission"
                        objectType   = "configNeedDeviceManagePermission"
                        operation    = "write"
                        subOperation = ""
                    }
                }

                if ($AllowedToManageResourceDashboards) {
                    $Privileges += [PSCustomObject]@{
                        objectId     = ""
                        objectName   = "deviceDashboard"
                        objectType   = "deviceDashboard"
                        operation    = "write"
                        subOperation = ""
                    }
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
                name            = $NewName
                requireEULA     = if ($RequireEULA.IsPresent) { "true" }else { "" }
                roleGroupId     = $RoleGroupId
                twoFARequired   = if ($TwoFARequired.IsPresent) { "true" }else { "" }
                privileges      = if ($CustomPrivilegesObject) { $CustomPrivilegesObject }else { $Privileges }
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                -ConditionalKeep @{ 'name' = 'NewName' }

            if ($PSCmdlet.ShouldProcess($Message, "Set Role")) {
                try {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request using new centralized method with retry logic
                    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Role" )
                }
                catch {

                    return
                }
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
}
