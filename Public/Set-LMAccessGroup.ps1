<#
.SYNOPSIS
Sets the properties of a LogicMonitor access group.

.DESCRIPTION
The Set-LMAccessGroup function is used to set the properties of a LogicMonitor access group. It allows you to specify the access group either by its ID or by its name. You can set the new name, description, and tenant ID for the access group.

.PARAMETER Id
Specifies the ID of the access group. This parameter is used when you want to set the properties of the access group by its ID.

.PARAMETER Name
Specifies the name of the access group. This parameter is used when you want to set the properties of the access group by its name.

.PARAMETER NewName
Specifies the new name for the access group.

.PARAMETER Description
Specifies the new description for the access group.

.PARAMETER Tenant
Specifies the tenant ID for the access group.

.EXAMPLE
Set-LMAccessGroup -Id 123 -NewName "New Access Group" -Description "This is a new access group" -Tenant "abc123"
Sets the properties of the access group with ID 123. The new name is set to "New Access Group", the description is set to "This is a new access group", and the tenant ID is set to "abc123".

.EXAMPLE
Set-LMAccessGroup -Name "Old Access Group" -NewName "New Access Group" -Description "This is a new access group" -Tenant "abc123"
Sets the properties of the access group with name "Old Access Group". The new name is set to "New Access Group", the description is set to "This is a new access group", and the tenant ID is set to "abc123".

.NOTES
This function requires you to be logged in and have valid API credentials. Use the Connect-LMAccount function to log in before running this command.
#>
function Set-LMAccessGroup {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (

        [Parameter(ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [String]$NewName,

        [String]$Description,

        [String]$Tenant

    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            #Lookup Group Id
            if ($Name) {
                $LookupResult = (Get-LMAccessGroup -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name) | Description: $($PSItem.description)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name)"
            }
            else {
                $Message = "Id: $Id"
            }

            #Build header and uri
            $ResourcePath = "/setting/accessgroup/$Id"

            
            $Data = @{
                description = $Description
                name        = $NewName
                tenantId    = $Tenant
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                -ConditionalKeep @{ 'name' = 'NewName' }

            if ($PSCmdlet.ShouldProcess($Message, "Set AccessGroup")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.AccessGroup" )
            }

        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
