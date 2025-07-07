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
function New-LMAppliesToFunction {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [Parameter(Mandatory)]
        [String]$AppliesTo

    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {


        #Build header and uri
        $ResourcePath = "/setting/functions"

        $Data = @{
            name        = $Name
            description = $Description
            code        = $AppliesTo
        }

        $Data = ($Data | ConvertTo-Json)

        $Message = "Name: $Name"

        if ($PSCmdlet.ShouldProcess($Message, "Create Applies To Function")) {
            try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return $Response
            }
            catch {
                return
            }
        }
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
