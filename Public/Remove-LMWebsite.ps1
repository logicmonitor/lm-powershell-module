<#
.SYNOPSIS
Removes a website from LogicMonitor.

.DESCRIPTION
The Remove-LMWebsite function removes a website from LogicMonitor using either its ID or name.

.PARAMETER Id
Specifies the ID of the website to remove. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the website to remove. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMWebsite -Id 123
Removes the website with ID 123.

.EXAMPLE
Remove-LMWebsite -Name "MyWebsite"
Removes the website with the name "MyWebsite".

.INPUTS
You can pipe objects to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed website and a success message confirming the removal.
#>

Function Remove-LMWebsite {

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
                $LookupResult = (Get-LMWebsite -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/website/websites/$Id"

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
                If ($PSCmdlet.ShouldProcess($Message, "Remove Website")) {                    
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath
    
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
