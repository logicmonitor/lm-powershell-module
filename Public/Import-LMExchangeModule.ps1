<#
.SYNOPSIS
Imports an LM Exchange module into LogicMonitor.

.DESCRIPTION
The Import-LMExchangeModule function imports a specified LM Exchange module into your LogicMonitor portal.

.PARAMETER LMExchangeId
The ID of the LM Exchange module to import. This parameter is mandatory.

.EXAMPLE
#Import an LM Exchange module
Import-LMExchangeModule -LMExchangeId "LM12345"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a success message if the import is successful.
#>
Function Import-LMExchangeModule {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$LMExchangeId
    )

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/exchange/integrations/import"

            #Construct payload
            $Data = @{items = @() }
            $Data.items += [PSCustomObject]@{
                id = $LMExchangeId
            }

            $Data = ($Data | ConvertTo-Json)

            Try {

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return "Successfully imported LM Exchange module id: $LMExchangeId"

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
    End {}
}