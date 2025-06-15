<#
.SYNOPSIS
Removes a LogicMonitor Service group.

.DESCRIPTION
The Remove-LMServiceGroup function is used to remove a LogicMonitor Service group. It supports removing the group by either its ID or name. The function requires valid API credentials to be logged in.

.PARAMETER Id
Specifies the ID of the Service group to be removed. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the Service group to be removed. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER DeleteHostsandChildren
Specifies whether to delete the service group and their children services within the Service group. By default, this parameter is set to $false.

.PARAMETER HardDelete
Specifies whether to perform a hard delete, which permanently removes the Service group and its associated data. By default, this parameter is set to $false.

.EXAMPLE
Remove-LMServiceGroup -Id 12345
Removes the Service group with the specified ID.

.EXAMPLE
Remove-LMServiceGroup -Name "MyServiceGroup"
Removes the Service group with the specified name.

.INPUTS
None.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed Service group and a message confirming the successful removal.

.NOTES
This function requires valid API credentials to be logged in. Use the Connect-LMAccount function to log in before running any commands.
#>
Function Remove-LMServiceGroup {
    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Boolean]$DeleteHostsandChildren = $false,

        [boolean]$HardDelete = $false

    )
    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Id if supplying username
            If ($Name) {
                $LookupResult = (Get-LMDeviceGroup -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }
            
            #Build header and uri
            $ResourcePath = "/device/groups/$Id"

            $QueryParams = "?deleteChildren=$DeleteHostsandChildren&deleteHard=$HardDelete"

            If ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            Elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            Else {
                $Message = "Id: $Id"
            }

            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove Service Group")) {                    
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams
    
                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1]
                    
                    $Result = [PSCustomObject]@{
                        Id      = $Id
                        Message = "Successfully removed ($Message)"
                    }
                    
                    Return $Result
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
