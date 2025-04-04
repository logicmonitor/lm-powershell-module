<#
.SYNOPSIS
Removes a user from LogicMonitor.

.DESCRIPTION
The Remove-LMUser function removes a user from LogicMonitor using either their ID or name.

.PARAMETER Id
Specifies the ID of the user to remove. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the user to remove. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMUser -Id 123
Removes the user with ID 123.

.EXAMPLE
Remove-LMUser -Name "JohnDoe"
Removes the user with the name "JohnDoe".

.INPUTS
You can pipe objects to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed user and a success message confirming the removal.
#>

Function Remove-LMUser {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name

    )
    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Id if supplying username
            If ($Name) {
                $LookupResult = (Get-LMUser -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }
            
            #Build header and uri
            $ResourcePath = "/setting/admins/$Id"

            If ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.username)"
            }
            Elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            Else {
                $Message = "Id: $Id"
            }

            #Loop through requests 
            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove User")) {                    
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
    
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
