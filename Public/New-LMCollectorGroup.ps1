<#
.SYNOPSIS
Creates a new LogicMonitor collector group.

.DESCRIPTION
The New-LMCollectorGroup function creates a new collector group in LogicMonitor with specified configuration settings.

.PARAMETER Name
The name of the collector group. This parameter is mandatory.

.PARAMETER Description
The description of the collector group.

.PARAMETER Properties
A hashtable of custom properties for the collector group.

.PARAMETER AutoBalance
Specifies whether to enable auto-balancing for the collector group. Defaults to $false.

.PARAMETER AutoBalanceInstanceCountThreshold
The threshold for auto-balancing the collector group. Defaults to 10000.

.EXAMPLE
#Create a new collector group with properties
New-LMCollectorGroup -Name "MyCollectorGroup" -Description "Production collectors" -Properties @{"location"="datacenter1"}

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.CollectorGroup object.
#>
function New-LMCollectorGroup {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (

        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [Hashtable]$Properties,

        [Nullable[boolean]]$AutoBalance = $false,

        [Nullable[Int]]$AutoBalanceInstanceCountThreshold = 10000

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
            $ResourcePath = "/setting/collector/groups"

            $Data = @{
                description                       = $Description
                name                              = $Name
                autoBalance                       = $AutoBalance
                customProperties                  = $customProperties
                autoBalanceInstanceCountThreshold = $AutoBalanceInstanceCountThreshold
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys @()

            $Message = "Name: $Name"

            if ($PSCmdlet.ShouldProcess($Message, "Create Collector Group")) {
                

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.CollectorGroup" )

            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
