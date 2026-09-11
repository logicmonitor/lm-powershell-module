<#
.SYNOPSIS
Creates a cached Catchpoint account connection.

.DESCRIPTION
New-CPCachedAccount stores a Catchpoint REST API v2 bearer token securely for use with Connect-CPAccount.

.PARAMETER BearerToken
REST API v2 key from the Catchpoint portal API settings page.

.PARAMETER AccountName
Optional display name for this Catchpoint connection. Used as the default cached account label.

.PARAMETER ApiBaseUrl
Catchpoint REST API v2 base URL. Defaults to https://io.catchpoint.com/api.

.PARAMETER CachedAccountName
The name to use for the cached account. Defaults to CP:{AccountName} or CP:Catchpoint.

.PARAMETER OverwriteExisting
Whether to overwrite an existing cached account.

.EXAMPLE
New-CPCachedAccount -BearerToken "your-catchpoint-api-key" -AccountName "prod"

.NOTES
This command creates a secure vault to store credentials if one does not exist.
Catchpoint cached accounts share the Logic.Monitor vault with LM credentials and are identified by Metadata.Type = 'CP'.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
None. Returns a success message if the account is cached successfully.
#>
function New-CPCachedAccount {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Required for the function to work')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'Required for the function to work')]
    param(
        [Parameter(Mandatory)]
        [String]$BearerToken,

        [String]$AccountName,

        [String]$ApiBaseUrl = 'https://io.catchpoint.com/api',

        [String]$CachedAccountName,

        [Boolean]$OverwriteExisting = $false
    )

    if (-not $AccountName) {
        $AccountName = 'Catchpoint'
    }

    if (-not $CachedAccountName) {
        $CachedAccountName = "CP:$AccountName"
    }

    $ApiBaseUrl = $ApiBaseUrl.TrimEnd('/')

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

    $secret = $BearerToken | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
    $metadata = @{
        Portal    = [String]$AccountName
        PortalUrl = [String]$ApiBaseUrl
        Id        = [String]$AccountName
        Modified  = [DateTime](Get-Date)
        Type      = 'CP'
        GovCloud  = 'False'
    }

    $message = "CachedAccountName: $CachedAccountName | AccountName: $AccountName"

    if ($PSCmdlet.ShouldProcess($message, 'Create Cached Account')) {
        try {
            Set-Secret -Name $CachedAccountName -Secret $secret -Vault Logic.Monitor -Metadata $metadata -NoClobber:$(!$OverwriteExisting)
            Write-Information "[INFO]: Successfully created cached Catchpoint account ($CachedAccountName) for: $AccountName"
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
}
