<#
.SYNOPSIS
Creates a new LogicMonitor Netscan Group.

.DESCRIPTION
The New-LMNetscanGroup function creates a new Netscan Group in LogicMonitor. It allows you to specify a name and optional description for the group.

.PARAMETER Name
Specifies the name of the Netscan Group. This parameter is mandatory.

.PARAMETER Description
Specifies the description for the Netscan Group.

.EXAMPLE
New-LMNetscanGroup -Name "Group1" -Description "This is a sample group"
Creates a new Netscan Group with the name "Group1" and the description "This is a sample group".

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.NetScanGroup object.
#>
Function New-LMNetscanGroup {

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Build custom props hashtable
            $customProperties = @()
            If ($Properties) {
                Foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }
                    
            #Build header and uri
            $ResourcePath = "/setting/netscans/groups"

            Try {
                $Data = @{
                    description = $Description
                    name        = $Name
                }

            
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { If ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
            
                $Data = ($Data | ConvertTo-Json)
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.NetScanGroup" )
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
