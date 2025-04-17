<#
.SYNOPSIS
Updates a LogicMonitor website monitoring configuration with improved parameter validation.

.DESCRIPTION
The Set-LMWebsite function modifies an existing website monitoring configuration in LogicMonitor.
It includes intelligent validation of test location parameters to ensure valid combinations are used.

.PARAMETER Id
Specifies the ID of the website to modify.

.PARAMETER Name
Specifies the name for the website.

.PARAMETER IsInternal
Indicates whether the website is internal.

.PARAMETER Description
Specifies the description for the website.

.PARAMETER DisableAlerting
Indicates whether to disable alerting for the website.

.PARAMETER StopMonitoring
Indicates whether to stop monitoring the website.

.PARAMETER UseDefaultAlertSetting
Indicates whether to use default alert settings.

.PARAMETER UseDefaultLocationSetting
Indicates whether to use default location settings.

.PARAMETER TriggerSSLStatusAlert
Indicates whether to trigger SSL status alerts.

.PARAMETER TriggerSSLExpirationAlert
Indicates whether to trigger SSL expiration alerts.

.PARAMETER GroupId
Specifies the group ID for the website.

.PARAMETER Properties
Specifies a hashtable of custom properties for the website.

.PARAMETER PropertiesMethod
Specifies how to handle properties. Valid values: "Add", "Replace", "Refresh".

.PARAMETER PollingInterval
Specifies the polling interval. Valid values: 1-10, 30, 60.

.PARAMETER TestLocationAll
Indicates whether to test from all locations. Cannot be used with TestLocationCollectorIds or TestLocationSmgIds.

.PARAMETER TestLocationCollectorIds
Array of collector IDs to use for testing. Can only be used when IsInternal is true. Cannot be used with TestLocationAll or TestLocationSmgIds.

.PARAMETER TestLocationSmgIds
Array of collector group IDs to use for testing. Can only be used when IsInternal is false. Cannot be used with TestLocationAll or TestLocationCollectorIds.
Available collector group IDs correspond to LogicMonitor regions:
- 2 = US - Washington DC
- 3 = Europe - Dublin
- 4 = US - Oregon
- 5 = Asia - Singapore
- 6 = Australia - Sydney

.EXAMPLE
Set-LMWebsite -Id 123 -Name "Updated Site" -Description "New description" -DisableAlerting $false
Updates the website with new name, description, and enables alerting.

.EXAMPLE
Set-LMWebsite -Id 123 -TestLocationAll $true
Updates the website to test from all locations.

.INPUTS
None.

.OUTPUTS
Returns a LogicMonitor.Website object containing the updated configuration.

.NOTES
This function requires a valid LogicMonitor API authentication.
It enforces strict validation rules for TestLocation parameters to prevent invalid combinations.
#>

