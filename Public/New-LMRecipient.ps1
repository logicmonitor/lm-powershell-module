<#
.SYNOPSIS
Creates a new LogicMonitor recipient object.

.DESCRIPTION
The New-LMRecipient function creates a new LogicMonitor recipient object that can be used with recipient groups. The recipient can be an admin user, arbitrary email, or another recipient group.

.PARAMETER Type
The type of recipient. Must be one of: ADMIN, ARBITRARY, or GROUP.

.PARAMETER Addr
The address of the recipient. For ADMIN/ARBITRARY this is an email address, for GROUP this is the group name.

.PARAMETER Method
The notification method for ADMIN recipients. Not used for GROUP type. Possible values: email, sms, voice, smsemail or the name of an existing integration

.PARAMETER Contact
Optional contact information for the recipient.

.EXAMPLE
New-LMRecipient -Type ADMIN -Addr "admin@company.com" -Method "email"
Creates a new admin recipient that will receive email notifications.

.EXAMPLE
New-LMRecipient -Type GROUP -Addr "EmergencyContacts"
Creates a new recipient that references an existing recipient group.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a hashtable containing the recipient configuration.
#>

Function New-LMRecipient {
    param(
        [Parameter(Mandatory)]
        [ValidateSet('ADMIN','GROUP','ARBITRARY')] 
        [String]$Type,
        
        [Parameter(Mandatory)] [string]$Addr,

        [String]$Method, # Only for ADMIN

        [String]$Contact # Optional, for future use
    )
    $recipient = @{
        type = $Type
        addr = $Addr
    }
    if ($Type -ne 'GROUP') {
        $recipient.method = $Method
    }
    if ($Contact) {
        $recipient.contact = $Contact
    }
    return [PSCustomObject]$recipient
}
