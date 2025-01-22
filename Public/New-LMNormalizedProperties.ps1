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