Function Set-LMWebsite {

    [CmdletBinding(DefaultParameterSetName = "Website")]
    Param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [String]$Id,

        [String]$Name,

        [Nullable[boolean]]$IsInternal,

        [String]$Description,

        [Nullable[boolean]]$DisableAlerting,

        [Nullable[boolean]]$StopMonitoring,

        [Nullable[boolean]]$UseDefaultAlertSetting,

        [Nullable[boolean]]$UseDefaultLocationSetting,

        [Parameter(ParameterSetName = "Website")]
        [Nullable[boolean]]$TriggerSSLStatusAlert,
        
        [Parameter(ParameterSetName = "Website")]
        [Nullable[boolean]]$TriggerSSLExpirationAlert,

        [String]$GroupId,

        [Parameter(ParameterSetName = "Ping")]
        [String]$PingAddress,

        [Parameter(ParameterSetName = "Website")]
        [String]$WebsiteDomain,

        [ValidateSet("http", "https")]
        [Parameter(ParameterSetName = "Website")]
        [String]$HttpType,

        [Parameter(ParameterSetName = "Website")]
        [String[]]$SSLAlertThresholds,
        
        [Parameter(ParameterSetName = "Ping")]
        [ValidateSet(5, 10, 15, 20, 30, 60)]
        [Nullable[Int]]$PingCount,

        [Parameter(ParameterSetName = "Ping")]
        [Nullable[Int]]$PingTimeout,

        [Parameter(ParameterSetName = "Website")]
        [Nullable[Int]]$PageLoadAlertTimeInMS,

        [Parameter(ParameterSetName = "Ping")]
        [ValidateSet(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)]
        [Nullable[Int]]$PingPercentNotReceived,

        [ValidateSet(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 30, 60)]
        [Nullable[Int]]$FailedCount,

        [ValidateSet("warn", "error", "critical")]
        [String]$OverallAlertLevel,

        [ValidateSet("warn", "error", "critical")]
        [String]$IndividualAlertLevel,

        [Hashtable]$Properties,

        [ValidateSet("Add", "Replace", "Refresh")] # Add will append to existing prop, Replace will update existing props if specified and add new props, refresh will replace existing props with new
        [String]$PropertiesMethod = "Replace",

        [ValidateSet(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)]
        [Nullable[Int]]$PollingInterval,

        [Parameter(ParameterSetName = "Website")]
        [String[]]$WebsiteSteps,

        [Nullable[boolean]]$TestLocationAll, #Only valid for external checks

        [Int[]]$TestLocationCollectorIds,

        [Int[]]$TestLocationSmgIds
    )

    Begin {
        # Function to validate test location parameters
        Function ValidateTestLocationParameters {
            param (
                [Nullable[boolean]]$IsInternal,
                [Nullable[boolean]]$TestLocationAll,
                [Int[]]$TestLocationCollectorIds,
                [Int[]]$TestLocationSmgIds
            )

            $isValid = $true
            $errorMessage = ""

            # Check for mutually exclusive parameters
            if ($TestLocationSmgIds -and $IsInternal) {
                $errorMessage = "TestLocationSmgIds can only be used when IsInternal is false"
                $isValid = $false
            }
            elseif (!$IsInternal -and $TestLocationCollectorIds) {
                $errorMessage = "TestLocationCollectorIds can only be used when IsInternal is true"
                $isValid = $false
            }
            elseif ($TestLocationAll -and $TestLocationCollectorIds) {
                $errorMessage = "TestLocationAll cannot be used with TestLocationCollectorIds"
                $isValid = $false
            }
            elseif ($TestLocationAll -and $TestLocationSmgIds) {
                $errorMessage = "TestLocationAll cannot be used with TestLocationSmgIds"
                $isValid = $false
            }

            return @{
                IsValid = $isValid
                ErrorMessage = $errorMessage
            }
        }
    }
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Id by name
            If ($Name) {
                $LookupResult = (Get-LMWebsite -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            # Validate test location parameters
            $validationResult = ValidateTestLocationParameters -IsInternal $IsInternal -TestLocationAll $TestLocationAll -TestLocationCollectorIds $TestLocationCollectorIds -TestLocationSmgIds $TestLocationSmgIds
            if (-not $validationResult.IsValid) {
                Write-Error $validationResult.ErrorMessage
                return
            }

            #Build custom props hashtable
            $customProperties = @()
            If ($Properties) {
                Foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }
                    
            #Build header and uri
            $ResourcePath = "/website/websites/$Id"

            Try {
                $alertExpr = $null
                If ($SSLAlertThresholds) {
                    $alertExpr = "< " + $SSLAlertThresholds -join " "
                }

                # Build testLocation object based on which parameter is provided
                $testLocation = $null
                If ($TestLocationAll) {
                    $testLocation = @{ all = $true }
                }
                ElseIf ($TestLocationCollectorIds) {
                    $testLocation = @{ collectorIds = $TestLocationCollectorIds }
                }
                ElseIf ($TestLocationSmgIds) {
                    $testLocation = @{ smgIds = $TestLocationSmgIds }
                }

                $Data = @{
                    name                        = $Name
                    description                 = $Description
                    disableAlerting             = $DisableAlerting
                    isInternal                  = $IsInternal
                    properties                  = $customProperties
                    stopMonitoring              = $StopMonitoring
                    groupId                     = $GroupId
                    pollingInterval             = $PollingInterval
                    overallAlertLevel           = $OverallAlertLevel
                    individualAlertLevel        = $IndividualAlertLevel
                    useDefaultAlertSetting      = $UseDefaultAlertSetting
                    useDefaultLocationSetting   = $UseDefaultLocationSetting
                    host                        = $PingAddress
                    triggerSSLStatusAlert       = $TriggerSSLStatusAlert
                    triggerSSLExpirationAlert   = $TriggerSSLExpirationAlert
                    count                       = $PingCount
                    percentPktsNotReceiveInTime = $PingPercentNotReceived
                    timeoutInMSPktsNotReceive   = $PingTimeout
                    transition                  = $FailedCount
                    pageLoadAlertTimeInMS       = $PageLoadAlertTimeInMS
                    alertExpr                   = $alertExpr
                    schema                      = $HttpType
                    domain                      = $WebsiteDomain
                    steps                       = $WebsiteSteps
                    testLocation                = $testLocation
                }

            
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { If ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }
            
                $Data = ($Data | ConvertTo-Json -Depth 10)

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + "?opType=$($PropertiesMethod.ToLower())"

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Website" )
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
