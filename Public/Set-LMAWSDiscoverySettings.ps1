<#
.SYNOPSIS
Updates AWS Cloud discovery settings for specified AWS accounts in LogicMonitor.

.DESCRIPTION
The Set-LMAWSDiscoverySettings function modifies AWS Cloud discovery settings such as monitored regions, automatic deletion policies, and alerting preferences for AWS services within LogicMonitor. The function supports updating a single AWS account by AccountId or multiple accounts by importing AccountIds from a CSV file.

.PARAMETER AccountId
Specifies the LogicMonitor device group ID of the AWS account for which to update discovery settings. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the AWS account device group. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER ServiceName
Specifies the AWS service name (e.g., "EC2", "RDS", "Lambda") whose discovery settings are to be updated.

.PARAMETER Regions
Specifies an array of AWS regions (e.g., "us-east-1","us-east-2") to monitor for the specified service.

.PARAMETER CsvPath
Specifies the path to a CSV file containing multiple AWS AccountIds to update in bulk. The CSV must have an "AccountId" column. This parameter is part of the 'Csv' parameter set.

.PARAMETER AutoDelete
Specifies whether to enable automatic deletion of terminated AWS resources.

.PARAMETER DeleteDelayDays
Specifies the number of days to wait before automatically deleting terminated resources. Defaults to 7.

.PARAMETER DisableAlerting
Specifies whether to disable alerting automatically after resource termination.

.EXAMPLE
Set-LMAWSDiscoverySettings -AccountId 317 -ServiceName "EC2" -Regions "us-east-1","us-west-2"
Updates EC2 discovery settings for AWS account group ID 317 to monitor only us-east-1 and us-west-2 regions.

.EXAMPLE
Set-LMAWSDiscoverySettings -Name "Production AWS Account" -ServiceName "RDS" -Regions "us-east-1","us-east-2" -AutoDelete -DeleteDelayDays 10
Updates RDS discovery settings for the AWS account named "Production AWS Account" with automatic deletion enabled after 10 days.

.EXAMPLE
Set-LMAWSDiscoverySettings -CsvPath "C:\aws_accounts.csv" -ServiceName "EC2" -Regions "us-east-1","us-east-2"
Bulk updates EC2 discovery settings for multiple AWS accounts listed in the CSV file.

.EXAMPLE
Set-LMAWSDiscoverySettings -AccountId 317 -ServiceName "Lambda" -Regions "us-east-1" -AutoDelete -DeleteDelayDays 5 -DisableAlerting
Updates Lambda discovery settings with automatic deletion after 5 days and alerting disabled on termination.

.INPUTS
You can pipe objects containing AccountId properties to this function.

.OUTPUTS
Returns a LogicMonitor.DeviceGroup object containing the updated AWS account group information.

