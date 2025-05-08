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

Function Set-LMAPIToken {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (
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

    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Id if supplying AdminName
            If ($AdminName) {
                $LookupResult = (Get-LMUser -Name $AdminName).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $AdminName) {
                    return
                }
                $AdminId = $LookupResult
            }
            
            #Build header and uri
            $ResourcePath = "/setting/admins/$AdminId/apitokens/$Id"

            If ($PSItem) {
                $Message = "Id: $Id | AccessId: $($PSItem.accessId)| AdminName:$($PSItem.adminName)"
            }
            Else {
                $Message = "Id: $Id"
            }

            Try {
                $Data = @{
                    note   = $Note
                    status = $Status
                }
                
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { If ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }
                
                If ($Status) {
                    $Data.status = $(If ($Status -eq "active") { 2 }Else { 1 })
                }
                
                $Data = ($Data | ConvertTo-Json)
                
                If ($PSCmdlet.ShouldProcess($Message, "Set API Token")) {  
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.APIToken" )
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
