# Requires: Connect-LMAccount already run in this session

$suffix = [guid]::NewGuid().ToString('N').Substring(0, 8)
$deviceName = "device-index-test-$suffix.example.com"
$displayName = "Device.Index.Test.$suffix"

# Use your collector id (or pull from env / a known test collector)
$collectorId = 76   # change if needed

$maxAttempts = 1000
$delaySeconds = 10

Write-Host "Creating device..."
$createStart = Get-Date
$newDevice = New-LMDevice `
    -Name $deviceName `
    -DisplayName $displayName `
    -PreferredCollectorId $collectorId `
    -DisableAlerting $true
$createEnd = Get-Date

Write-Host ("Create finished at {0:u} | duration: {1:N3}s | id: {2}" -f $createEnd, ($createEnd - $createStart).TotalSeconds, $newDevice.Id)

$lookupStart = Get-Date
$found = $null

for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
    $attemptStart = Get-Date

    try {
        $result = @(Get-LMDevice -Name $deviceName -ErrorAction Stop)
        $attemptEnd = Get-Date

        if ($result.Count -eq 1 -and $result[0].Id -eq $newDevice.Id) {
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
Write-Host "Name:        $deviceName"
Write-Host "Id:          $($newDevice.Id)"
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
Remove-LMDevice -Id $newDevice.Id -HardDelete $true -Confirm:$false