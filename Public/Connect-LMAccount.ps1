<#
.SYNOPSIS
Connect to a specified LM portal to run commands against

.DESCRIPTION
Connect to a specified LM portal which will allow you run the other LM commands associated with the Logic.Monitor PS module. Used in conjunction with Disconnect-LMAccount to close a session previously connected via Connect-LMAccount

.PARAMETER AccessId
Access ID from your API credential acquired from the LM Portal

.PARAMETER AccessKey
Access Key from your API credential acquired from the LM Portal

.PARAMETER BearerToken
Bearer token from your API credential acquired from the LM Portal. For use in place of LMv1 token

.PARAMETER AccountName
The subdomain for your LM portal, the name before ".logicmonitor.com" (subdomain.logicmonitor.com)

.PARAMETER DisableConsoleLogging
Disables on info messages from displaying for any subsequent commands are run. Useful when building scripted logicmodules and you want to suppress unwanted output. Console logging is enabled by default.

.PARAMETER UseCachedCredential
This will list all cached account for you to pick from. This parameter is optional

.PARAMETER CachedAccountName
Name of cached account you wish to connect to. This parameter is optional and can be used in place of UseCachedCredential

.PARAMETER SessionSync
Use session sync capability instead of api key

.PARAMETER GovCloud
Connect using the LM GovCloud portal

.PARAMETER SkipCredValidation
Skip validation of credentials, useful when connecting to a portal that is not yet configured with the Logic.Monitor module

.EXAMPLE
#Connecting to an Account using an Access ID and Access Key
Connect-LMAccount -AccessId xxxxxx -AccessKey xxxxxx -AccountName subdomain

.EXAMPLE
#Connecting to an Account using a Bearer Token
Connect-LMAccount -BearerToken xxxxxx -AccountName subdomain

.EXAMPLE
#Connecting to an Account using a Cached Credential
Connect-LMAccount -UseCachedCredential -CachedAccountName "CachedAccountName"

