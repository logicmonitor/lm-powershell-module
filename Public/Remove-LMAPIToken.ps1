<#
.SYNOPSIS
Removes an API token from Logic Monitor.

.DESCRIPTION
The Remove-LMAPIToken function is used to remove an API token from Logic Monitor. It supports removing the token by specifying either the token's ID, the user's ID and token's ID, or the user's name and token's ID.

.PARAMETER UserId
The ID of the user associated with the API token. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER UserName
The name of the user associated with the API token. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER AccessId
The access ID of the API token. This parameter is mandatory when using the 'AccessId' parameter set.

.PARAMETER APITokenId
The ID of the API token. This parameter is mandatory when using the 'Id' or 'Name' parameter set.

.EXAMPLE
Remove-LMAPIToken -UserId 1234 -APITokenId 5678
Removes the API token with ID 5678 associated with the user with ID 1234.

.EXAMPLE
Remove-LMAPIToken -UserName "john.doe" -APITokenId 5678
Removes the API token with ID 5678 associated with the user with name "john.doe".

.EXAMPLE
Remove-LMAPIToken -AccessId "abcd1234"
Removes the API token with the specified access ID.

.NOTES
This function requires a valid API authentication. Make sure to log in using Connect-LMAccount before running this command.

.INPUTS
You can pipe API token objects to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed API token and a success message confirming the removal.
#>
function Remove-LMAPIToken {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$UserId,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$UserName,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'AccessId')]
        [String]$AccessId,

        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [Int]$APITokenId
    )

    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Lookup UserName Id if supplying username
            if ($UserName) {
                $LookupResult = (Get-LMUser -Name $UserName).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $UserName) {
                    return
                }
                $UserId = $LookupResult
            }

            if ($AccessId) {
                $LookupResult = (Get-LMAPIToken -AccessId $AccessId)
                if (Test-LookupResult -Result $LookupResult -LookupString $AccessId) {
                    return
                }
                $UserId = $LookupResult.adminId
                $APITokenId = $LookupResult.id
            }

            #Build header and uri
            $ResourcePath = "/setting/admins/$UserId/apitokens/$APITokenId"

            if ($PSItem) {
                $Message = "Id: $APITokenId | AccessId: $($PSItem.accessId)| AdminName:$($PSItem.adminName)"
            }
            else {
                $Message = "Id: $APITokenId"
            }

            try {
                if ($PSCmdlet.ShouldProcess($Message, "Remove API Token")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                    #Issue request
                    Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1] | Out-Null

                    $Result = [PSCustomObject]@{
                        Id      = $APITokenId
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
