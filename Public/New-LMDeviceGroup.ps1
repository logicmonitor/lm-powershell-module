<#
.SYNOPSIS
Creates a new LogicMonitor device group.

.DESCRIPTION
The New-LMDeviceGroup function creates a new LogicMonitor device group with the specified parameters.

.PARAMETER Name
The name of the device group. This parameter is mandatory.

.PARAMETER Description
The description of the device group.

.PARAMETER Properties
A hashtable of custom properties for the device group.

.PARAMETER DisableAlerting
Specifies whether alerting is disabled for the device group. The default value is $false.

.PARAMETER EnableNetFlow
Specifies whether NetFlow is enabled for the device group. The default value is $false.

.PARAMETER ParentGroupId
The ID of the parent device group. This parameter is mandatory when using the 'GroupId' parameter set.

.PARAMETER ParentGroupName
The name of the parent device group. This parameter is mandatory when using the 'GroupName' parameter set.

.PARAMETER AppliesTo
The applies to value for the device group.

.EXAMPLE
New-LMDeviceGroup -Name "MyDeviceGroup" -Description "This is a test device group" -Properties @{ "Location" = "US"; "Environment" = "Production" } -DisableAlerting $true

This example creates a new LogicMonitor device group named "MyDeviceGroup" with a description and custom properties. Alerting is disabled for this device group.

.EXAMPLE
New-LMDeviceGroup -Name "ChildDeviceGroup" -ParentGroupName "ParentDeviceGroup"

This example creates a new LogicMonitor device group named "ChildDeviceGroup" with a specified parent device group.

.NOTES
This function requires a valid LogicMonitor API authentication. Use Connect-LMAccount to authenticate before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DeviceGroup object.
#>
function New-LMDeviceGroup {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [Hashtable]$Properties,

        [Boolean]$DisableAlerting = $false,

        [Boolean]$EnableNetFlow = $false,

        [Parameter(Mandatory, ParameterSetName = 'GroupId')]
        [Int]$ParentGroupId,

        [Parameter(Mandatory, ParameterSetName = 'GroupName')]
        [String]$ParentGroupName,

        [String]$AppliesTo
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Lookup ParentGroupName
        if ($ParentGroupName) {
            if ($ParentGroupName -match "\*") {
                Write-Error "Wildcard values not supported for groups names."
                return
            }
            $ParentGroupId = (Get-LMDeviceGroup -Name $ParentGroupName | Select-Object -First 1 ).Id
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
        $ResourcePath = "/device/groups"

        $Data = @{
            name                                = $Name
            description                         = $Description
            appliesTo                           = $AppliesTo
            disableAlerting                     = $DisableAlerting
            enableNetflow                       = $EnableNetFlow
            customProperties                    = $customProperties
            parentId                            = $ParentGroupId
            defaultAutoBalancedCollectorGroupId = 0
            defaultCollectorGroupId             = 0
            defaultCollectorId                  = 0
        }

        $Data = ($Data | ConvertTo-Json)

        $Message = "Name: $Name"

        if ($PSCmdlet.ShouldProcess($Message, "Create Device Group")) {
            try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceGroup" )
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
