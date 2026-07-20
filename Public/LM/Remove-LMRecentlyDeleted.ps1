<#
.SYNOPSIS
Permanently removes one or more resources from the LogicMonitor recycle bin.

.DESCRIPTION
The Remove-LMRecentlyDeleted function submits a batch delete request for the provided recycle
identifiers, permanently removing the associated resources from the recycle bin.

.PARAMETER RecycleId
One or more recycle identifiers representing deleted resources. Accepts pipeline input and
property names of Id.

.EXAMPLE
Get-LMRecentlyDeleted -ResourceType deviceGroup -DeletedBy "lmsupport" | Select-Object -First 3 -ExpandProperty id | Remove-LMRecentlyDeleted

Permanently deletes the first three device groups currently in the recycle bin for the user lmsupport.

.NOTES
You must establish a session with Connect-LMAccount prior to calling this function.
#>
function Remove-LMRecentlyDeleted {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
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

        $resourcePath = '/recyclebin/recycles/batchdelete'
        $payload = ConvertTo-Json -InputObject $idBuffer.ToArray()
        $headers = New-LMHeader -Auth $Script:LMAuth -Method 'POST' -ResourcePath $resourcePath -Data $payload
        $uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $resourcePath

        Resolve-LMDebugInfo -Url $uri -Headers $headers[0] -Command $MyInvocation -Payload $payload

        $targetDescription = "RecycleId(s): $(($idBuffer.ToArray()) -join ', ')"

        if ($PSCmdlet.ShouldProcess($targetDescription, 'Permanently delete recently deleted resources')) {
            $response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $uri -Method 'POST' -Headers $headers[0] -WebSession $headers[1] -Body $payload

            if ($null -ne $response) {
                return (Add-ObjectTypeInfo -InputObject $response -TypeName 'LogicMonitor.RecentlyDeletedRemoveResult')
            }

            $summary = [PSCustomObject]@{
                recycleIds = $idBuffer.ToArray()
                message    = 'Permanent delete request submitted successfully.'
            }

            return (Add-ObjectTypeInfo -InputObject $summary -TypeName 'LogicMonitor.RecentlyDeletedRemoveResult')
        }
    }
}

