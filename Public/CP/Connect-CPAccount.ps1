<#
.SYNOPSIS
Connect to Catchpoint using a REST API v2 bearer token.

.DESCRIPTION
Connect-CPAccount establishes a session for Catchpoint REST API v2 commands.
Catchpoint authenticates with the v2 API key from the Catchpoint portal API
settings page. That key is an OAuth bearer token and is valid for two years
from generation unless it is regenerated or revoked.

Use a client-level key to access data at the client level, or a division-level
key to access data within a specific division.

.PARAMETER BearerToken
REST API v2 key from the Catchpoint portal API settings page. Passed as a
bearer token in the Authorization header of subsequent requests.

.PARAMETER AccountName
Optional display name for this Catchpoint connection. Used as a label in
status output and when selecting cached credentials.

.PARAMETER ApiBaseUrl
Catchpoint REST API v2 base URL. Defaults to https://io.catchpoint.com/api.

.PARAMETER UseCachedCredential
Load credentials from the Logic.Monitor secret vault using interactive selection.

.PARAMETER CachedAccountName
The cached Catchpoint account name to use from the Logic.Monitor secret vault.

.PARAMETER SkipCredValidation
Skip the remote token check against the Catchpoint API.

.PARAMETER DisableConsoleLogging
Disables informational messages for subsequent commands. Console logging is enabled by default.

.EXAMPLE
Connect-CPAccount -BearerToken "your-catchpoint-api-key"

.EXAMPLE
Connect-CPAccount -BearerToken "your-catchpoint-api-key" -AccountName "prod"

.EXAMPLE
Connect-CPAccount -CachedAccountName "CP:prod"

.NOTES
You must run this command before other Catchpoint commands.
The bearer token is the only required credential. AccountName is optional
and is used only as a local label.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
None.
#>
function Connect-CPAccount {
    [CmdletBinding(DefaultParameterSetName = 'Bearer')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Required for the function to work')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'Required for the function to work')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for the function to work')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Bearer')]
        [String]$BearerToken,

        [Parameter(ParameterSetName = 'Bearer')]
        [String]$AccountName,

        [Parameter(ParameterSetName = 'Bearer')]
        [String]$ApiBaseUrl = 'https://io.catchpoint.com/api',

        [Parameter(ParameterSetName = 'Cached')]
        [Switch]$UseCachedCredential,

        [Parameter(ParameterSetName = 'Cached')]
        [String]$CachedAccountName,

        [Switch]$DisableConsoleLogging,

        [Switch]$SkipCredValidation
    )

    if ($DisableConsoleLogging.IsPresent) {
        $Script:InformationPreference = 'SilentlyContinue'
    }
    else {
        $Script:InformationPreference = 'Continue'
    }

    $authType = 'Bearer'
    $secureBearerToken = $null
    $cachedAccountLabel = $null

    if ($PsCmdlet.ParameterSetName -eq 'Cached') {
        $authType = 'Cached'

        try {
            Get-SecretVault -Name Logic.Monitor -ErrorAction Stop | Out-Null
            Write-Information '[INFO]: Existing vault Logic.Monitor already exists, skipping creation'
        }
        catch {
            if ($_.Exception.Message -like '*Vault Logic.Monitor does not exist in registry*') {
                Write-Information '[INFO]: Credential vault for cached accounts does not currently exist, creating credential vault: Logic.Monitor'
                Register-SecretVault -Name Logic.Monitor -ModuleName Microsoft.PowerShell.SecretStore
                Get-SecretStoreConfiguration | Out-Null
            }
        }

        $cachedSecrets = @(Get-SecretInfo -Vault Logic.Monitor | Where-Object { $_.Metadata['Type'] -eq 'CP' })

        if ($CachedAccountName) {
            $cachedAccountIndex = $cachedSecrets.Name.IndexOf($CachedAccountName)
            if ($cachedAccountIndex -eq -1) {
                Write-Error "Entered CachedAccountName ($CachedAccountName) does not match one of the stored Catchpoint credentials, please check the selected entry and try again"
                return
            }

            $selected = $cachedSecrets[$cachedAccountIndex]
        }
        elseif ($UseCachedCredential) {
            if ($cachedSecrets.Count -eq 0) {
                Write-Error 'No cached Catchpoint accounts were found. Use New-CPCachedAccount to create one.'
                return
            }

            Write-Host 'Selection Number | Cached Account Name'
            for ($i = 0; $i -lt $cachedSecrets.Count; $i++) {
                Write-Host "$i)     $($cachedSecrets[$i].Name)"
            }

            $storedCredentialIndex = $null
            $storedCredentialSelection = Read-Host -Prompt 'Enter the number for the cached Catchpoint credential you wish to use'
            if ($storedCredentialSelection -match '^\d+$') {
                $storedCredentialIndex = [int]$storedCredentialSelection
            }

            if ($null -ne $storedCredentialIndex -and $cachedSecrets[$storedCredentialIndex]) {
                $selected = $cachedSecrets[$storedCredentialIndex]
            }
            else {
                Write-Error 'Entered value does not match one of the listed credentials, please check the selected entry and try again'
                return
            }
        }
        else {
            Write-Error 'Specify -CachedAccountName or -UseCachedCredential when using the Cached parameter set.'
            return
        }

        $AccountName = $selected.Metadata['Portal']
        if ($selected.Metadata['PortalUrl']) {
            $ApiBaseUrl = $selected.Metadata['PortalUrl']
        }
        $cachedAccountLabel = $selected.Name
        $secureBearerToken = Get-Secret -Vault Logic.Monitor -Name $selected.Name -AsPlainText | ConvertTo-SecureString
    }

    if ([string]::IsNullOrWhiteSpace($ApiBaseUrl)) {
        $ApiBaseUrl = 'https://io.catchpoint.com/api'
    }
    $ApiBaseUrl = $ApiBaseUrl.TrimEnd('/')

    if (-not $SkipCredValidation) {
        $bearerPlain = if ($secureBearerToken) {
            [System.Net.NetworkCredential]::new('', $secureBearerToken).Password
        }
        else {
            $BearerToken
        }

        if ([string]::IsNullOrWhiteSpace($bearerPlain)) {
            throw 'BearerToken is required to connect to Catchpoint.'
        }

        if (-not $secureBearerToken) {
            $secureBearerToken = $BearerToken | ConvertTo-SecureString -AsPlainText -Force
        }

        $null = Test-CPConnection -BearerToken $secureBearerToken -ApiBaseUrl $ApiBaseUrl -CallerPSCmdlet $PSCmdlet
    }
    elseif (-not $secureBearerToken) {
        $secureBearerToken = $BearerToken | ConvertTo-SecureString -AsPlainText -Force
    }

    $setAuthParams = @{
        BearerToken = $secureBearerToken
        ApiBaseUrl  = $ApiBaseUrl
        Type        = $authType
        Logging     = (!$DisableConsoleLogging.IsPresent)
    }

    if ($AccountName) {
        $setAuthParams.AccountName = $AccountName
    }

    Set-CPAuthState @setAuthParams

    if ($cachedAccountLabel) {
        $accountLabel = if ($AccountName) { $AccountName } else { $ApiBaseUrl }
        Write-Information "[INFO]: Connected to Catchpoint account $accountLabel using cached account $cachedAccountLabel."
    }
    elseif ($AccountName) {
        Write-Information "[INFO]: Connected to Catchpoint account $AccountName."
    }
    else {
        Write-Information "[INFO]: Connected to Catchpoint API $ApiBaseUrl."
    }
}
