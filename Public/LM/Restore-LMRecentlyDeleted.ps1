<#
.SYNOPSIS
Restores one or more resources from the LogicMonitor recycle bin.

.DESCRIPTION
The Restore-LMRecentlyDeleted function issues a batch restore request for the provided recycle
identifiers, returning the selected resources to their original state when possible.

.PARAMETER RecycleId
One or more recycle identifiers representing deleted resources. Accepts pipeline input and
property names of Id.

.EXAMPLE
Get-LMRecentlyDeleted -ResourceType device -DeletedBy "lmsupport" | Select-Object -First 5 -ExpandProperty id | Restore-LMRecentlyDeleted

Restores the five most recently deleted devices by lmsupport.

.NOTES
You must establish a session with Connect-LMAccount prior to calling this function.
#>
function Restore-LMRecentlyDeleted {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [String[]]$RecycleId
    )

    begin {
        $idBuffer = New-Object System.Collections.Generic.List[string]
    }

    process {
        foreach ($id in $RecycleId) {
            if ([string]::IsNullOrWhiteSpace($id)) {
                continue
            }
            $idBuffer.Add($id)
        }
    }

    end {
        if (-not $Script:LMAuth.Valid) {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
            return
        }

        if ($idBuffer.Count -eq 0) {
            Write-Error "No recycle identifiers were supplied. Provide at least one identifier and try again."
            return
        }

        $resourcePath = '/recyclebin/recycles/batchrestore'
        $payload = ConvertTo-Json -InputObject $idBuffer.ToArray()
        $headers = New-LMHeader -Auth $Script:LMAuth -Method 'POST' -ResourcePath $resourcePath -Data $payload
        $uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $resourcePath

        Resolve-LMDebugInfo -Url $uri -Headers $headers[0] -Command $MyInvocation -Payload $payload

        $targetDescription = "RecycleId(s): $(($idBuffer.ToArray()) -join ', ')"

        if ($PSCmdlet.ShouldProcess($targetDescription, 'Restore recently deleted resources')) {
            $response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $uri -Method 'POST' -Headers $headers[0] -WebSession $headers[1] -Body $payload

            if ($null -ne $response) {
                return (Add-ObjectTypeInfo -InputObject $response -TypeName 'LogicMonitor.RecentlyDeletedRestoreResult')
            }

            $summary = [PSCustomObject]@{
                recycleIds = $idBuffer.ToArray()
                message    = 'Restore request submitted successfully.'
            }

            return (Add-ObjectTypeInfo -InputObject $summary -TypeName 'LogicMonitor.RecentlyDeletedRestoreResult')
        }
    }
}

