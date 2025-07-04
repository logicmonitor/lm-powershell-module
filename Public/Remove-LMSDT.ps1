<#
.SYNOPSIS
Removes a Scheduled Down Time (SDT) entry from LogicMonitor.

.DESCRIPTION
The Remove-LMSDT function removes a specified SDT entry from LogicMonitor using its ID.

.PARAMETER Id
Specifies the ID of the SDT entry to remove. This parameter is mandatory.

.EXAMPLE
Remove-LMSDT -Id "12345"
Removes the SDT entry with ID "12345".

.INPUTS
You can pipe objects to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed SDT entry and a success message confirming the removal.
#>

function Remove-LMSDT {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [String]$Id

    )
    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/sdt/sdts/$Id"

            $Message = "Id: $Id"

            #Loop through requests
            try {
                if ($PSCmdlet.ShouldProcess($Message, "Remove SDT")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                    #Issue request
                    Invoke-LMRestMethod -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1] | Out-Null

                    $Result = [PSCustomObject]@{
                        Id      = $Id
                        Message = "Successfully removed ($Message)"
                    }

                    return $Result
                }
            }
            catch {
                return
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
