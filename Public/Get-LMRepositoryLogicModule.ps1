<#
.SYNOPSIS
Retrieves LogicModules from the LogicMonitor repository.

.DESCRIPTION
The Get-LMRepositoryLogicModule function retrieves LogicModules from the LogicMonitor repository. It supports retrieving different types of modules including datasources, property rules, event sources, topology sources, and config sources.

.PARAMETER Type
The type of LogicModule to retrieve. Valid values are "datasource", "propertyrules", "eventsource", "topologysource", "configsource". Defaults to "datasource".

.EXAMPLE
#Retrieve all datasource modules
Get-LMRepositoryLogicModule

.EXAMPLE
#Retrieve all event source modules
Get-LMRepositoryLogicModule -Type "eventsource"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.RepositoryLogicModules objects.
#>

function Get-LMRepositoryLogicModule {

    [CmdletBinding()]
    param (
        [ValidateSet("datasource", "propertyrules", "eventsource", "topologysource", "configsource")]
        [String]$Type = "datasource"

    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/setting/logicmodules/listcore"

        #Initalize vars
        $QueryParams = "?type=$Type"
        $Results = @()

        $Data = @{
            coreServer = "core.logicmonitor.com"
            password   = "logicmonitor"
            username   = "anonymouse"
        }

        $Data = ($Data | ConvertTo-Json)

        
        $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
        $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams

        Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

        #Issue request
        $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
        $Results = $Response.Items

        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.RepositoryLogicModules" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
