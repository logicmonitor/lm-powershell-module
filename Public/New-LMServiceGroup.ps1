<#
.SYNOPSIS
Creates a new LogicMonitor Service group.

.DESCRIPTION
The New-LMServiceGroup function creates a new LogicMonitor Service group with the specified parameters.

.PARAMETER Name
The name of the Service group. This parameter is mandatory.

.PARAMETER Description
The description of the Service group.

.PARAMETER Properties
A hashtable of custom properties for the Service group.

.PARAMETER DisableAlerting
Specifies whether alerting is disabled for the Service group. The default value is $false.

.PARAMETER ParentGroupId
The ID of the parent Service group. This parameter is mandatory when using the 'GroupId' parameter set.

.PARAMETER ParentGroupName
The name of the parent Service group. This parameter is mandatory when using the 'GroupName' parameter set.

.EXAMPLE
New-LMServiceGroup -Name "MyServiceGroup" -Description "This is a test Service group" -Properties @{ "Location" = "US"; "Environment" = "Production" }

This example creates a new LogicMonitor Service group named "MyServiceGroup" with a description and custom properties.

.EXAMPLE
New-LMServiceGroup -Name "ChildServiceGroup" -ParentGroupName "ParentServiceGroup"

This example creates a new LogicMonitor Service group named "ChildServiceGroup" with a specified parent Service group.

.NOTES
This function requires a valid LogicMonitor API authentication. Use Connect-LMAccount to authenticate before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DeviceGroup object.
#>
Function New-LMServiceGroup {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [Hashtable]$Properties,

        [Boolean]$DisableAlerting = $false,

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
            $ParentGroupId = (Get-LMDeviceGroup -Name $ParentGroupName | Select-Object -First 1 ).Id
            If (!$ParentGroupId) {
                Write-Error "Unable to find group: $ParentGroupName, please check spelling and try again."
                return
            }
        }

        #Build custom props hashtable
        $customProperties = @()
        If ($Properties) {
            Foreach ($Key in $Properties.Keys) {
                $customProperties += @{name = $Key; value = $Properties[$Key] }
            }
        }
        
        #Build header and uri
        $ResourcePath = "/device/groups"

        Try {
            $Data = @{
                name                                = $Name
                description                         = $Description
                customProperties                    = $customProperties
                disableAlerting                     = $DisableAlerting
                parentId                            = $ParentGroupId
                groupType                           = "BizService"
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceGroup" )
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
