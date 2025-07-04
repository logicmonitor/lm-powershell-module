<#
.SYNOPSIS
Creates a new alert acknowledgment in LogicMonitor.

.DESCRIPTION
The New-LMAlertAck function acknowledges one or more alerts in LogicMonitor and adds a note to the acknowledgment.

.PARAMETER Ids
The alert IDs to be acknowledged. This parameter is mandatory.

.PARAMETER Note
The note to be added to the acknowledgment. This parameter is mandatory.

.EXAMPLE
#Acknowledge multiple alerts
New-LMAlertAck -Ids @("12345","67890") -Note "Acknowledging alerts"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a success message if the acknowledgment is created successfully.
#>
function New-LMAlertAck {
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
            $ResourcePath = "/alert/alerts/ack"

            $Data = @{
                alertIds   = $Ids
                ackComment = $Note
            }

            $Data = ($Data | ConvertTo-Json)

            $Message = "Alert IDs: $($Ids -join ', ')"

            if ($PSCmdlet.ShouldProcess($Message, "Acknowledge Alerts")) {
                try {

                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    Invoke-LMRestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data | Out-Null

                    return "Successfully acknowledged alert id(s): $Ids"
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
