<#
.SYNOPSIS
Creates a cached Edwin account connection.

.DESCRIPTION
New-EAICachedAccount stores Edwin portal credentials securely for use with Connect-EAIAccount.

.PARAMETER EdwinOrg
The Edwin organization subdomain.

.PARAMETER ClientId
The Edwin client ID.

.PARAMETER ClientSecret
The Edwin client secret.

.PARAMETER CachedAccountName
The name to use for the cached account. Defaults to EAI:{EdwinOrg}.

.PARAMETER OverwriteExisting
Whether to overwrite an existing cached account.

.EXAMPLE
New-EAICachedAccount -EdwinOrg "myorg" -ClientId "client-id" -ClientSecret "client-secret"

.NOTES
This command creates a secure vault to store credentials if one does not exist.
Edwin cached accounts share the Logic.Monitor vault with LM credentials and are identified by Metadata.Type = 'EAI'.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
None. Returns a success message if the account is cached successfully.
#>
function New-EAICachedAccount {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Required for the function to work')]
    param(
        [Parameter(Mandatory)]
        [String]$EdwinOrg,

        [Parameter(Mandatory)]
        [String]$ClientId,

        [Parameter(Mandatory)]
        [String]$ClientSecret,

        [String]$CachedAccountName,

        [Boolean]$OverwriteExisting = $false
    )

    if (-not $CachedAccountName) {
        $CachedAccountName = "EAI:$EdwinOrg"
    }

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

    $secret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
    $metadata = @{
        Portal   = [String]$EdwinOrg
        Id       = [String]$ClientId
        Modified = [DateTime](Get-Date)
        Type     = 'EAI'
        GovCloud = 'False'
    }

    $message = "CachedAccountName: $CachedAccountName | EdwinOrg: $EdwinOrg"

    if ($PSCmdlet.ShouldProcess($message, 'Create Cached Account')) {
        try {
            Set-Secret -Name $CachedAccountName -Secret $secret -Vault Logic.Monitor -Metadata $metadata -NoClobber:$(!$OverwriteExisting)
            Write-Information "[INFO]: Successfully created cached Edwin account ($CachedAccountName) for portal: $EdwinOrg"
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
}
