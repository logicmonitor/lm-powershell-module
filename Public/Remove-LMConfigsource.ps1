<#
.SYNOPSIS
Removes a LogicMonitor configsource.

.DESCRIPTION
The Remove-LMConfigsource function removes a LogicMonitor configsource based on the specified Id or Name.

.PARAMETER Id
Specifies the Id of the configsource to remove. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the Name of the configsource to remove. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMConfigsource -Id 123
Removes the configsource with Id 123.

.EXAMPLE
Remove-LMConfigsource -Name "ConfigSource1"
Removes the configsource with the name "ConfigSource1".

.NOTES
Please ensure you are logged in before running any commands. Use Connect-LMAccount to login and try again.

.INPUTS
You can pipe objects to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed configsource and a success message confirming the removal.
#>
function Remove-LMConfigsource {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name

    )

    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Lookup Id if supplying username
            if ($Name) {
                $LookupResult = (Get-LMPropertySource -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }


            #Build header and uri
            $ResourcePath = "/setting/configsources/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            else {
                $Message = "Id: $Id"
            }

            
            if ($PSCmdlet.ShouldProcess($Message, "Remove Configsource")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1] | Out-Null

                $Result = [PSCustomObject]@{
                    Id      = $Id
                    Message = "Successfully removed ($Message)"
                }

                return $Result
            }

        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