.NOTES
You must run this command before you will be able to execute other commands included with the Logic.Monitor module.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
None. This command does not return any output.
#>
function Connect-LMAccount {

    [CmdletBinding(DefaultParameterSetName = "LMv1")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Required for the function to work')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'Required for the function to work')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for the function to work')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Required for the function to work')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'LMv1')]
        [String]$AccessId,

        [Parameter(Mandatory, ParameterSetName = 'LMv1')]
        [String]$AccessKey,

        [Parameter(Mandatory, ParameterSetName = 'Bearer')]
        [String]$BearerToken,

        [Parameter(Mandatory, ParameterSetName = 'LMv1')]
        [Parameter(Mandatory, ParameterSetName = 'Bearer')]
        [Parameter(Mandatory, ParameterSetName = 'SessionSync')]
        [String]$AccountName,

        [Parameter(ParameterSetName = 'Cached')]
        [Switch]$UseCachedCredential,

        [Parameter(ParameterSetName = 'Cached')]
        [String]$CachedAccountName,

        [Parameter(ParameterSetName = 'SessionSync')]
        [Switch]$SessionSync,

        [Switch]$DisableConsoleLogging,

        [Switch]$AutoUpdateModuleVersion,

        [Switch]$SkipVersionCheck,

        [Switch]$GovCloud,

        [Switch]$SkipCredValidation
    )

    #Autoload web assembly if on older version of powershell
    if ((Get-Host).Version.Major -lt 6) {
        Add-Type -AssemblyName System.Web
    }

    if ($DisableConsoleLogging.IsPresent) {
        $Script:InformationPreference = 'SilentlyContinue'
    }
    else {
        $Script:InformationPreference = 'Continue'
    }

    if ($UseCachedCredential -or $CachedAccountName) {

        try {
            Get-SecretVault -Name Logic.Monitor -ErrorAction Stop | Out-Null
            Write-Information "[INFO]: Existing vault Logic.Monitor already exists, skipping creation"
        }
        catch {
            if ($_.Exception.Message -like "*Vault Logic.Monitor does not exist in registry*") {
                Write-Information "[INFO]: Credential vault for cached accounts does not currently exist, creating credential vault: Logic.Monitor"
                Register-SecretVault -Name Logic.Monitor -ModuleName Microsoft.PowerShell.SecretStore
                Get-SecretStoreConfiguration | Out-Null
            }
        }
        $CredentialPath = Join-Path -Path $Home -ChildPath "Logic.Monitor.json"
        if ((Test-Path -Path $CredentialPath)) {
            Write-Information "[INFO]: Previous version of cached accounts detected, migrating to secret store..."
            $CredentialFile = Get-Content -Path $CredentialPath | ConvertFrom-Json | Sort-Object -Property Modified -Descending
            $MigrationComplete = $true
            foreach ($Credential in $CredentialFile) {
                $CurrentDate = Get-Date
                [Hashtable]$Metadata = @{
                    Portal   = [String]$Credential.Portal
                    Id       = [String]$Credential.Id
                    Modified = [DateTime]$CurrentDate
                }
                try {
                    Set-Secret -Name $Credential.Portal -Secret $Credential.Key -Vault Logic.Monitor -Metadata $Metadata -NoClobber
                    Write-Information "[INFO]: Successfully migrated cached account secret for portal: $($Credential.Portal)"
                }
                catch {
                    Write-Error $_.Exception.Message
                    $MigrationComplete = $false
                }
            }
            if ($MigrationComplete) {
                Remove-Item -Path $CredentialPath -Confirm:$false
                Write-Information "[INFO]: Successfully migrated cached accounts into secret store, your legacy account cache hes been removed."
            }
            else {
                $NewName = Join-Path -Path $Home -ChildPath "Logic.Monitor-Migrated.json"
                Rename-Item -Path $CredentialPath -Confirm:$false -NewName $NewName
                Write-Error "[ERROR]: Unable to fully migrate cached accounts into secret store, your legacy account cache has been archived at: $NewName. No other attemps will be made to migrate any failed accounts."
            }
        }

        if ($CachedAccountName) {
            #If supplied and account name just use that vs showing a list of accounts
            $CachedAccountSecrets = Get-SecretInfo -Vault Logic.Monitor
            $CachedAccountIndex = $CachedAccountSecrets.Name.IndexOf($CachedAccountName)
            if ($CachedAccountIndex -ne -1) {
                $AccountName = $CachedAccountSecrets[$CachedAccountIndex].Metadata["Portal"]
                $AccessId = $CachedAccountSecrets[$CachedAccountIndex].Metadata["Id"]
                $Type = $CachedAccountSecrets[$CachedAccountIndex].Metadata["Type"]
                if (($Type -eq "LMv1") -or ($null -eq $Type)) {
                    [SecureString]$AccessKey = Get-Secret -Vault "Logic.Monitor" -Name $CachedAccountName -AsPlainText | ConvertTo-SecureString
                }
                else {
                    [SecureString]$BearerToken = Get-Secret -Vault "Logic.Monitor" -Name $CachedAccountName -AsPlainText | ConvertTo-SecureString
                }
            }
            else {
                Write-Error "Entered CachedAccountName ($CachedAccountName) does not match one of the stored credentials, please check the selected entry and try again"
                return
            }
        }
        else {
            #List out current portals with saved credentials and let users chose which to use
            $i = 0
            $CachedAccountSecrets = Get-SecretInfo -Vault Logic.Monitor
            if ($CachedAccountSecrets) {
                Write-Host "Selection Number | Portal Name"
                foreach ($Credential in $CachedAccountSecrets) {
                    if ($Credential.Name -notlike "*LMSessionSync*") {
                        Write-Host "$i)     $($Credential.Name)"
                    }
                    $i++
                }
                $StoredCredentialIndex = Read-Host -Prompt "Enter the number for the cached credential you wish to use"
                if ($CachedAccountSecrets[$StoredCredentialIndex]) {
                    $AccountName = $CachedAccountSecrets[$StoredCredentialIndex].Metadata["Portal"]
                    $CachedAccountName = $CachedAccountSecrets[$StoredCredentialIndex].Name
                    $AccessId = $CachedAccountSecrets[$StoredCredentialIndex].Metadata["Id"]
                    $Type = $CachedAccountSecrets[$StoredCredentialIndex].Metadata["Type"]
                    if ($Type -eq "LMv1") {
                        [SecureString]$AccessKey = Get-Secret -Vault "Logic.Monitor" -Name $CachedAccountName -AsPlainText | ConvertTo-SecureString
                    }
                    elseif ($Type -eq "Bearer") {
                        [SecureString]$BearerToken = Get-Secret -Vault "Logic.Monitor" -Name $CachedAccountName -AsPlainText | ConvertTo-SecureString
                    }
                    else {
                        Write-Error "Invalid credential type detected for selection: $Type"
                        return
                    }
                }
                else {
                    Write-Error "Entered value does not match one of the listed credentials, please check the selected entry and try again"
                    return
                }
            }
            else {
                Write-Error "No entries currently found in secret vault Logic.Monitor"
                return
            }
        }
    }
    else {
        if ($PsCmdlet.ParameterSetName -eq "LMv1") {
            #Convert to secure string
            [SecureString]$AccessKey = $AccessKey | ConvertTo-SecureString -AsPlainText -Force
            $Type = "LMv1"
        }
        elseif ($PsCmdlet.ParameterSetName -eq "SessionSync") {
            $Session = Get-LMSession -AccountName $AccountName
            if ($Session) {
                $AccessId = $Session.jSessionID #Session Id
                $AccessKey = $Session.token #CSRF Token
                $Type = "SessionSync"
            }
            else {
                throw "Unable to validate session sync info for: $AccountName"
            }
        }
        else {
            #Convert to secure string
            [SecureString]$BearerToken = $BearerToken | ConvertTo-SecureString -AsPlainText -Force
            $Type = "Bearer"
        }
    }

    if (!$Type) {
        $Type = "LMv1"
    }

    #Create Credential Object for reuse in other functions
    $Script:LMAuth = [PSCustomObject]@{
        Id          = $AccessId
        Key         = $AccessKey
        BearerToken = $BearerToken
        Portal      = $AccountName
        Valid       = $true
        Type        = $Type
        Logging     = !$DisableConsoleLogging.IsPresent
        GovCloud    = $GovCloud.IsPresent
    }

    #Check for newer version of Logic.Monitor module
    try {
        if ($AutoUpdateModuleVersion -and !$SkipVersionCheck) {
            Update-LogicMonitorModule
        }
        elseif (!$SkipVersionCheck) {
            Update-LogicMonitorModule -CheckOnly
        }
    }
    catch {
        Write-Error "[ERROR]: Unable to check for newer version of Logic.Monitor module: $($_.Exception.Message)"
    }

    if (!$SkipCredValidation) {
        try {
            #Collect portal info and api username and roles
            if ($Type -eq "Bearer") {
                $Token = [System.Net.NetworkCredential]::new("", $BearerToken).Password
                $ApiInfo = Get-LMAPIToken -Type Bearer -ErrorAction SilentlyContinue | Where-Object { $_.accessKey -like "$($Token.Substring(0,20))*" }
            }
            else {
                $ApiInfo = Get-LMAPIToken -Filter "accessId -eq '$AccessId'" -ErrorAction SilentlyContinue
            }

            if ($ApiInfo) {
                $PortalInfo = Get-LMPortalInfo -ErrorAction Stop
                Write-Information "[INFO]: Connected to LM portal $($PortalInfo.companyDisplayName) using account ($($ApiInfo.adminName) via $Type Token) with assigned roles: $($ApiInfo.roles -join ",") - ($($PortalInfo.numberOfDevices) devices | $($PortalInfo.numOfWebsites) websites)."
                return
            }
            else {
                try {
                    $PortalInfo = Get-LMPortalInfo -ErrorAction Stop
                    Write-Information "[INFO]: Connected to LM portal $($PortalInfo.companyDisplayName) via $Type Token - ($($PortalInfo.numberOfDevices) devices | $($PortalInfo.numOfWebsites) websites)."
                    return
                }
                catch {
                    throw "Unable to validate API token info"
                }
            }
        }
        catch {
            try {
                $DeviceInfo = Get-LMDevice -ErrorAction Stop

                if ($DeviceInfo) {
                    Write-Information "[INFO]: Connected to LM portal $AccountName via $Type Token with limited permissions, ensure your api token has the necessary rights needed to run desired commands."
                    return
                }
                else {
                    throw "Unable to verify api token permission levels, ensure api token has rights to view all/select resources or at minimum view access for Account Information"
                }
            }
            catch {

                #Clear credential object from environment
                Remove-Variable LMAuth -Scope Script -ErrorAction SilentlyContinue
                throw "Unable to login to account, please ensure your access info and account name are correct: $($_.Exception.Message)"
            }
            return
        }
    }
    else {
        Write-Information "[INFO]: Skipping validation of credentials, connected to LM portal $AccountName via $Type, ensure your api token has the necessary rights needed to run desired commands."
    }
}
