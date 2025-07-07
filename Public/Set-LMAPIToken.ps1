<#
.SYNOPSIS
Updates a LogicMonitor API token's properties.

.DESCRIPTION
The Set-LMAPIToken function modifies the properties of an existing API token in LogicMonitor, including its note and status.

.PARAMETER AdminId
Specifies the ID of the admin user who owns the token. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER AdminName
Specifies the name of the admin user who owns the token. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER Id
Specifies the ID of the API token to modify.

.PARAMETER Note
Specifies a new note for the API token.

.PARAMETER Status
Specifies the new status for the API token. Valid values are "active" or "suspended".

.EXAMPLE
Set-LMAPIToken -AdminId 123 -Id 456 -Note "Updated token" -Status "suspended"
Updates the API token with ID 456 owned by admin 123 with a new note and status.

.INPUTS
You can pipe objects containing AdminId and Id properties to this function.

.OUTPUTS
Returns a LogicMonitor.APIToken object containing the updated token information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

function Set-LMAPIToken {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$AdminId,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$AdminName,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [String]$Note,

        [ValidateSet("active", "suspended")]
        [String]$Status

    )

    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Lookup Id if supplying AdminName
            if ($AdminName) {
                $LookupResult = (Get-LMUser -Name $AdminName).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $AdminName) {
                    return
                }
                $AdminId = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/setting/admins/$AdminId/apitokens/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | AccessId: $($PSItem.accessId)| AdminName:$($PSItem.adminName)"
            }
            else {
                $Message = "Id: $Id"
            }

            
            $Data = @{
                note   = $Note
                status = $Status
            }

            #Remove empty keys so we dont overwrite them
            if ($Status) {
                $Data.status = $(if ($Status -eq "active") { 2 } else { 1 })
            }
            $Data = Format-LMData -Data $Data -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys

            if ($PSCmdlet.ShouldProcess($Message, "Set API Token")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.APIToken" )
            }

        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
