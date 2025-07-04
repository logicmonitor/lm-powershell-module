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

function Set-LMOpsNote {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
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

    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            if ($NoteDate) {
                $Epoch = Get-Date -Date "01/01/1970"
                [int64]$NoteDate = (New-TimeSpan -Start $Epoch -End $NoteDate.ToUniversalTime()).TotalSeconds
            }

            $Scope = @()
            if ($ResourceIds -or $WebsiteIds -or $DeviceGroupIds) {
                foreach ($deviceId in $DeviceIds) {
                    $Scope += [PSCustomObject]@{
                        type     = "device"
                        groupId  = "0"
                        deviceId = $deviceId
                    }
                }
                foreach ($websiteId in $WebsiteIds) {
                    $Scope += [PSCustomObject]@{
                        type      = "website"
                        groupId   = "0"
                        websiteId = $websiteId
                    }
                }
                foreach ($groupId in $DeviceGroupIds) {
                    $Scope += @{
                        type    = "deviceGroup"
                        groupId = $groupId
                    }
                }
            }

            $TagList = @()
            foreach ($tag in $Tags) {
                $TagList += @{name = $tag }
            }


            #Build header and uri
            $ResourcePath = "/setting/opsnotes/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | Note: $($PSItem.note)"
            }
            else {
                $Message = "Id: $Id"
            }

            try {
                $Data = @{
                    happenOnInSec = $NoteDate
                    note          = $Note
                    tags          = $TagList
                    scopes        = $Scope
                }

                #Remove empty keys so we dont overwrite them
                if ($ClearTags) {
                    $Data.tags = @()
                }

                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys
                -AlwaysKeepKeys @($(if ($ClearTags) { 'tags' } else { @() }))

                if ($PSCmdlet.ShouldProcess($Message, "Set Ops Note")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-LMRestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    return $Response
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
