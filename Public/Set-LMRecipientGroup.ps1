<#
.SYNOPSIS
Update a LogicMonitor recipient group.

.DESCRIPTION
The Set-LMRecipientGroup function updates a LogicMonitor recipient group with the specified parameters.

.PARAMETER Id
The id of the recipient group. This parameter is mandatory.

.PARAMETER Name
The name of the recipient group to lookup instead of the id. This parameter is optional.

.PARAMETER NewName
The new name of the recipient group. This parameter is optional.

.PARAMETER Description
The description of the recipient group. This parameter is optional.

.PARAMETER Recipients
A object containing the recipients for the recipient group.

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
Set-LMRecipientGroup -Id "1234567890" -NewName "MyRecipientGroupUpdated" -Description "This is a test recipient group updated" -Recipients $recipients
This example updates a LogicMonitor recipient group named "MyRecipientGroupUpdated" with a description and recipients built using the New-LMRecipient function.

.NOTES
This function requires a valid LogicMonitor API authentication. Use Connect-LMAccount to authenticate before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.RecipientGroup object.
#>
Function Set-LMRecipientGroup {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [String]$NewName,

        [String]$Description,

        [PSCustomObject]$Recipients
    )

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            
            #Lookup Id if name is provided
            If ($Name) {
                $LookupResult = (Get-LMRecipientGroup -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/setting/recipientgroups/$Id"

            Try {
                $Data = @{
                    groupName   = $NewName
                    description = $Description
                    recipients  = $Recipients
                }

                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { If ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }

                $Data = ($Data | ConvertTo-Json)

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.RecipientGroup")
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
