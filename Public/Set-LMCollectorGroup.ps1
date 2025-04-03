<#
.SYNOPSIS
Updates a LogicMonitor collector group's configuration.

.DESCRIPTION
The Set-LMCollectorGroup function modifies an existing collector group's settings, including its name, description, properties, and auto-balance settings.

.PARAMETER Id
Specifies the ID of the collector group to modify. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the current name of the collector group. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER NewName
Specifies the new name for the collector group.

.PARAMETER Description
Specifies a new description for the collector group.

.PARAMETER Properties
Specifies a hashtable of custom properties to set for the collector group.

.PARAMETER AutoBalance
Specifies whether to enable auto-balancing for the collector group.

.PARAMETER AutoBalanceInstanceCountThreshold
Specifies the threshold for auto-balancing the collector group.

.EXAMPLE
Set-LMCollectorGroup -Id 123 -NewName "Updated Group" -AutoBalance $true
Updates the collector group with ID 123 with a new name and enables auto-balancing.

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns a LogicMonitor.CollectorGroup object containing the updated group information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
Function Set-LMCollectorGroup {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (

        [Parameter(ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [String]$NewName,

        [String]$Description,

        [Hashtable]$Properties,

        [Nullable[boolean]]$AutoBalance,

        [Nullable[Int]]$AutoBalanceInstanceCountThreshold

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            #Lookup Collector Name
            If ($Name) {
                $LookupResult = (Get-LMCollectorGroup -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build custom props hashtable
            $customProperties = @()
            If ($Properties) {
                Foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }
                    
            #Build header and uri
            $ResourcePath = "/setting/collector/groups/$Id"

            If ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name) | Description: $($PSItem.description)"
            }
            Elseif ($Name) {
                $Message = "Id: $Id | Name: $Name)"
            }
            Else {
                $Message = "Id: $Id"
            }

            Try {
                $Data = @{
                    description                       = $Description
                    name                              = $NewName
                    collectorGroupId                  = $CollectorGroupId
                    customProperties                  = $customProperties
                    autoBalance                       = $AutoBalance
                    autoBalanceInstanceCountThreshold = $AutoBalanceInstanceCountThreshold
                }

            
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { If ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }

                $Data = ($Data | ConvertTo-Json)

                If ($PSCmdlet.ShouldProcess($Message, "Set Collector Group")) {  
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.CollectorGroup" )
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
