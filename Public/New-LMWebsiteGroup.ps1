<#
.SYNOPSIS
Creates a new LogicMonitor website group.

.DESCRIPTION
The New-LMWebsiteGroup function creates a new website group in LogicMonitor. It allows you to specify the name, description, properties, and parent group of the website group.

.PARAMETER Name
The name of the website group. This parameter is mandatory.

.PARAMETER Description
The description of the website group.

.PARAMETER Properties
A hashtable of custom properties for the website group.

.PARAMETER DisableAlerting
Specifies whether to disable alerting for the website group. By default, alerting is enabled.

.PARAMETER StopMonitoring
Specifies whether to stop monitoring the website group. By default, monitoring is not stopped.

.PARAMETER ParentGroupId
The ID of the parent group. This parameter is mandatory if the ParentGroupName parameter is not specified.

.PARAMETER ParentGroupName
The name of the parent group. This parameter is mandatory if the ParentGroupId parameter is not specified.

.EXAMPLE
New-LMWebsiteGroup -Name "MyWebsiteGroup" -Description "This is my website group" -ParentGroupId 1234

This example creates a new website group with the name "MyWebsiteGroup", description "This is my website group", and parent group ID 1234.

.EXAMPLE
New-LMWebsiteGroup -Name "MyWebsiteGroup" -Description "This is my website group" -ParentGroupName "ParentGroup"

This example creates a new website group with the name "MyWebsiteGroup", description "This is my website group", and parent group name "ParentGroup".

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.WebsiteGroup object.
#>
function New-LMWebsiteGroup {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [Hashtable]$Properties,

        [Boolean]$DisableAlerting = $false,

        [boolean]$StopMonitoring = $false,

        [Parameter(Mandatory, ParameterSetName = 'GroupId')]
        [Int]$ParentGroupId,

        [Parameter(Mandatory, ParameterSetName = 'GroupName')]
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
            $ParentGroupId = (Get-LMWebsiteGroup -Name $ParentGroupName | Select-Object -First 1 ).Id
            if (!$ParentGroupId) {
                Write-Error "Unable to find group: $ParentGroupName, please check spelling and try again."
                return
            }
        }

        #Build custom props hashtable
        $customProperties = @()
        if ($Properties) {
            foreach ($Key in $Properties.Keys) {
                $customProperties += @{name = $Key; value = $Properties[$Key] }
            }
        }

        #Build header and uri
        $ResourcePath = "/website/groups"

        $Data = @{
            name            = $Name
            description     = $Description
            disableAlerting = $DisableAlerting
            stopMonitoring  = $StopMonitoring
            properties      = $customProperties
            parentId        = $ParentGroupId
        }

        $Data = ($Data | ConvertTo-Json)

        $Message = "Name: $Name"

        if ($PSCmdlet.ShouldProcess($Message, "Create Website Group")) {
            
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.WebsiteGroup" )

        }
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
