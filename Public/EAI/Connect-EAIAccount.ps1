<#
.SYNOPSIS
Connect to an Edwin portal for event ingestion.

.DESCRIPTION
Connect-EAIAccount establishes a session for sending custom third-party events to Edwin.
This is separate from Connect-LMAccount. LogicMonitor alerts are already sent to Edwin natively;
use these cmdlets to ingest events from external systems such as Meraki, ServiceNow, or custom applications.

.PARAMETER EdwinOrg
The Edwin organization subdomain (the name before ".dexda.ai").

.PARAMETER ClientId
The client ID used for Edwin OAuth2 client credentials authentication.

.PARAMETER ClientSecret
The client secret used for Edwin OAuth2 client credentials authentication.

.PARAMETER AuthFilePath
Path to a YAML auth file containing edwin_org, client_id, and client_secret.

.PARAMETER UseCachedCredential
Load credentials from the Logic.Monitor secret vault using interactive selection.

.PARAMETER CachedAccountName
The cached Edwin account name to use from the Logic.Monitor secret vault.

.PARAMETER SkipCredValidation
Skip local validation of required credential fields and the remote token grant check.

.PARAMETER DisableConsoleLogging
Disables informational messages for subsequent commands. Console logging is enabled by default.

.EXAMPLE
Connect-EAIAccount -EdwinOrg "myorg" -ClientId "client-id" -ClientSecret "client-secret"

.EXAMPLE
Connect-EAIAccount -CachedAccountName "EAI:myorg"

.NOTES
LM portal authentication is not required for Edwin event ingestion.

.OUTPUTS
None.
#>
function Connect-EAIAccount {
    [CmdletBinding(DefaultParameterSetName = 'Credential')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Required for the function to work')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Credential')]
        [String]$EdwinOrg,

        [Parameter(Mandatory, ParameterSetName = 'Credential')]
        [String]$ClientId,

        [Parameter(Mandatory, ParameterSetName = 'Credential')]
        [String]$ClientSecret,

        [Parameter(Mandatory, ParameterSetName = 'File')]
        [String]$AuthFilePath,

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
    $secureClientSecret = $null
    $cachedAccountLabel = $null
    $tokenResult = $null

    if ($PsCmdlet.ParameterSetName -eq 'File') {
        $authFromFile = Read-EAIAuthFile -AuthFilePath $AuthFilePath
        $EdwinOrg = $authFromFile.edwin_org
        $ClientId = $authFromFile.client_id
        $ClientSecret = $authFromFile.client_secret
    }
    elseif ($PsCmdlet.ParameterSetName -eq 'Cached') {
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

        $cachedSecrets = @(Get-SecretInfo -Vault Logic.Monitor | Where-Object { $_.Metadata['Type'] -eq 'EAI' })

        if ($CachedAccountName) {
            $cachedAccountIndex = $cachedSecrets.Name.IndexOf($CachedAccountName)
            if ($cachedAccountIndex -eq -1) {
                Write-Error "Entered CachedAccountName ($CachedAccountName) does not match one of the stored Edwin credentials, please check the selected entry and try again"
                return
            }

            $selected = $cachedSecrets[$cachedAccountIndex]
        }
        elseif ($UseCachedCredential) {
            if ($cachedSecrets.Count -eq 0) {
                Write-Error 'No cached Edwin accounts were found. Use New-EAICachedAccount to create one.'
                return
            }

            $i = 0
            Write-Host 'Selection Number | Cached Account Name'
            foreach ($credential in $cachedSecrets) {
                Write-Host "$i)     $($credential.Name)"
                $i++
            }

            $storedCredentialIndex = Read-Host -Prompt 'Enter the number for the cached Edwin credential you wish to use'
            if ($cachedSecrets[$storedCredentialIndex]) {
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

        $EdwinOrg = $selected.Metadata['Portal']
        $ClientId = $selected.Metadata['Id']
        $cachedAccountLabel = $selected.Name
        $secureClientSecret = Get-Secret -Vault Logic.Monitor -Name $selected.Name -AsPlainText | ConvertTo-SecureString
    }

    if (-not $SkipCredValidation) {
        $clientSecretPlain = if ($secureClientSecret) {
            [System.Net.NetworkCredential]::new('', $secureClientSecret).Password
        }
        else {
            $ClientSecret
        }

        if ([string]::IsNullOrWhiteSpace($EdwinOrg) -or
            [string]::IsNullOrWhiteSpace($ClientId) -or
            [string]::IsNullOrWhiteSpace($clientSecretPlain)) {
            throw 'EdwinOrg, ClientId, and ClientSecret are required to connect to Edwin.'
        }

        if (-not $secureClientSecret) {
            $secureClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force
        }

        $tokenResult = Test-EAIConnection -EdwinOrg $EdwinOrg -ClientId $ClientId -ClientSecret $secureClientSecret -CallerPSCmdlet $PSCmdlet
    }
    elseif (-not $secureClientSecret) {
        $secureClientSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force
    }

    $setAuthParams = @{
        EdwinOrg     = $EdwinOrg
        ClientId     = $ClientId
        ClientSecret = $secureClientSecret
        Type         = $authType
        Logging      = (!$DisableConsoleLogging.IsPresent)
    }

    if ($tokenResult) {
        $setAuthParams.AccessToken = $tokenResult.AccessToken
        $setAuthParams.TokenExpiresAt = $tokenResult.ExpiresAt
    }

    Set-EAIAuthState @setAuthParams

    if ($cachedAccountLabel) {
        Write-Information "[INFO]: Connected to Edwin portal $EdwinOrg using cached account $cachedAccountLabel."
    }
    else {
        Write-Information "[INFO]: Connected to Edwin portal $EdwinOrg."
    }
}
