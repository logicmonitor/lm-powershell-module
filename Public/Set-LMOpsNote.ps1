<#
.SYNOPSIS
Updates an operations note in LogicMonitor.

.DESCRIPTION
The Set-LMOpsNote function modifies an existing operations note in LogicMonitor.

.PARAMETER Id
Specifies the ID of the operations note to modify.

.PARAMETER Note
Specifies the new content for the note.

.PARAMETER NoteDate
Specifies the date and time for the note.

.PARAMETER Tags
Specifies an array of tags to associate with the note.

.PARAMETER ClearTags
Indicates whether to clear all existing tags.

.PARAMETER DeviceGroupIds
Specifies an array of device group IDs to associate with the note.

.PARAMETER WebsiteIds
Specifies an array of website IDs to associate with the note.

.PARAMETER DeviceIds
Specifies an array of device IDs to associate with the note.

.EXAMPLE
Set-LMOpsNote -Id 123 -Note "Updated information" -Tags @("maintenance", "planned")
Updates the operations note with ID 123 with new content and tags.

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns the response from the API containing the updated operations note information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

Function Set-LMOpsNote {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [String]$Id,

        [String]$Note,

        [Nullable[Datetime]]$NoteDate,

        [String[]]$Tags,

        [Switch]$ClearTags,

        [String[]]$DeviceGroupIds,

        [String[]]$WebsiteIds, 

        [String[]]$DeviceIds
    )

    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            If ($NoteDate) {
                $Epoch = Get-Date -Date "01/01/1970"
                [int64]$NoteDate = (New-TimeSpan -Start $Epoch -End $NoteDate.ToUniversalTime()).TotalSeconds
            }

            $Scope = @()
            If ($ResourceIds -or $WebsiteIds -or $DeviceGroupIds) {
                Foreach ($deviceId in $DeviceIds) {
                    $Scope += [PSCustomObject]@{
                        type     = "device"
                        groupId  = "0"
                        deviceId = $deviceId
                    }
                }
                Foreach ($websiteId in $WebsiteIds) {
                    $Scope += [PSCustomObject]@{
                        type      = "website"
                        groupId   = "0"
                        websiteId = $websiteId
                    }
                }
                Foreach ($groupId in $DeviceGroupIds) {
                    $Scope += @{
                        type    = "deviceGroup"
                        groupId = $groupId
                    }
                }
            }

            $TagList = @()
            Foreach ($tag in $Tags) {
                $TagList += @{name = $tag }
            }


            #Build header and uri
            $ResourcePath = "/setting/opsnotes/$Id"

            If ($PSItem) {
                $Message = "Id: $Id | Note: $($PSItem.note)"
            }
            Else {
                $Message = "Id: $Id"
            }

            Try {
                $Data = @{
                    happenOnInSec = $NoteDate
                    note          = $Note
                    tags          = $TagList
                    scopes        = $Scope
                }

                #Remove empty keys so we dont overwrite them
                If ($ClearTags) {
                    $Data.tags = @()
                }

                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys
                    -AlwaysKeepKeys @($(if ($ClearTags) { 'tags' } else { @() }))

                If ($PSCmdlet.ShouldProcess($Message, "Set Ops Note")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    Return $Response
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
