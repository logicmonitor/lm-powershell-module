<#
.SYNOPSIS
Creates a new LogicMonitor API token.

.DESCRIPTION
The New-LMAPIToken function creates a new API token for a specified user in LogicMonitor.

.PARAMETER Id
The ID of the user to create the token for. Required for Id parameter set.

.PARAMETER Username
The username to create the token for. Required for Username parameter set.

.PARAMETER Note
A note describing the purpose of the API token.

.PARAMETER CreateDisabled
Switch to create the token in a disabled state.

.PARAMETER Type
The type of API token to create. Valid values are "LMv1" and "Bearer". Defaults to "LMv1".

.EXAMPLE
#Create a token by user ID
New-LMAPIToken -Id "12345" -Note "API Token for automation"

.EXAMPLE
#Create a token by username
New-LMAPIToken -Username "john.doe" -Type "Bearer" -CreateDisabled

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.APIToken object.
#>

function New-LMAPIToken {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [String[]]$Id,
        [Parameter(Mandatory, ParameterSetName = 'Username')]
        [String]$Username,
        [String]$Note,
        [Switch]$CreateDisabled,
        [ValidateSet("LMv1", "Bearer")]
        [String]$Type = "LMv1"
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        if ($Username) {
            if ($Username -match "\*") {
                Write-Error "Wildcard values not supported for device group name."
                return
            }
            $Id = (Get-LMUser -Name $Username | Select-Object -First 1 ).Id
            if (!$Id) {
                Write-Error "Unable to find user with name: $Username, please check spelling and try again."
                return
            }
        }

        #Build header and uri
        if ($Type -eq "Bearer") {
            $Params = "?type=bearer"
        }

        $ResourcePath = "/setting/admins/$Id/apitokens"

        $Data = @{
            note   = $Note
            status = $(if ($CreateDisabled) { 1 }else { 2 })
        }

        $Data = ($Data | ConvertTo-Json)

        $Message = "User ID: $Id | Type: $Type"

        if ($PSCmdlet.ShouldProcess($Message, "Create API Token")) {
            try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $Params

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.APIToken" )
            }
            catch {
                return
            }
        }
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
