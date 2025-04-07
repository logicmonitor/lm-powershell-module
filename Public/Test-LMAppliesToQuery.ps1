<#
.SYNOPSIS
Tests the applies to query against the LogicMonitor API.

.DESCRIPTION
The Test-LMAppliesToQuery function is used to test the applies to query against the LogicMonitor API.

.PARAMETER Query
The applies to query to be tested.

.EXAMPLE
Test-LMAppliesToQuery -Query "system.hostname == 'server01'"
This example tests the applies to query "system.hostname == 'server01'" against the LogicMonitor API and returns a list of matching devices.

.INPUTS
The Query parameter accepts string input that specifies the applies to query to test.

.OUTPUTS
Returns an array of objects containing the devices that match the specified query criteria.

.NOTES
This function requires a valid LogicMonitor API authentication. The query syntax must follow LogicMonitor's applies to query format.
#>
Function Test-LMAppliesToQuery {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Query

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        
        #Build header and uri
        $ResourcePath = "/functions"

        Try {
            $Data = @{
                currentAppliesTo    = $Query
                originalAppliesTo   = $Query
                needInheritProps    = $true
                type                = "testAppliesTo"
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = (Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data).currentMatches

            Return $Response
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
