<#
.SYNOPSIS
Invokes a NetScan task for a cloud device group.

.DESCRIPTION
The Invoke-LMCloudGroupNetScan function schedules a NetScan task for a specified cloud device group (AWS, Azure, or GCP) in LogicMonitor.

.PARAMETER Id
The ID of the cloud device group. Required for GroupId parameter set.

.PARAMETER Name
The name of the cloud device group. Required for GroupName parameter set.

.EXAMPLE
#Run NetScan on a cloud group by ID
Invoke-LMCloudGroupNetScan -Id "12345"

.EXAMPLE
#Run NetScan on a cloud group by name
Invoke-LMCloudGroupNetScan -Name "AWS-Production"

.NOTES
You must run Connect-LMAccount before running this command. The target group must be a cloud group (AWS, Azure, or GCP).

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a success message if the task is scheduled successfully.
#>
Function Invoke-LMCloudGroupNetScan {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'GroupId')]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'GroupName')]
        [String]$Name
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Lookup Id if supplying username
            If ($Name) {
                $GroupInfo = Get-LMDeviceGroup -Name $Name
                $LookupResult = $GroupInfo.Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    Return
                }
                $Id = $LookupResult
            }
            Else {
                $GroupInfo = Get-LMDeviceGroup -Id $Id
            }

            If ($GroupInfo.groupType -notlike "*AWS*" -and $GroupInfo.groupType -notlike "*Azure*" -and $GroupInfo.groupType -notlike "*GCP*") {
                Write-Error "Specified group: $($GroupInfo.Name) is not of type AWs/Azure/GCP. Please ensure the specified group is a Cloud group and try again."
            }
                
            #Build header and uri
            $ResourcePath = "/device/groups/$Id/scheduleNetscans"

            Try {
    
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
    
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                Return "Scheduled LMCloud NetScan task for NetScan id: $Id."
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
