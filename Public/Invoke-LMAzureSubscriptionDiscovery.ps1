<#
.SYNOPSIS
Discovers Azure subscriptions for a given tenant.

.DESCRIPTION
The Invoke-LMAzureSubscriptionDiscovery function discovers available Azure subscriptions for a specified Azure tenant using provided credentials.

.PARAMETER ClientId
The Azure Active Directory application client ID.

.PARAMETER SecretKey
The Azure Active Directory application secret key.

.PARAMETER TenantId
The Azure Active Directory tenant ID.

.PARAMETER IsChinaAccount
Indicates if this is an Azure China account. Defaults to $false.

.EXAMPLE
#Discover Azure subscriptions
Invoke-LMAzureSubscriptionDiscovery -ClientId "client-id" -SecretKey "secret-key" -TenantId "tenant-id"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a list of discovered Azure subscriptions.
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