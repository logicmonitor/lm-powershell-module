<#
.SYNOPSIS
Removes normalized properties from LogicMonitor.

.DESCRIPTION
The Remove-LMNormalizedProperty cmdlet removes normalized properties from LogicMonitor.

.PARAMETER Alias
The alias name of the normalized property to remove.

.EXAMPLE
Remove-LMNormalizedProperty -Alias "location"
Removes the normalized property with alias "location".

.INPUTS
None.

.OUTPUTS
Returns the response from the API after removing the normalized property.

.NOTES
This function requires valid API credentials to be logged in. Use Connect-LMAccount to log in before running this command.
#>
function Remove-LMNormalizedProperty {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory = $true)]
        [String]$Alias
    )

    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/normalizedProperties/alias"

            #Loop through each property and build the body
            $Body = [PSCustomObject]@{
                data = [PSCustomObject]@{
                    items = @()
                }
            }

            $Body.data.items += [PSCustomObject]@{
                alias = $Alias
                model = "normalizedProperties"
            }

            $Body = $Body | ConvertTo-Json -Depth 10

            $Message = "Alias: $Alias"

            if ($PSCmdlet.ShouldProcess($Message, "Remove Normalized Property")) {
                
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath -Version 4
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body
                return $Response
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
