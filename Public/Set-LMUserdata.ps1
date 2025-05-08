<#
.SYNOPSIS
Sets userdata for a LogicMonitor user, currently only setting the default dashboard is supported.

.DESCRIPTION
The Set-LMUserdata function is used to set the user data for a LogicMonitor user. It allows you to specify the user by either their Id or Name, and the dashboard Id for which the user data should be set.

.PARAMETER Id
Specifies the Id of the user. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the Name of the user. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER DashboardId
Specifies the Id of the dashboard for which the user data should be set. This parameter is mandatory.

.EXAMPLE
Set-LMUserdata -Id "12345" -DashboardId "67890"
Sets the user data for the user with Id "12345" for the dashboard with Id "67890".

.EXAMPLE
Set-LMUserdata -Name "JohnDoe" -DashboardId "67890"
Sets the user data for the user with Name "JohnDoe" for the dashboard with Id "67890".

.INPUTS
None.

.OUTPUTS
Returns the response from the LogicMonitor API.

.NOTES
This function requires a valid API authentication. Make sure you are logged in before running any commands using Connect-LMAccount.

#>
Function Set-LMUserdata {
    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory)]
        [String]$DashboardId
    )

    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Id if supplying AdminName
            If ($Name) {
                $LookupResult = (Get-LMUser -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Get Dashboard JSON response
            If ($DashboardId) {
                $Dashboard = Get-LMDashboard -Id $DashboardId
                If (Test-LookupResult -Result $Dashboard -LookupString $DashboardId) {
                    return
                }
                $Value = $Dashboard | ConvertTo-Json
            }
            
            #Build header and uri
            $ResourcePath = "/setting/userdata/$Id.user.default.dashboard"

            If ($PSItem) {
                $Message = "Id: $Id | AccessId: $($PSItem.accessId)| AdminName:$($PSItem.adminName)"
            }
            Else {
                $Message = "Id: $Id"
            }

            Try {
                $Data = @{
                    id    = "$Id.user.default.dashboard"
                    value = $Value
                }
                
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { If ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }
                
                If ($Status) {
                    $Data.status = $(If ($Status -eq "active") { 2 }Else { 1 })
                }
                
                $Data = ($Data | ConvertTo-Json)
                
                If ($PSCmdlet.ShouldProcess($Message, "Set API Token")) {  
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    $Result = [PSCustomObject]@{
                        Id      = $Id
                        Message = "Successfully updated userdata for default dashboard to id: ($DashboardId)"
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
