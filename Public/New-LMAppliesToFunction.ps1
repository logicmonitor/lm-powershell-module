<#
.SYNOPSIS
Creates a new LogicMonitor Applies To function.

.DESCRIPTION
The New-LMAppliesToFunction function creates a new Applies To function that can be used in LogicMonitor for targeting resources.

.PARAMETER Name
The name of the function. This parameter is mandatory.

.PARAMETER Description
A description of the function's purpose.

.PARAMETER AppliesTo
The function code that defines the targeting logic. This parameter is mandatory.

.EXAMPLE
#Create a new Applies To function
New-LMAppliesToFunction -Name "WindowsServers" -AppliesTo "isWindows() && hasCategory('server')" -Description "Targets Windows servers"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns the created function object.
#>
Function New-LMAppliesToFunction {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [Parameter(Mandatory)]
        [String]$AppliesTo

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        
        #Build header and uri
        $ResourcePath = "/setting/functions"

        Try {
            $Data = @{
                name        = $Name
                description = $Description
                code        = $AppliesTo
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

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
