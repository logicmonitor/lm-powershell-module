function Test-CPAuth {
    [CmdletBinding()]
    param(
        [System.Management.Automation.PSCmdlet]$CallerPSCmdlet
    )

    if (-not $Script:CPAuth -or -not $Script:CPAuth.Valid) {
        $message = 'Please ensure you are connected to Catchpoint before running this command. Use Connect-CPAccount to connect and try again.'
        $errorRecord = [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new($message),
            'CP.NotConnected',
            [System.Management.Automation.ErrorCategory]::ConnectionError,
            $null
        )

        if ($CallerPSCmdlet) {
            $CallerPSCmdlet.WriteError($errorRecord)
        }
        else {
            $PSCmdlet.WriteError($errorRecord)
        }

        return $false
    }

    return $true
}
