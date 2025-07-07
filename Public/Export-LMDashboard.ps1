<#
.SYNOPSIS
Exports dashboards from LogicMonitor to a JSON file.

.DESCRIPTION
The Export-LMDashboard function exports dashboard information from LogicMonitor to a JSON file.

.PARAMETER Id
The ID of the dashboard to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER Name
The name of the dashboard to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER FilePath
The path to the output file.

.PARAMETER PassThru
Switch to return the dashboard export as a PSCustomObject.

.EXAMPLE
#Export a dashboard to a JSON file
Export-LMDashboard -Id 123 -FilePath "C:\temp"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.Dashboard objects.
#>
function Export-LMDashboard {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Switch]$PassThru,

        [String]$FilePath = (Get-Location).Path
    )

    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Lookup Id
        if ($Name) {
            $LookupResult = (Get-LMDashboard -Name $Name).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        #Build header and uri
        $ResourcePath = "/dashboard/dashboards/$Id"

        #Initalize vars
        $QueryParams = "?format=file&template=true"

        $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
        $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams

        Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

        #Issue request
        $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

        #Export to JSON
        $Response | ConvertTo-Json -Depth 10 | Out-File -FilePath "$FilePath\$($Response.Name).json"


        Write-Information "[INFO]: Dashboard ($($Response.Name)) exported to $FilePath$([IO.Path]::DirectorySeparatorChar)$($Response.Name).json"
        if ($PassThru) {
            return $Response
        }
        return
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
