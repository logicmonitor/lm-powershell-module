<#
.SYNOPSIS
Creates a new LogicMonitor report group.

.DESCRIPTION
The New-LMReportGroup function creates a new report group in LogicMonitor. It requires the name of the report group as a mandatory parameter and an optional description.

.PARAMETER Name
The name of the report group. This parameter is mandatory.

.PARAMETER Description
The description of the report group. This parameter is optional.

.EXAMPLE
New-LMReportGroup -Name "MyReportGroup" -Description "This is a sample report group"

This example creates a new report group with the name "MyReportGroup" and the description "This is a sample report group".

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.ReportGroup object.
#>
function New-LMReportGroup {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (

        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description

    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Build custom props hashtable
            $customProperties = @()
            if ($Properties) {
                foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }

            #Build header and uri
            $ResourcePath = "/report/groups"

            $Data = @{
                description = $Description
                name        = $Name
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys @()

            $Message = "Name: $Name"

            if ($PSCmdlet.ShouldProcess($Message, "Create Report Group")) {
                

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.NetScanGroup" )

            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
