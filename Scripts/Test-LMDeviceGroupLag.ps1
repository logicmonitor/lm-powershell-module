# Requires: Connect-LMAccount already run in this session

$suffix = [guid]::NewGuid().ToString('N').Substring(0, 8)
$groupName = "DeviceGroup.Index.Test.$suffix"

# Parent group id (root group in most portals)
$parentGroupId = 1

$maxAttempts = 1000
$delaySeconds = 10

Write-Host "Creating device group..."
$createStart = Get-Date
$newGroup = New-LMDeviceGroup `
    -Name $groupName `
    -Description "Device group index lag test $suffix" `
    -ParentGroupId $parentGroupId `
    -DisableAlerting $true `
    -AppliesTo "false()"
$createEnd = Get-Date

Write-Host ("Create finished at {0:u} | duration: {1:N3}s | id: {2}" -f $createEnd, ($createEnd - $createStart).TotalSeconds, $newGroup.Id)

$lookupStart = Get-Date
$found = $null

for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
    $attemptStart = Get-Date

    try {
        $result = @(Get-LMDeviceGroup -Name $groupName -ErrorAction Stop)
        $attemptEnd = Get-Date

        if ($result.Count -eq 1 -and $result[0].Id -eq $newGroup.Id) {
            $found = $result[0]
            Write-Host ("FOUND on attempt {0} at {1:u} | attempt: {2:N3}s | since create: {3:N3}s" -f `
                $attempt, $attemptEnd, ($attemptEnd - $attemptStart).TotalSeconds, ($attemptEnd - $createEnd).TotalSeconds)
            break
        }

        Write-Host ("Attempt {0} at {1:u} | returned {2} match(es) | attempt: {3:N3}s" -f `
            $attempt, $attemptEnd, $result.Count, ($attemptEnd - $attemptStart).TotalSeconds)
    }
    catch {
        $attemptEnd = Get-Date
        Write-Host ("Attempt {0} at {1:u} | error: {2} | attempt: {3:N3}s" -f `
            $attempt, $attemptEnd, $_.Exception.Message, ($attemptEnd - $attemptStart).TotalSeconds)
    }

    if ($attempt -lt $maxAttempts) {
        Start-Sleep -Seconds $delaySeconds
    }
}

$lookupEnd = Get-Date

Write-Host ""
Write-Host "Summary"
Write-Host "-------"
Write-Host "Name:        $groupName"
Write-Host "Id:          $($newGroup.Id)"
Write-Host "Created:     $($createEnd.ToString('u'))"
Write-Host "Create time: $(($createEnd - $createStart).TotalSeconds.ToString('N3'))s"

if ($found) {
    Write-Host "Indexed:     $($lookupEnd.ToString('u'))"
    Write-Host "Index delay: $(($lookupEnd - $createEnd).TotalSeconds.ToString('N3'))s"
    Write-Host "Total time:  $(($lookupEnd - $createStart).TotalSeconds.ToString('N3'))s"
}
else {
    Write-Host "NOT FOUND after $maxAttempts attempts over $(($lookupEnd - $createEnd).TotalSeconds.ToString('N3'))s"
}

# Optional cleanup
Remove-LMDeviceGroup -Id $newGroup.Id -HardDelete $true -Confirm:$false
