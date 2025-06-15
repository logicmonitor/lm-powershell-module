<#
.SYNOPSIS
Updates a LogicMonitor Service group configuration.

.DESCRIPTION
The Set-LMServiceGroup function modifies an existing Service group in LogicMonitor, allowing updates to its name, description, properties, and various other settings.

.PARAMETER Id
Specifies the ID of the Service group to modify.

.PARAMETER Name
Specifies the current name of the Service group.

.PARAMETER NewName
Specifies the new name for the Service group.

.PARAMETER Description
Specifies the new description for the Service group.

.PARAMETER Properties
Specifies a hashtable of custom properties for the Service group.

.PARAMETER PropertiesMethod
Specifies how to handle existing properties. Valid values are "Add", "Replace", or "Refresh". Default is "Replace".

.PARAMETER DisableAlerting
Specifies whether to disable alerting for the Service group.

.PARAMETER ParentGroupId
Specifies the ID of the parent group.

.PARAMETER ParentGroupName
Specifies the name of the parent group.

.EXAMPLE
Set-LMServiceGroup -Id 123 -NewName "Updated Group" -Description "New description"
Updates the Service group with ID 123 with a new name and description.

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns a LogicMonitor.DeviceGroup object containing the updated group information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
Function Set-LMServiceGroup {

    [CmdletBinding(DefaultParameterSetName = "Id-ParentGroupId", SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id-ParentGroupId', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Id-ParentGroupName')]
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

        [Parameter(ParameterSetName = 'Id-ParentGroupId')]
        [Parameter(ParameterSetName = 'Name-ParentGroupId')]
        [Nullable[Int]]$ParentGroupId,

        [Parameter(ParameterSetName = 'Id-ParentGroupName')]
        [Parameter(ParameterSetName = 'Name-ParentGroupName')]
        [String]$ParentGroupName
    )
    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Group Id
            If ($Name) {
                $LookupResult = (Get-LMDeviceGroup -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Lookup ParentGroupId
            If ($ParentGroupName) {
                $LookupResult = (Get-LMDeviceGroup -Name $ParentGroupName).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $ParentGroupName) {
                    return
                }
                $ParentGroupId = $LookupResult
            }

            #Build custom props hashtable
            $customProperties = @()
            If ($Properties) {
                Foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }
                    
            #Build header and uri
            $ResourcePath = "/device/groups/$Id"

            If ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name) | Path: $($PSItem.fullPath)"
            }
            Elseif ($Name) {
                $Message = "Id: $Id | Name: $Name)"
            }
            Else {
                $Message = "Id: $Id"
            }

            Try {
                $Data = @{
                    name             = $NewName
                    description      = $Description
                    disableAlerting  = $DisableAlerting
                    customProperties = $customProperties
                    parentId         = $ParentGroupId
                }

                #Remove empty keys so we dont overwrite them
                @($Data.Keys) | ForEach-Object {
                    if ($_ -eq 'name') {
                        if ('NewName' -notin $PSBoundParameters.Keys) { $Data.Remove($_) }
                    } else {
                        if ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) }
                    }
                }
            
                $Data = ($Data | ConvertTo-Json)

                If ($PSCmdlet.ShouldProcess($Message, "Set Device Group")) { 
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + "?opType=$($PropertiesMethod.ToLower())"

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceGroup" )
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
