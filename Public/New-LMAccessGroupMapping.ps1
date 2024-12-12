<#
.SYNOPSIS
Creates a new LogicMonitor access group mapping between an access group and an logicmodule.

.DESCRIPTION
The New-LMAccessGroupMapping function is used to create a new access group mapping in LogicMonitor. 

.PARAMETER AccessGroupIds
The IDs of the access group. This parameter is mandatory.

.PARAMETER LogicModuleType
The type of logic module. This parameter is mandatory.

.PARAMETER LogicModuleId
The ID of the logic module. This parameter is mandatory.

.EXAMPLE
New-LMAccessGroupMapping -AccessGroupIds "12345" -LogicModuleType "DATASOURCE" -LogicModuleId "67890"

This example creates a new access group mapping for the access group with ID "12345" and the logic module with ID "67890".

.NOTES
For this function to work, you need to be logged in and have valid API credentials. Use the Connect-LMAccount function to log in before running any commands.
#>
Function New-LMAccessGroupMapping {

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory)]
        [String[]]$AccessGroupIds,

        [Parameter(Mandatory)]
        [ValidateSet("DATASOURCE", "EVENTSOURCE", "BATCHJOB", "JOBMONITOR", "LOGSOURCE", "TOPOLOGYSOURCE", "PROPERTYSOURCE", "APPLIESTO_FUNCTION", "SNMP_SYSOID_MAP")]
        [String]$LogicModuleType,

        [Parameter(Mandatory)]
        [Int]$LogicModuleId

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
                    
            #Build header and uri
            $ResourcePath = "/setting/accessgroup/mapunmap/modules"

            $MappingDetailsArray = New-Object -TypeName System.Collections.ArrayList

            $MappingDetailsArray.Add([PSCustomObject]@{
                moduletype      = $LogicModuleType
                moduleid        = $LogicModuleId
                accessgroups    = $AccessGroupIds
            }) | Out-Null

            Try {
                $Data = [PSCustomObject]@{
                    mappingDetails = $MappingDetailsArray
                }

                $Data = ($Data | ConvertTo-Json -Depth 10)
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                If($Response.failure) {
                    Foreach($Failure in $Response.failure) {
                        Write-Warning "$Failure"
                }
            }
                If($Response.success) {
                    Foreach($Success in $Response.success) {
                        Write-Information "[INFO]: Successfully mapped ($LogicModuleType/$LogicModuleId) to accessgroup(s): $($AccessGroupIds -join ',')"
                    }
                }

                Return $Response.mappingDetails
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
