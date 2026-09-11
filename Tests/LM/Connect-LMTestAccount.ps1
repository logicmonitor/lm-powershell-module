function Get-LMTestSuffix {
    return [guid]::NewGuid().ToString('N').Substring(0, 8)
}

function Connect-LMTestAccount {
    <#
    .SYNOPSIS
        Connects to LogicMonitor for Pester integration tests.

    .DESCRIPTION
        Uses Pester -Data variables supplied by Run-Tests.ps1. Prefers -CachedAccountName
        when available so bearer and LMv1 cached entries both work.
    #>
    [CmdletBinding()]
    param(
        [Switch]$DisableConsoleLogging,
        [Switch]$SkipCredValidation
    )

    $connectParams = @{}
    if ($DisableConsoleLogging.IsPresent) { $connectParams['DisableConsoleLogging'] = $true }
    if ($SkipCredValidation.IsPresent) { $connectParams['SkipCredValidation'] = $true }
    if ($GovCloud) { $connectParams['GovCloud'] = $true }

    if ($CachedAccountName) {
        Connect-LMAccount -CachedAccountName $CachedAccountName @connectParams
        return
    }

    if ($AuthType -eq 'Bearer' -or ($BearerToken -and [string]::IsNullOrWhiteSpace($AccessKey))) {
        Connect-LMAccount -BearerToken $BearerToken -AccountName $AccountName @connectParams
        return
    }

    Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName @connectParams
}
