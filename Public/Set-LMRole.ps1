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
Function Set-LMRole {

    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param (
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
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Lookup Id if supplying username
        If ($Name) {
            $LookupResult = (Get-LMRole -Name $Name).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }
        
        #Build header and uri
        $ResourcePath = "/setting/roles/$Id"
        $Privileges = @()

        If (!$CustomPrivilegesObject) {

            If ($ViewTraces) {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "tracesManageTab"
                    operation    = "read"
                    subOperation = ""
                }
            }

            If ($EnableRemoteSessionForResources) {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "remoteSession"
                    operation    = "write"
                    subOperation = ""
                }
            }

            If ($AllowedToViewMapsTab) {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "resourceMapTab"
                    operation    = "read"
                    subOperation = ""
                }
            }

            If ($AllowWidgetSharing) {
                $Privileges += [PSCustomObject]@{
                    objectId     = "sharingwidget"
                    objectName   = "sharingwidget"
                    objectType   = "dashboard_group"
                    operation    = "write"
                    subOperation = ""
                }
            }

            If ($CreatePrivateDashboards) {
                $Privileges += [PSCustomObject]@{
                    objectId     = "private"
                    objectName   = "private"
                    objectType   = "dashboard_group"
                    operation    = "write"
                    subOperation = ""
                }
            }

            If ($LMXToolBoxPermission) {
                $Privileges += [PSCustomObject]@{
                    objectId   = "allinstalledmodules"
                    objectName = "All installed modules"
                    objectType = "module"
                    operation  = $LMXToolBoxPermission
                }
            }

            If ($LMXPermission) {
                $Privileges += [PSCustomObject]@{
                    objectId   = "All exchange modules"
                    objectName = "private"
                    objectType = "module"
                    operation  = $LMXPermission
                }
            }
            
            If ($ViewSupport) {
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

            If ($ConfigTabRequiresManagePermission) {
                $Privileges += [PSCustomObject]@{
                    objectId     = ""
                    objectName   = "configNeedDeviceManagePermission"
                    objectType   = "configNeedDeviceManagePermission"
                    operation    = "write"
                    subOperation = ""
                }
            }

            If ($AllowedToManageResourceDashboards) {
                $Privileges += [PSCustomObject]@{
                    objectId     = ""
                    objectName   = "deviceDashboard"
                    objectType   = "deviceDashboard"
                    operation    = "write"
                    subOperation = ""
                }
            }

            If ($DashboardsPermission -ne "none") {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "dashboard_group"
                    operation    = If ($DashboardsPermission -eq "manage") { "write" }Else { "read" }
                    subOperation = ""
                }
            }

            If ($ResourcePermission -ne "none") {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "host_group"
                    operation    = If ($ResourcePermission -eq "manage") { "write" }Else { "read" }
                    subOperation = ""
                }
            }

            If ($LogsPermission -ne "none") {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "logs"
                    operation    = If ($LogsPermission -eq "manage") { "write" }Else { "read" }
                    subOperation = ""
                }
            }

            If ($WebsitesPermission -ne "none") {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "website_group"
                    operation    = If ($WebsitesPermission -eq "manage") { "write" }Else { "read" }
                    subOperation = ""
                }
            }

            If ($SavedMapsPermission -ne "none") {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "map"
                    operation    = If ($SavedMapsPermission -eq "manage") { "write" }Else { "read" }
                    subOperation = ""
                }
            }

            If ($ReportsPermission -ne "none") {
                $Privileges += [PSCustomObject]@{
                    objectId     = "*"
                    objectName   = "*"
                    objectType   = "report_group"
                    operation    = If ($ReportsPermission -eq "manage") { "write" }Else { "read" }
                    subOperation = ""
                }
            }

            If ($SettingsPermission -ne "none") {
                If ($SettingsPermission -ne "manage-collectors" -and $SettingsPermission -ne "view-collectors") {
                    $Privileges += [PSCustomObject]@{
                        objectId     = "*"
                        objectName   = "*"
                        objectType   = "setting"
                        operation    = If ($SettingsPermission -eq "manage") { "write" }Else { "read" }
                        subOperation = ""
                    }

                    $Privileges += [PSCustomObject]@{
                        objectId     = "useraccess.*"
                        objectName   = "useraccess.*"
                        objectType   = "setting"
                        operation    = If ($ResourcePermission -eq "manage") { "write" }Else { "read" }
                        subOperation = ""
                    }
                }
                Else {
                    $Privileges += [PSCustomObject]@{
                        objectId   = "collectorgroup.*"
                        objectName = "Collectors"
                        objectType = "setting"
                        operation  = If ($SettingsPermission -eq "manage-collectors") { "write" }Else { "read" }
                    }
                }
            }
        }

        Try {
            $Data = @{
                customHelpLabel = $CustomHelpLabel
                customHelpURL   = $CustomHelpURL
                description     = $Description
                name            = $NewName
                requireEULA     = If ($RequireEULA.IsPresent) { "true" }Else { "" }
                roleGroupId     = $RoleGroupId
                twoFARequired   = If ($TwoFARequired.IsPresent) { "true" }Else { "" }
                privileges      = If ($CustomPrivilegesObject) { $CustomPrivilegesObject }Else { $Privileges }
            }

            #Remove empty keys so we dont overwrite them
            @($Data.Keys) | ForEach-Object {
                if ($_ -eq 'name') {
                    if ('NewName' -notin $PSBoundParameters.Keys) { $Data.Remove($_) }
                } else {
                    if ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) }
                }
            }

            $Data = ($Data | ConvertTo-Json)
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Role" )
        }
        Catch [Exception] {
            $Proceed = Resolve-LMException -LMException $PSItem
            If (!$Proceed) {
                Return
            }
        }
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
