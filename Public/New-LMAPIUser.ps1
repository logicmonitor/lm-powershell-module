<#
.SYNOPSIS
Creates a new LogicMonitor API user.

.DESCRIPTION
The New-LMAPIUser function creates a new API-only user in LogicMonitor with specified roles and group memberships.

.PARAMETER Username
The username for the new API user. This parameter is mandatory.

.PARAMETER UserGroups
The user groups to add the new user to.

.PARAMETER Note
A note describing the purpose of the API user.

.PARAMETER RoleNames
The roles to assign to the user. Defaults to "readonly".

.PARAMETER Status
The status of the user. Valid values are "active" and "suspended". Defaults to "active".

.EXAMPLE
#Create a new API user
New-LMAPIUser -Username "api.user" -UserGroups @("Group1","Group2") -RoleNames @("admin") -Note "API user for automation"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns the created user object.
#>
Function New-LMAPIUser {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Username,

        [String[]]$UserGroups,

        [String]$Note,

        [String[]]$RoleNames = @("readonly"),

        [ValidateSet("active", "suspended")]
        [String]$Status = "active"
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Build role id list
        $Roles = @()
        Foreach ($Role in $RoleNames) {
            $RoleId = (Get-LMRole -Name $Role | Select-Object -First 1 ).Id
            If ($RoleId) {
                $Roles += @{id = $RoleId }
            }
            Else {
                Write-Warning "[WARN]: Unable to locate user role named $Role, it will be skipped" 
            }
        }

        $AdminGroupIds = ""
        If ($UserGroups) {
            $AdminGroupIds = @()
            Foreach ($Group in $UserGroups) {
                If ($Group -Match "\*") {
                    Write-Error "Wildcard values not supported for groups." 
                    return
                }
                $Id = (Get-LMUserGroup -Name $Group | Select-Object -First 1 ).Id
                If (!$Id) {
                    Write-Error "Unable to find user group: $Group, please check spelling and try again." 
                    return
                }
                $AdminGroupIds += $Id
            }
        }

        
        #Build header and uri
        $ResourcePath = "/setting/admins"

        #Loop through requests 
        $Done = $false
        While (!$Done) {
            Try {
                $Data = @{
                    username      = $Username
                    note          = $Note
                    roles         = $Roles
                    status        = $Status
                    adminGroupIds = $AdminGroupIds
                    apionly       = $true

                }

                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { If ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }

                $Data = ($Data | ConvertTo-Json)

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return $Response
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
