<#
.SYNOPSIS
Removes a LogicMonitor access group.

.DESCRIPTION
The Remove-LMAccessGroup function removes a LogicMonitor access group based on the specified ID or name.

.PARAMETER Id
The ID of the access group to remove. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
The name of the access group to remove. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMAccessGroup -Id 123
Removes the access group with the ID 123.

.EXAMPLE
Remove-LMAccessGroup -Name "MyAccessGroup"
Removes the access group with the name "MyAccessGroup".

.INPUTS
None.

.OUTPUTS
System.Management.Automation.PSCustomObject

.NOTES
This function requires a valid LogicMonitor API authentication. Make sure to log in using Connect-LMAccount before running this command.
#>
Function Remove-LMAccessGroup {

    [CmdletBinding(DefaultParameterSetName = 'Id',SupportsShouldProcess,ConfirmImpact='High')]
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
                $LookupResult = (Get-LMAccessGroup -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            If($PSItem){
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            ElseIf($Name){
                $Message = "Id: $Id | Name: $Name"
            }
            Else{
                $Message = "Id: $Id"
            }
            
            #Build header and uri
            $ResourcePath = "/setting/accessgroup/$Id"

            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove AccessGroup")) {                    
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
    
                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1]
                    
                    $Result = [PSCustomObject]@{
                        Id = $Id
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
