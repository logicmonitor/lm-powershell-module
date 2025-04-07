<#
.SYNOPSIS
Creates a cached LogicMonitor account connection.

.DESCRIPTION
The New-LMCachedAccount function stores LogicMonitor portal credentials securely for use with Connect-LMAccount.

.PARAMETER AccessId
The Access ID from your LogicMonitor API credentials.

.PARAMETER AccessKey
The Access Key from your LogicMonitor API credentials.

.PARAMETER AccountName
The portal subdomain (e.g., "company" for company.logicmonitor.com).

.PARAMETER BearerToken
The Bearer token for authentication (alternative to AccessId/AccessKey).

.PARAMETER CachedAccountName
The name to use for the cached account. Defaults to AccountName.

.PARAMETER OverwriteExisting
Whether to overwrite an existing cached account. Defaults to false.

.EXAMPLE
#Cache LMv1 credentials
New-LMCachedAccount -AccessId "id123" -AccessKey "key456" -AccountName "company"

.EXAMPLE
#Cache Bearer token
New-LMCachedAccount -BearerToken "token123" -AccountName "company" -CachedAccountName "prod"

.NOTES
This command creates a secure vault to store credentials if one doesn't exist.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
None. Returns success message if account is cached successfully.
#>
Function New-LMCachedAccount {

    [CmdletBinding(DefaultParameterSetName = "LMv1")]
    Param (
        [Parameter(Mandatory, ParameterSetName = "LMv1")]
        [String]$AccessId,

        [Parameter(Mandatory, ParameterSetName = "LMv1")]
        [String]$AccessKey,

        [Parameter(Mandatory, ParameterSetName = "LMv1")]
        [Parameter(Mandatory, ParameterSetName = "Bearer")]
        [String]$AccountName,

        [Parameter(Mandatory, ParameterSetName = "Bearer")]
        [String]$BearerToken,

        [String]$CachedAccountName = $AccountName,

        [Boolean]$OverwriteExisting = $false
    )

    Try {
        $ExistingVault = Get-SecretInfo -Name Logic.Monitor -WarningAction Stop
        Write-Information "[INFO]: Existing vault Logic.Monitor already exists, skipping creation"
    }
    Catch {
        If ($_.Exception.Message -like "*There are currently no extension vaults registered*") {
            Write-Information "[INFO]: Credential vault for cached accounts does not currently exist, creating credential vault: Logic.Monitor"
            Register-SecretVault -Name Logic.Monitor -ModuleName Microsoft.PowerShell.SecretStore
            Get-SecretStoreConfiguration | Out-Null
        }
    }

    $CurrentDate = Get-Date
    #Convert to secure string
    If ($BearerToken) {
        $Secret = $BearerToken | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
        [Hashtable]$Metadata = @{
            Portal   = [String]$AccountName
            Id       = "$($BearerToken.Substring(0,20))****"
            Modified = [DateTime]$CurrentDate
            Type     = "Bearer"
        }
    }
    Else {
        $Secret = $AccessKey | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
        [Hashtable]$Metadata = @{
            Portal   = [String]$AccountName
            Id       = [String]$AccessId
            Modified = [DateTime]$CurrentDate
            Type     = "LMv1"
        }
    }
    Try {
        Set-Secret -Name $CachedAccountName -Secret $Secret -Vault Logic.Monitor -Metadata $Metadata -NoClobber:$(!$OverwriteExisting)
        Write-Information "[INFO]: Successfully created cached account ($CachedAccountName) secret for portal: $AccountName"
    }
    Catch {
        Write-Error $_.Exception.Message
    }

    Return
}