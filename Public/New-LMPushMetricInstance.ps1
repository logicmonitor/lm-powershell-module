<#
.SYNOPSIS
Creates a new instance of a LogicMonitor push metric.

.DESCRIPTION
The New-LMPushMetricInstance function is used to create a new instance of a LogicMonitor push metric. It adds the instance to the specified instances array and returns the updated array.

.PARAMETER InstancesArrary
The array of existing instances to which the new instance will be added.

.PARAMETER InstanceName
The name of the new instance.

.PARAMETER InstanceDisplayName
The display name of the new instance. If not specified, the InstanceName will be used as the display name.

.PARAMETER InstanceDescription
The description of the new instance.

.PARAMETER InstanceProperties
A hashtable containing additional properties for the new instance.

.PARAMETER Datapoints
The list of datapoints associated with the new instance. Datapoints should be the results of the New-LMPushMetricDataPoint function.

.EXAMPLE
$instances = New-LMPushMetricInstance -InstancesArrary $instances -InstanceName "Instance1" -InstanceDisplayName "Instance 1" -InstanceDescription "This is instance 1" -InstanceProperties @{Property1 = "Value1"; Property2 = "Value2"} -Datapoints $datapoints

This example creates a new instance with the specified parameters and adds it to the existing instances array.

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.Instance object.
#>
function New-LMPushMetricInstance {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (

        [System.Collections.Generic.List[object]]$InstancesArrary,

        [Parameter(Mandatory)]
        [String]$InstanceName,

        [String]$InstanceDisplayName,

        [String]$InstanceDescription,

        [Hashtable]$InstanceProperties,

        [Parameter(Mandatory)]
        [System.Collections.Generic.List[object]]$Datapoints
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {
        if (!$InstancesArrary) {
            $InstancesArrary = [System.Collections.Generic.List[object]]::New()
        }

        $Message = "InstanceName: $InstanceName"

        if ($PSCmdlet.ShouldProcess($Message, "Create Push Metric Instance")) {
            #Add new instance to new instances array
            $InstancesArrary.Add([PSCustomObject]@{
                    instanceName        = $InstanceName
                    instanceDisplayName = if ($InstanceDisplayName) { $InstanceDisplayName }else { $InstanceName }
                    instanceProperties  = $InstanceProperties
                    instanceDescription = $InstanceDescription
                    dataPoints          = $Datapoints
                })

            return $InstancesArrary
        }
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
