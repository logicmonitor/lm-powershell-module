<#
.SYNOPSIS
Sends a push metric to LogicMonitor.

.DESCRIPTION
The Send-LMPushMetric function sends a push metric to LogicMonitor. It allows you to create a new resource or update an existing resource with the specified metric data.

.PARAMETER NewResourceHostName
Specifies the hostname of the new resource to be created. This parameter is required if you want to create a new resource.

.PARAMETER NewResourceDescription
Specifies the description of the new resource to be created. This parameter is required if you want to create a new resource.

.PARAMETER ResourceIds
Specifies the resource IDs to use for resource mapping. This parameter is mandatory.

.PARAMETER ResourceProperties
Specifies the properties of the resources to be updated. This parameter is optional.

.PARAMETER DatasourceId
Specifies the ID of the datasource. This parameter is required if the datasource name is not specified.

.PARAMETER DatasourceName
Specifies the name of the datasource. This parameter is required if the datasource ID is not specified.

.PARAMETER DatasourceDisplayName
Specifies the display name of the datasource. This parameter is optional and defaults to the datasource name if not specified.

.PARAMETER DatasourceGroup
Specifies the group of the datasource. This parameter is optional and defaults to "PushModules" if not specified.

.PARAMETER Instances
Specifies the instances of the resources to be updated. This parameter is mandatory and should contain results from the New-LMPushMetricInstance function.

.EXAMPLE
Send-LMPushMetric -NewResourceHostName "NewResource" -NewResourceDescription "New Resource Description" -ResourceIds @{"system.deviceId"="12345"} -ResourceProperties @{"Property1"="Value1"} -DatasourceId "123" -Instances $Instances
Creates a new resource and sends metric data for the specified instances.

.NOTES
This function requires a valid API authentication. Make sure you are logged in before running any commands using Connect-LMAccount.

#>
function Send-LMPushMetric {

    [CmdletBinding()]
    param (

        [Parameter(ParameterSetName = 'Create-DatasourceId')]
        [Parameter(ParameterSetName = 'Create-DatasourceName')]
        [String]$NewResourceHostName,

        [Parameter(ParameterSetName = 'Create-DatasourceId')]
        [Parameter(ParameterSetName = 'Create-DatasourceName')]
        [String]$NewResourceDescription,

        [Parameter(Mandatory)]
        [Hashtable]$ResourceIds,

        [Hashtable]$ResourceProperties,

        [Parameter(Mandatory, ParameterSetName = 'Create-DatasourceId')]
        [String]$DatasourceId, #Needed if Datasource name is not specified

        [Parameter(Mandatory, ParameterSetName = 'Create-DatasourceName')]
        [String]$DatasourceName,

        [String]$DatasourceDisplayName, #Optional defaults to datasourceName if not specified

        [String]$DatasourceGroup, #Optional defaults to PushModules

        [Parameter(Mandatory)]
        [System.Collections.Generic.List[object]]$Instances

    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            $QueryParams = $null
            if ($NewResourceHostName) {
                $QueryParams = "?create=true"
            }

            #Build header and uri
            $ResourcePath = "/metric/ingest"

            $Data = @{
                resourceName          = $NewResourceHostName
                resourceDescription   = $NewResourceDescription
                resourceIds           = $ResourceIds
                resourceProperties    = $ResourceProperties
                dataSourceId          = $DatasourceId
                dataSource            = ($DatasourceName -replace '[#\\;=]', '_')
                dataSourceDisplayName = ($DatasourceDisplayName -replace '[#\\;=]', '_')
                dataSourceGroup       = $DatasourceGroup
                instances             = $Instances

            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys @() `
                -AlwaysKeepKeys @('instances')

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/rest" + $ResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            return $Response
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
