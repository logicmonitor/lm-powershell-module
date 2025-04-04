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
Function New-LMAlertNote {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [String[]]$Ids,
        [Parameter(Mandatory)]
        [String]$Note
    )
    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {
            
            #Build header and uri
            $ResourcePath = "/alert/alerts/note"
    
            Try {
    
                $Data = @{
                    alertIds = $Ids
                    note     = $Note
                }
    
                $Data = ($Data | ConvertTo-Json)
    
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
    
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-WebRequest -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
    
                If ($Response.StatusCode -eq 200) {
                    Return "Successfully updated note for alert id(s): $Ids"
                }
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
