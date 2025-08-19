<#
.SYNOPSIS
Removes a LogicMonitor Service template.

.DESCRIPTION
The Remove-LMServiceTemplate function removes a LogicMonitor Service template by ID.

.PARAMETER Id
The ID of the Service template to remove. This parameter is mandatory.

.PARAMETER DeleteHard
Specifies whether to perform a hard delete. Default is $false (soft delete).

.EXAMPLE
Remove-LMServiceTemplate -Id 6
This example removes the LogicMonitor Service template with ID 6 using soft delete.

.EXAMPLE
Remove-LMServiceTemplate -Id 6 -DeleteHard $true
This example removes the LogicMonitor Service template with ID 6 using hard delete.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed service template and a success message confirming the removal.
#>

function Remove-LMServiceTemplate {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory)]
        [String]$Id,

        [Boolean]$DeleteHard = $false
    )
    
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build the delete payload structure
        $Data = @{
            data = @{
                allIds = @(
                    @{
                        model = "RestServiceTemplate"
                        id = $Id
                    }
                )
            }
            meta = @{
                deleteHard = $DeleteHard
            }
        }

        #Build header and uri
        $ResourcePath = "/serviceTemplates/delete"

        $Data = ($Data | ConvertTo-Json -Depth 10)

        $Message = "Id: $Id"

        if ($PSCmdlet.ShouldProcess($Message, "Remove Service Template")) {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Version 4
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation
            
            #Issue request
            Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            $Result = [PSCustomObject]@{
                Id      = $Id
                Message = "Successfully removed ($Message)"
            }

            return $Result

        }
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}