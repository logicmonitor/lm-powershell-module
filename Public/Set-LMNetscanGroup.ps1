<#
.SYNOPSIS
Updates a LogicMonitor NetScan group configuration.

.DESCRIPTION
The Set-LMNetscanGroup function modifies an existing NetScan group in LogicMonitor.

.PARAMETER Id
Specifies the ID of the NetScan group to modify.

.PARAMETER Name
Specifies the current name of the NetScan group.

.PARAMETER NewName
Specifies the new name for the NetScan group.

.PARAMETER Description
Specifies the new description for the NetScan group.

.EXAMPLE
Set-LMNetscanGroup -Id 123 -NewName "Updated Group" -Description "New description"
Updates the NetScan group with ID 123 with a new name and description.

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns a LogicMonitor.NetScanGroup object containing the updated group information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

Function Set-LMNetscanGroup {

    [CmdletBinding()]
    Param (

        [Parameter(ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [String]$NewName,

        [String]$Description

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        
        If ($Script:LMAuth.Valid) {
            #Lookup Netscan Group Id
            If ($Name) {
                $LookupResult = (Get-LMNetScanGroup -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/setting/netscans/groups/$Id"

            Try {
                $Data = @{
                    description = $Description
                    name        = $NewName
                }

            
                #Remove empty keys so we dont overwrite them
                @($Data.Keys) | ForEach-Object {
                    if ($_ -eq 'name') {
                        if ('NewName' -notin $PSBoundParameters.Keys) { $Data.Remove($_) }
                    } else {
                        if ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) }
                    }
                }
            
                $Data = ($Data | ConvertTo-Json)

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.NetScanGroup" )
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
