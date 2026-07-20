function Test-EAIAuth {
    [CmdletBinding()]
    param(
        [System.Management.Automation.PSCmdlet]$CallerPSCmdlet
    )

    if (-not $Script:EAIAuth -or -not $Script:EAIAuth.Valid) {
        $message = 'Please ensure you are connected to Edwin before running this command. Use Connect-EAIAccount to connect and try again.'
        if ($CallerPSCmdlet) {
            $CallerPSCmdlet.WriteError($message)
        }
        else {
            Write-Error $message
        }
        return $false
    }

    return $true
}
