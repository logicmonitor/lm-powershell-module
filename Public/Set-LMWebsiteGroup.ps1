<#
.SYNOPSIS
Updates a LogicMonitor website group configuration.

.DESCRIPTION
The Set-LMWebsiteGroup function modifies an existing website group in LogicMonitor.

.PARAMETER Id
Specifies the ID of the website group to modify.

.PARAMETER Name
Specifies the current name of the website group.

.PARAMETER NewName
Specifies the new name for the website group.

.PARAMETER Description
Specifies the description for the website group.

.PARAMETER Properties
Specifies a hashtable of custom properties for the website group.

.PARAMETER PropertiesMethod
Specifies how to handle properties. Valid values: "Add", "Replace", "Refresh".

.PARAMETER DisableAlerting
Indicates whether to disable alerting for the website group.

.PARAMETER StopMonitoring
Indicates whether to stop monitoring the website group.

.PARAMETER ParentGroupId
Specifies the ID of the parent group.

.PARAMETER ParentGroupName
Specifies the name of the parent group.

.EXAMPLE
Set-LMWebsiteGroup -Id 123 -NewName "Updated Group" -Description "New description" -ParentGroupId 456
Updates the website group with new name, description, and parent group.

.INPUTS
None.

.OUTPUTS
Returns a LogicMonitor.WebsiteGroup object containing the updated configuration.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

function Set-LMWebsiteGroup {

    [CmdletBinding(DefaultParameterSetName = 'Id-ParentGroupId', SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id-ParentGroupId', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Id-ParentGroupName', ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name-ParentGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-ParentGroupName')]
        [String]$Name,

        [String]$NewName,

        [String]$Description,

        [Hashtable]$Properties,

        [ValidateSet("Add", "Replace", "Refresh")] # Add will append to existing prop, Replace will update existing props if specified and add new props, refresh will replace existing props with new
        [String]$PropertiesMethod = "Replace",

        [Nullable[boolean]]$DisableAlerting,

        [Nullable[boolean]]$StopMonitoring,

        #Need to implement testLocation

        [Parameter(ParameterSetName = 'Id-ParentGroupId')]
        [Parameter(ParameterSetName = 'Name-ParentGroupId')]
        [Nullable[Int]]$ParentGroupId,

        [Parameter(ParameterSetName = 'Id-ParentGroupName')]
        [Parameter(ParameterSetName = 'Name-ParentGroupName')]
        [String]$ParentGroupName
    )
    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Lookup ParentGroupName
            if ($Name) {
                $LookupResult = (Get-LMWebsiteGroup -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

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
            $ResourcePath = "/website/groups/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            else {
                $Message = "Id: $Id"
            }

            $Data = @{
                name            = $NewName
                description     = $Description
                disableAlerting = $DisableAlerting
                stopMonitoring  = $StopMonitoring
                properties      = $customProperties
                parentId        = $ParentGroupId
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                -ConditionalKeep @{ 'name' = 'NewName' } `
                -ConditionalValueKeep @{ 'PropertiesMethod' = @(@{ Value = 'Refresh'; KeepKeys = @('customProperties') }) } `
                -Context @{ PropertiesMethod = $PropertiesMethod }

            if ($PSCmdlet.ShouldProcess($Message, "Set Website Group")) {
                
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + "?opType=$($PropertiesMethod.ToLower())"

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request using new centralized method with retry logic
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.WebsiteGroup" )

            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