.NOTES
This function requires a valid LogicMonitor API authentication. Use Connect-LMAccount before running this command.
#>
function Set-LMAWSDiscoverySettings {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [Int]$AccountId,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'Csv')]
        [ValidateScript({ Test-Path $_ })]
        [String]$CsvPath,

        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [Parameter(Mandatory, ParameterSetName = 'Csv')]
        [String]$ServiceName,

        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [Parameter(Mandatory, ParameterSetName = 'Csv')]
        [String[]]$Regions,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [Parameter(ParameterSetName = 'Csv')]
        [Nullable[Boolean]]$AutoDelete,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [Parameter(ParameterSetName = 'Csv')]
        [ValidateRange(1, 365)]
        [Nullable[Int]]$DeleteDelayDays,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [Parameter(ParameterSetName = 'Csv')]
        [Nullable[Boolean]]$DisableAlerting
    )

    begin {}
    process {
        # Handle CSV bulk processing
        if ($PSCmdlet.ParameterSetName -eq 'Csv') {
            $csv = Import-Csv -Path $CsvPath
            $accountIds = $csv.AccountId | Where-Object { $_ } | Sort-Object -Unique
            
            if ($accountIds.Count -eq 0) {
                Write-Error "No valid AccountId values found in CSV file: $CsvPath"
                return
            }

            Write-Verbose "Processing $($accountIds.Count) AWS account(s) from CSV file"

            foreach ($id in $accountIds) {
                if ($id -notmatch '^\d+$') {
                    Write-Warning "Skipping invalid AccountId value: $id"
                    continue
                }

                $params = @{
                    AccountId   = [Int]$id
                    ServiceName = $ServiceName
                    Regions     = $Regions
                }
                
                if ($PSBoundParameters.ContainsKey('AutoDelete')) { $params['AutoDelete'] = $AutoDelete }
                if ($PSBoundParameters.ContainsKey('DeleteDelayDays')) { $params['DeleteDelayDays'] = $DeleteDelayDays }
                if ($PSBoundParameters.ContainsKey('DisableAlerting')) { $params['DisableAlerting'] = $DisableAlerting }

                try {
                    Set-LMAWSDiscoverySettings @params
                }
                catch {
                    Write-Warning "Failed to update account ID ${id}: $_"
                }
            }
            return
        }

        # Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            # Lookup AccountId by Name if needed
            if ($Name) {
                $LookupResult = (Get-LMDeviceGroup -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $AccountId = $LookupResult
            }

            # Build header and uri
            $ResourcePath = "/device/groups/$AccountId"

            if ($PSItem) {
                $Message = "Id: $AccountId | Name: $($PSItem.name) | Service: $ServiceName"
            }
            elseif ($Name) {
                $Message = "Id: $AccountId | Name: $Name | Service: $ServiceName"
            }
            else {
                $Message = "Id: $AccountId | Service: $ServiceName"
            }

            # Retrieve current AWS account group configuration
            try {
                Write-Verbose "Retrieving AWS account group configuration for ID $AccountId"
                
                $GetHeaders = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $GetUri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $GetUri -Headers $GetHeaders[0] -Command $MyInvocation

                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $GetUri -Method "GET" -Headers $GetHeaders[0] -WebSession $GetHeaders[1]

                if (-not $Response) {
                    Write-Error "Failed to retrieve AWS account group with ID $AccountId"
                    return
                }

                # Validate that this is an AWS account group
                if ($Response.groupType -notmatch '^AWS/') {
                    Write-Error "Device group ID $AccountId is not an AWS account group (Type: $($Response.groupType))"
                    return
                }

                # Validate service exists
                if (-not $Response.extra.services) {
                    Write-Error "No AWS services configuration found for account group ID $AccountId"
                    return
                }

                # Find the service (case-insensitive)
                $serviceKey = $Response.extra.services.PSObject.Properties.Name | 
                    Where-Object { $_.ToLower() -eq $ServiceName.ToLower() } | 
                    Select-Object -First 1

                if (-not $serviceKey) {
                    $availableServices = $Response.extra.services.PSObject.Properties.Name -join ', '
                    Write-Error "Service '$ServiceName' not found for account ID $AccountId. Available services: $availableServices"
                    return
                }

                Write-Verbose "Found service '$serviceKey' in AWS account group"

                # Get current service configuration
                $serviceConfig = $Response.extra.services.$serviceKey

                # Handle inheritance from default settings
                if ($serviceConfig.useDefault -eq $true) {
                    Write-Verbose "Service '$serviceKey' currently inherits from global settings. Switching to custom settings."
                    $serviceConfig.useDefault = $false
                }

                # Update service configuration with new values
                $serviceConfig.monitoringRegions = $Regions

                if ($PSBoundParameters.ContainsKey('AutoDelete')) {
                    $serviceConfig.isAutomaticDeletionEnabled = $AutoDelete
                }

                if ($PSBoundParameters.ContainsKey('DisableAlerting')) {
                    $serviceConfig.isAlertingAutomaticallyDisabledAfterTermination = $DisableAlerting
                }

                if ($PSBoundParameters.ContainsKey('DeleteDelayDays')) {
                    if (-not $serviceConfig.automaticallyDeleteTerminatedResourcesOffset) {
                        $serviceConfig | Add-Member -NotePropertyName 'automaticallyDeleteTerminatedResourcesOffset' -NotePropertyValue @{} -Force
                    }
                    $serviceConfig.automaticallyDeleteTerminatedResourcesOffset.units = "DAYS"
                    $serviceConfig.automaticallyDeleteTerminatedResourcesOffset.offset = $DeleteDelayDays
                }

                # Update the service in the response object
                $Response.extra.services.$serviceKey = $serviceConfig

                # Build the data payload for PATCH (send the entire extra object)
                $Data = @{
                    extra = $Response.extra
                } | ConvertTo-Json -Depth 10

                if ($PSCmdlet.ShouldProcess($Message, "Update AWS Discovery Settings")) {
                    
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    # Issue request using centralized method with retry logic
                    $PatchResponse = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    Write-Verbose "Successfully updated AWS discovery settings for service '$serviceKey' in account ID $AccountId"

                    return (Add-ObjectTypeInfo -InputObject $PatchResponse -TypeName "LogicMonitor.DeviceGroup")
                }
            }
            catch {
                $errorMessage = $_.Exception.Message

                # Handle known non-fatal API warnings
                if ($errorMessage -match "Permissions are insufficient|Please see https://www\.logicmonitor\.com/support/lm-cloud") {
                    Write-Warning "Non-fatal LogicMonitor API warning: $errorMessage"
                    Write-Verbose "Settings may have been partially applied. Verify configuration in LogicMonitor portal."
                    
                    # Still return the response if we have it
                    if ($PatchResponse) {
                        return (Add-ObjectTypeInfo -InputObject $PatchResponse -TypeName "LogicMonitor.DeviceGroup")
                    }
                    return
                }
                else {
                    # Re-throw for proper error handling
                    throw
                }
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}