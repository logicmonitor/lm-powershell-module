<#
.SYNOPSIS
    Creates normalized properties in LogicMonitor.

.DESCRIPTION
    The New-LMNormalizedProperties cmdlet creates normalized properties in LogicMonitor. Normalized properties allow you to map multiple host properties to a single alias that can be used across your environment.

.PARAMETER Alias
    The alias name for the normalized property.

.PARAMETER Properties
    An array of host property names to map to the alias.

.EXAMPLE
    PS C:\> New-LMNormalizedProperties -Alias "location" -Properties @("location", "snmp.sysLocation", "auto.meraki.location")
    Creates a normalized property with alias "location" mapped to multiple source properties.

.NOTES
    Requires valid LogicMonitor API credentials set via Connect-LMAccount.
    This cmdlet uses LogicMonitor API v4.
#>

Function New-LMNormalizedProperties {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Alias,
        [Parameter(Mandatory = $true)]
        [Array]$Properties
    )

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            
            #Build header and uri
            $ResourcePath = "/normalizedProperties/bulk"

            #Loop through each property and build the body
            $Body = [PSCustomObject]@{
                data = [PSCustomObject]@{
                    items = @()
                }
            }
            $Index = 1
            ForEach ($Property in $Properties) {
                $Body.data.items += [PSCustomObject]@{
                    alias = $Alias
                    hostProperty = $Property
                    hostPropertyPriority = $Index
                    model = "normalizedProperties"
                }
                $Index++
            }

            $Body = $Body | ConvertTo-Json -Depth 10

            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Version 4
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
                
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
            Return $Response
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
