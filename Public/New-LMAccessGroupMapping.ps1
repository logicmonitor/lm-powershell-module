<#
.SYNOPSIS
Creates a new LogicMonitor access group mapping.

.DESCRIPTION
The New-LMAccessGroupMapping function creates a mapping between an access group and a logic module in LogicMonitor.

.PARAMETER AccessGroupIds
The IDs of the access groups to map. This parameter is mandatory.

.PARAMETER LogicModuleType
The type of logic module. Valid values are "DATASOURCE", "EVENTSOURCE", "BATCHJOB", "JOBMONITOR", "LOGSOURCE", "TOPOLOGYSOURCE", "PROPERTYSOURCE", "APPLIESTO_FUNCTION", "SNMP_SYSOID_MAP".

.PARAMETER LogicModuleId
The ID of the logic module to map. This parameter is mandatory.

.EXAMPLE
#Create a new access group mapping
New-LMAccessGroupMapping -AccessGroupIds "12345" -LogicModuleType "DATASOURCE" -LogicModuleId "67890"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns mapping details object.
#>
function New-LMAccessGroupMapping {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (

        [Parameter(Mandatory)]
        [String[]]$AccessGroupIds,

        [Parameter(Mandatory)]
        [ValidateSet("DATASOURCE", "EVENTSOURCE", "BATCHJOB", "JOBMONITOR", "LOGSOURCE", "TOPOLOGYSOURCE", "PROPERTYSOURCE", "APPLIESTO_FUNCTION", "SNMP_SYSOID_MAP")]
        [String]$LogicModuleType,

        [Parameter(Mandatory)]
        [Int]$LogicModuleId

    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/setting/accessgroup/mapunmap/modules"

            $MappingDetailsArray = New-Object -TypeName System.Collections.ArrayList

            $MappingDetailsArray.Add([PSCustomObject]@{
                    moduletype   = $LogicModuleType
                    moduleid     = $LogicModuleId
                    accessgroups = $AccessGroupIds
                }) | Out-Null

            $Data = [PSCustomObject]@{
                mappingDetails = $MappingDetailsArray
            }

            $Data = ($Data | ConvertTo-Json -Depth 10)

            $Message = "LogicModuleType: $LogicModuleType | LogicModuleId: $LogicModuleId"

            if ($PSCmdlet.ShouldProcess($Message, "Create Access Group Mapping")) {
                try {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-LMRestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    if ($Response.failure) {
                        foreach ($Failure in $Response.failure) {
                            Write-Warning "$Failure"
                        }
                    }
                    if ($Response.success) {
                        foreach ($Success in $Response.success) {
                            Write-Information "[INFO]: Successfully mapped ($LogicModuleType/$LogicModuleId) to accessgroup(s): $($AccessGroupIds -join ',')"
                        }
                    }

                    return $Response.mappingDetails
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
    end {}
}
