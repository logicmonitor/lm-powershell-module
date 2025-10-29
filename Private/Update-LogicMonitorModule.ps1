<#
.SYNOPSIS
    Updates LogicMonitor modules to the latest version.

.DESCRIPTION
    The Update-LogicMonitorModule function is used to update LogicMonitor modules to the latest version. It checks the currently installed version of the module and compares it with the latest version available online. If a newer version is found, it uninstalls the old version and installs the newer version.

.PARAMETER Modules
    Specifies the LogicMonitor modules to update. By default, it updates both 'Logic.Monitor' and 'Logic.Monitor.SE' modules. You can provide an array of module names to update multiple modules.

.PARAMETER UninstallFirst
    Specifies whether to uninstall the old version before installing the newer version. By default, it is set to $False, which means the old version will not be uninstalled.

.PARAMETER CheckOnly
    Specifies whether to only check for updates without performing any installations. If this switch is used, it will display a message indicating the outdated version and suggest upgrading to the latest version.

.EXAMPLE
    Update-LogicMonitorModule -Modules @('Logic.Monitor')

    This example updates the 'Logic.Monitor' module to the latest version.

.EXAMPLE
    Update-LogicMonitorModule -UninstallFirst -Modules @('Logic.Monitor', 'Logic.Monitor.SE')

    This example uninstalls the old versions of 'Logic.Monitor' and 'Logic.Monitor.SE' modules before installing the latest versions.

.EXAMPLE
    Update-LogicMonitorModule -CheckOnly

    This example checks for updates of all installed LogicMonitor modules without performing any installations.

#>

function Update-LogicMonitorModule {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Not needed for this function')]

    param (
        [String[]]$Modules = @('Logic.Monitor', 'Logic.Monitor.SE'),
        [Boolean]$UninstallFirst = $False,
        [Switch]$CheckOnly
    )

    foreach ($Module in $Modules) {
        try {
            # Read the currently installed version
            $Installed = Get-Module -ListAvailable -Name $Module -ErrorAction SilentlyContinue

            if (-not $Installed) {
                Write-Verbose "Module $Module is not installed; skipping update check."
                continue
            }

            # There might be multiple versions
            if ($Installed -is [Array]) {
                $InstalledVersion = $Installed[0].Version
            }
            elseif ($Installed.Version) {
                $InstalledVersion = $Installed.Version
            }
            else {
                Write-Verbose "Unable to determine installed version for module $Module; skipping update check."
                continue
            }

            # Lookup the latest version online
            try {
                $Online = Find-Module -Name $Module -Repository PSGallery -ErrorAction Stop
                $OnlineVersion = $Online.Version
            }
            catch {
                Write-Verbose "Unable to query online version for module $Module. $_"
                continue
            }

            # Compare the versions
            if ([System.Version]$OnlineVersion -le [System.Version]$InstalledVersion) {
                Write-Information "[INFO]: Module $Module version $InstalledVersion is the latest version."
                continue
            }

            Write-Information "[INFO]: You are currently using an outdated version ($InstalledVersion) of $Module."

            if ($CheckOnly) {
                Write-Information "[INFO]: Please consider upgrading to the latest version ($OnlineVersion) of $Module as soon as possible. Use the -AutoUpdateModule switch next time you connect to auto upgrade to the latest version."
                continue
            }

            if ($UninstallFirst -eq $true) {
                Write-Information "[INFO]: Uninstalling prior Module $Module version $InstalledVersion."
                try {
                    Uninstall-Module -Name $Module -Force -Verbose:$False -ErrorAction Stop
                }
                catch {
                    Write-Verbose "Failed to uninstall module $Module version $InstalledVersion. $_"
                    continue
                }
            }

            Write-Information "[INFO]: Installing newer Module $Module version $OnlineVersion."
            try {
                Install-Module -Name $Module -Force -AllowClobber -Verbose:$False -MinimumVersion $OnlineVersion -ErrorAction Stop
            }
            catch {
                Write-Verbose "Failed to install module $Module version $OnlineVersion. $_"
                continue
            }

            try {
                Update-LogicMonitorModule -CheckOnly -Modules @($Module)
            }
            catch {
                Write-Verbose "Post-installation verification failed for module $Module. $_"
            }
        }
        catch {
            Write-Verbose "Unexpected error encountered while updating module $Module. $_"
        }
    }
}