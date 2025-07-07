<#
.SYNOPSIS
Creates a new LogicMonitor access group.

.DESCRIPTION
The New-LMAccessGroup function creates a new access group in LogicMonitor. Access groups control user permissions and access rights for managing modules in the LM exchange and module toolbox.

.PARAMETER Name
The name of the access group. This parameter is mandatory.

.PARAMETER Description
The description of the access group.

.PARAMETER Tenant
The ID of the tenant to which the access group belongs.

.EXAMPLE
#Create a new access group
New-LMAccessGroup -Name "Group1" -Description "Access group for administrators" -Tenant "12345"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.AccessGroup object.
#>
function New-LMAccessGroup {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (

        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [String]$Tenant

    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/setting/accessgroup/add"

            $Data = @{
                description = $Description
                name        = $Name
                tenantId    = $Tenant
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys @()

            $Message = "Name: $Name"

            if ($PSCmdlet.ShouldProcess($Message, "Create Access Group")) {
                try {

                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.AccessGroup" )
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
