<#
.SYNOPSIS
Creates a new LogicMonitor recipient group.

.DESCRIPTION
The New-LMRecipientGroup function creates a new LogicMonitor recipient group with the specified parameters.

.PARAMETER Name
The name of the recipient group. This parameter is mandatory.

.PARAMETER Description
The description of the recipient group.

.PARAMETER Recipients
A object containing the recipients for the recipient group. The object must contain a "method", "type" and "addr" key.

.EXAMPLE
$recipients = @(
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method 'email'
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method 'sms'
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method 'voice'
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method 'smsemail'
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method '<name_of_existing_integration>'
    New-LMRecipient -Type 'ARBITRARY' -Addr 'someone@other.com' -Method 'email'
    New-LMRecipient -Type 'GROUP' -Addr 'Helpdesk'
)
New-LMRecipientGroup -Name "MyRecipientGroup" -Description "This is a test recipient group" -Recipients $recipients
This example creates a new LogicMonitor recipient group named "MyRecipientGroup" with a description and recipients built using the New-LMRecipient function.


.NOTES
This function requires a valid LogicMonitor API authentication. Use Connect-LMAccount to authenticate before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.RecipientGroup object.
#>
function New-LMRecipientGroup {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [Parameter(Mandatory)]
        [Array]$Recipients
    )

    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/setting/recipientgroups"

        $Data = @{
            groupName   = $Name
            description = $Description
            recipients  = $Recipients
        }

        $Data = ($Data | ConvertTo-Json)

        $Message = "Name: $Name"

        if ($PSCmdlet.ShouldProcess($Message, "Create Recipient Group")) {
            try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.RecipientGroup")
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
