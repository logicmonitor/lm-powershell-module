<#
.SYNOPSIS
Converts a Catchpoint transaction script to another language.

.DESCRIPTION
Convert-CPTestScript converts a script via POST /v4/Tests/scriptconvert.
Only Selenium (1) to Playwright (3) is currently supported.

.PARAMETER Script
Source transaction script.

.PARAMETER ScriptLanguage
ApiTransactionScriptType enum value of the original script format. Defaults to 1 (Selenium).

.PARAMETER TargetLanguage
ApiTransactionScriptType enum value of the target script format. Defaults to 3 (Playwright).

.EXAMPLE
Convert-CPTestScript -Script $seleniumScript

.NOTES
You must run Connect-CPAccount before running this command.

.INPUTS
You can pipe a script string to this command.

.OUTPUTS
Returns a Catchpoint.Test.ScriptConversion object.
#>
function Convert-CPTestScript {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]$Script,

        [Int]$ScriptLanguage = 1,

        [Int]$TargetLanguage = 3
    )

    process {
        if (-not (Test-CPAuth -CallerPSCmdlet $PSCmdlet)) {
            return
        }

        $query = @{
            scriptLanguage                 = $ScriptLanguage
            languageScriptShouldConvertTo  = $TargetLanguage
        }

        return Invoke-CPApiRequest -ResourcePath '/v4/Tests/scriptconvert' -Method POST -QueryParameters $query `
            -Body @{ script = $Script } -TypeName 'Catchpoint.Test.ScriptConversion' -CallerPSCmdlet $PSCmdlet -Command $MyInvocation
    }
}
