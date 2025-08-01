<#
.SYNOPSIS
Removes an AppliesTo function from LogicMonitor.

.DESCRIPTION
The Remove-LMAppliesToFunction function removes an AppliesTo function from LogicMonitor. It can be used to remove a function either by its name or its ID.

.PARAMETER Name
Specifies the name of the AppliesTo function to be removed. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER Id
Specifies the ID of the AppliesTo function to be removed. This parameter is mandatory when using the 'Id' parameter set.

.EXAMPLE
Remove-LMAppliesToFunction -Name "MyAppliesToFunction"
Removes the AppliesTo function with the name "MyAppliesToFunction".

.EXAMPLE
Remove-LMAppliesToFunction -Id 12345
Removes the AppliesTo function with the ID 12345.

.NOTES
This function requires a valid LogicMonitor API authentication. Make sure to log in using Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed AppliesTo function and a success message confirming the removal.
#>
function Remove-LMAppliesToFunction {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id

    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Lookup Id if supplying name
            if ($Name) {
                $LookupResult = (Get-LMAppliesToFunction -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/setting/functions/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | Name:$($PSItem.name)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            else {
                $Message = "Id: $Id"
            }

            
            if ($PSCmdlet.ShouldProcess($Message, "Remove AppliesTo Function")) {
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
