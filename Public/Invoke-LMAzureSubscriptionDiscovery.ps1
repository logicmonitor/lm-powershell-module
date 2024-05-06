<#
.SYNOPSIS
    Invokes the Azure subscription discovery process to return subscriptions for a specified client Id.

.DESCRIPTION
    The Invoke-LMAzureSubscriptionDiscovery function is used to discover Azure subscriptions by making API requests to the LogicMonitor platform.

.PARAMETER ClientId
    The client ID of the Azure Active Directory application.

.PARAMETER SecretKey
    The secret key of the Azure Active Directory application.

.PARAMETER TenantId
    The tenant ID of the Azure Active Directory application.

.PARAMETER IsChinaAccount
    Specifies whether the Azure account is a China account. Default value is $false.

.EXAMPLE
    Invoke-LMAzureSubscriptionDiscovery -ClientId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -SecretKey "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -TenantId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#>
Function Invoke-LMAzureSubscriptionDiscovery {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$ClientId,

        [Parameter(Mandatory)]
        [String]$SecretKey,

        [Parameter(Mandatory)]
        [String]$TenantId,

        [String]$IsChinaAccount = $false

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/azure/functions/discoverSubscriptions"

        #Loop through requests 
        $Done = $false
        While (!$Done) {
            Try {
                $Data = @{
                    clientId        = $ClientId
                    secretKey       = $SecretKey
                    tenantId        = $TenantId
                    isChinaAccount  = $IsChinaAccount

                }

                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }

                $Data = ($Data | ConvertTo-Json)

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return $Response.items
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}