<#
.SYNOPSIS
Updates a LogicMonitor report group configuration.

.DESCRIPTION
The Set-LMReportGroup function modifies an existing report group in LogicMonitor.

.PARAMETER Id
Specifies the ID of the report group to modify.

.PARAMETER Name
Specifies the current name of the report group.

.PARAMETER NewName
Specifies the new name for the report group.

.PARAMETER Description
Specifies the new description for the report group.

.EXAMPLE
Set-LMReportGroup -Id 123 -NewName "Updated Reports" -Description "New description"
Updates the report group with ID 123 with a new name and description.

.INPUTS
None.

.OUTPUTS
Returns a LogicMonitor.NetScanGroup object containing the updated group information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

function Set-LMReportGroup {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (

        [Parameter(ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [String]$NewName,

        [String]$Description

    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            #Lookup Group Id
            if ($Name) {
                $LookupResult = (Get-LMReportGroup -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/report/groups/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            else {
                $Message = "Id: $Id"
            }

            $Data = @{
                description = $Description
                name        = $NewName
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                -ConditionalKeep @{ 'name' = 'NewName' }

            if ($PSCmdlet.ShouldProcess($Message, "Set Report Group")) {
                
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.NetScanGroup" )

            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
