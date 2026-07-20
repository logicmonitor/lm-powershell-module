<#
.SYNOPSIS
Copies a LogicMonitor dashboard to a new dashboard.

.DESCRIPTION
The Copy-LMDashboard function allows you to copy a LogicMonitor dashboard to a new dashboard. You can specify the name, ID, or group name of the dashboard to be copied, as well as provide a new name and optional description for the copied dashboard. The function requires valid API credentials and a logged-in session.

.PARAMETER Name
The name of the new dashboard.

.PARAMETER DashboardId
The ID of the dashboard to be copied. This parameter is mandatory when using the 'GroupId-Id' or 'GroupName-Id' parameter sets.

.PARAMETER DashboardName
The name of the dashboard to be copied. This parameter is mandatory when using the 'GroupId-Name' or 'GroupName-Name' parameter sets.

.PARAMETER Description
An optional description for the new dashboard.

.PARAMETER DashboardTokens
A hashtable of tokens to be replaced in the dashboard. The key is the token name and the value is the new value. If not provided, the tokens from the source dashboard will be used.

.PARAMETER ParentGroupId
The ID of the parent group for the new dashboard. This parameter is mandatory when using the 'GroupId-Id' or 'GroupId-Name' parameter sets.

.PARAMETER ParentGroupName
The name of the parent group for the new dashboard. This parameter is mandatory when using the 'GroupName-Id' or 'GroupName-Name' parameter sets.

.EXAMPLE
Copy-LMDashboard -Name "New Dashboard" -DashboardId 12345 -ParentGroupId 67890
Copies the dashboard with ID 12345 to a new dashboard named "New Dashboard" in the group with ID 67890.

.EXAMPLE
Copy-LMDashboard -Name "New Dashboard" -DashboardName "Old Dashboard" -ParentGroupName "Group A"
Copies the dashboard named "Old Dashboard" to a new dashboard named "New Dashboard" in the group named "Group A".

.EXAMPLE
Copy-LMDashboard -Name "New Dashboard" -DashboardName "Old Dashboard" -ParentGroupName "Group A" -DashboardTokens @{ "defaultResourceName" = "Value1"; "defaultResourceGroup" = "Value2" }
Copies the dashboard named "Old Dashboard" to a new dashboard named "New Dashboard" in the group named "Group A", replacing the tokens "defaultResourceName" with "Value1" and "defaultResourceGroup" with "Value2".

.NOTES
Ensure that you are logged in before running any commands by using the Connect-LMAccount cmdlet.
#>
function Copy-LMDashboard {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'GroupId-Id')]
        [Parameter(Mandatory, ParameterSetName = 'GroupName-Id')]
        [String]$DashboardId,

        [Parameter(Mandatory, ParameterSetName = 'GroupId-Name')]
        [Parameter(Mandatory, ParameterSetName = 'GroupName-Name')]
        [String]$DashboardName,

        [String]$Description,

        [Hashtable]$DashboardTokens,

        [Parameter(Mandatory, ParameterSetName = 'GroupId-Id')]
        [Parameter(Mandatory, ParameterSetName = 'GroupId-Name')]
        [Int]$ParentGroupId,

        [Parameter(Mandatory, ParameterSetName = 'GroupName-Id')]
        [Parameter(Mandatory, ParameterSetName = 'GroupName-Name')]
        [String]$ParentGroupName
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Lookup ParentGroupName
        if ($ParentGroupName) {
            if ($ParentGroupName -match "\*") {
                Write-Error "Wildcard values not supported for groups names."
                return
            }
            $ParentGroupId = (Get-LMDashboardGroup -Name $ParentGroupName | Select-Object -First 1 ).Id
            if (!$ParentGroupId) {
                Write-Error "Unable to find dashboard group: $ParentGroupName, please check spelling and try again."
                return
            }
        }

        #Lookup Dashboard Id
        if ($DashboardName) {
            $LookupResult = (Get-LMDashboard -Name $DashboardName).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $DashboardName) {
                return
            }
            $DashboardId = $LookupResult
        }

        #Get existing dashboard config
        $SourceDashboard = Get-LMDashboard -Id $DashboardId

        #Replace tokens
        if ($DashboardTokens) {
            $WidgetTokens = New-Object -TypeName System.Collections.ArrayList

            #Build widget tokens
            $DashboardTokens.GetEnumerator() | ForEach-Object {
                $WidgetTokens.Add( [PSCustomObject]@{
                        type        = "owned"
                        name        = $_.Key
                        value       = $_.Value
                        inheritList = @()
                    }
                ) | Out-Null
            }
            #Replace widget tokens
            $SourceDashboard.widgetTokens = $WidgetTokens
        }

        #Build header and uri
        $ResourcePath = "/dashboard/dashboards/$DashboardId/clone"

        $Data = @{
            name          = $Name
            description   = $Description
            groupId       = $ParentGroupId
            widgetTokens  = $SourceDashboard.widgetTokens
            widgetsConfig = $SourceDashboard.widgetsConfig
            widgetsOrder  = $SourceDashboard.widgetsOrder
            sharable      = $SourceDashboard.sharable
        }

        $Data = ($Data | ConvertTo-Json -Depth 10)

        $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
        $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

        Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

        #Issue request
        $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

        return $Response
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
