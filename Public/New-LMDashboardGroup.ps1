<#
.SYNOPSIS
Creates a new LogicMonitor dashboard group.

.DESCRIPTION
The New-LMDashboardGroup function creates a new dashboard group in LogicMonitor. It can be created under a parent group specified by either ID or name.

.PARAMETER Name
The name of the dashboard group. This parameter is mandatory.

.PARAMETER Description
The description of the dashboard group.

.PARAMETER WidgetTokens
A hashtable containing widget tokens for the dashboard group.

.PARAMETER ParentGroupId
The ID of the parent group. Required for GroupId parameter set.

.PARAMETER ParentGroupName
The name of the parent group. Required for GroupName parameter set.

.EXAMPLE
#Create dashboard group using parent ID
New-LMDashboardGroup -Name "Operations" -Description "Operations dashboards" -ParentGroupId 123

.EXAMPLE
#Create dashboard group using parent name
New-LMDashboardGroup -Name "Operations" -Description "Operations dashboards" -ParentGroupName "Root"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns the created dashboard group object.
#>
Function New-LMDashboardGroup {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [Hashtable]$WidgetTokens,

        [Parameter(Mandatory, ParameterSetName = 'GroupId')]
        [Int]$ParentGroupId,

        [Parameter(Mandatory, ParameterSetName = 'GroupName')]
        [String]$ParentGroupName
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Lookup ParentGroupName
        If ($ParentGroupName) {
            If ($ParentGroupName -Match "\*") {
                Write-Error "Wildcard values not supported for groups names."
                return
            }
            $ParentGroupId = (Get-LMDashboardGroup -Name $ParentGroupName | Select-Object -First 1 ).Id
            If (!$ParentGroupId) {
                Write-Error "Unable to find dashboard group: $ParentGroupName, please check spelling and try again." 
                return
            }
        }

        #Build custom props hashtable
        $WidgetTokensArray = @()
        If ($WidgetTokens) {
            Foreach ($Key in $WidgetTokens.Keys) {
                $WidgetTokensArray += @{name = $Key; value = $WidgetTokens[$Key] }
            }
        }
        
        #Build header and uri
        $ResourcePath = "/dashboard/groups"

        Try {
            $Data = @{
                name         = $Name
                description  = $Description
                parentId     = $ParentGroupId
                widgetTokens = $WidgetTokensArray
            }

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
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
