Function Get-LMNormalizedProperties {

    [CmdletBinding()]
    Param ()

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            
            #Build header and uri
            $ResourcePath = "/normalizedProperties/filter"

            $Body = [PSCustomObject]@{
                meta = @{
                    filters = @{
                        filterType = "FILTER_CATEGORICAL_MODEL_TYPE"
                        normalizedProperties = @{
                            dynamic = @(
                                @{
                                    field = "alias"
                                    expressions = @(
                                        @{
                                            operator = "REGEX"
                                            value = ".*"
                                        }
                                    )
                                }
                            )
                        }
                    }
                    paging = @{
                        perPageCount = 100
                        pageOffsetCount = 0
                    }
                    sort = "alias, hostPropertyPriority"
                }
            } | ConvertTo-Json -Depth 10

            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Version 4
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
                
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body
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
