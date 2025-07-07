<#
.SYNOPSIS
Removes a LogicMonitor datasource.

.DESCRIPTION
The Remove-LMDatasource function removes a LogicMonitor datasource based on the specified parameters. It requires the user to be logged in and have valid API credentials.

.PARAMETER Id
Specifies the ID of the datasource to be removed. This parameter is mandatory and can be provided as an integer.

.PARAMETER Name
Specifies the name of the datasource to be removed. This parameter is mandatory when using the 'Name' parameter set and can be provided as a string.

.PARAMETER DisplayName
Specifies the display name of the datasource to be removed. This parameter is mandatory when using the 'DisplayName' parameter set and can be provided as a string.

.EXAMPLE
Remove-LMDatasource -Id 123
Removes the datasource with the ID 123.

.EXAMPLE
Remove-LMDatasource -Name "MyDatasource"
Removes the datasource with the name "MyDatasource".

.EXAMPLE
Remove-LMDatasource -DisplayName "My Datasource"
Removes the datasource with the display name "My Datasource".

.INPUTS
You can pipe input to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed datasource and a success message confirming the removal.
#>
function Remove-LMDatasource {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'DisplayName')]
        [String]$DisplayName

    )

    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Lookup Id if supplying username
            if ($Name) {
                $LookupResult = (Get-LMDatasource -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Lookup Id if supplying displayname
            if ($DisplayName) {
                $LookupResult = (Get-LMDatasource -DisplayName $DisplayName).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $DisplayName) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/setting/datasources/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name) | DisplayName: $($PSItem.displayName)"
            }
            else {
                $Message = "Id: $Id"
            }

            try {
                if ($PSCmdlet.ShouldProcess($Message, "Remove Datasource")) {
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
