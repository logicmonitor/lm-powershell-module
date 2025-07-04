<#
.SYNOPSIS
Creates a new note for LogicMonitor alerts.

.DESCRIPTION
The New-LMAlertNote function adds a note to one or more alerts in LogicMonitor.

.PARAMETER Ids
The alert IDs to add the note to. This parameter is mandatory.

.PARAMETER Note
The content of the note to add. This parameter is mandatory.

.EXAMPLE
#Add a note to multiple alerts
New-LMAlertNote -Ids @("12345","67890") -Note "This is a sample note"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a success message if the note is created successfully.
#>
function New-LMAlertNote {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [String[]]$Ids,
        [Parameter(Mandatory)]
        [String]$Note
    )
    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/alert/alerts/note"

            $Data = @{
                alertIds = $Ids
                note     = $Note
            }

            $Data = ($Data | ConvertTo-Json)

            $Message = "Alert IDs: $($Ids -join ', ')"

            if ($PSCmdlet.ShouldProcess($Message, "Add Alert Note")) {
                try {

                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    Invoke-LMRestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data | Out-Null

                    return "Successfully updated note for alert id(s): $Ids"
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
    end {}
}
