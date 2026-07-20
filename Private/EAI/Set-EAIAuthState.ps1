function Set-EAIAuthState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$EdwinOrg,

        [Parameter(Mandatory)]
        [String]$ClientId,

        [Parameter(Mandatory)]
        [SecureString]$ClientSecret,

        [ValidateSet('Basic', 'Cached')]
        [String]$Type = 'Basic',

        [Boolean]$Logging = $true
    )

    $Script:EAIAuth = [PSCustomObject]@{
        EdwinOrg     = $EdwinOrg
        ClientId     = $ClientId
        ClientSecret = $ClientSecret
        PortalUrl    = "https://$EdwinOrg.dexda.ai"
        Valid        = $true
        Type         = $Type
        Logging      = $Logging
    }
}

function Read-EAIAuthFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$AuthFilePath
    )

    if (-not (Test-Path -LiteralPath $AuthFilePath)) {
        throw "Unable to find Edwin auth config file at path: $AuthFilePath"
    }

    $content = Get-Content -LiteralPath $AuthFilePath -Raw
    $auth = @{
        edwin_org     = $null
        client_id     = $null
        client_secret = $null
    }

    foreach ($line in ($content -split "`n")) {
        $trimmed = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmed) -or $trimmed.StartsWith('#')) {
            continue
        }

        if ($trimmed -match '^(?<key>[^:]+):\s*(?<value>.*)$') {
            $key = $Matches['key'].Trim().ToLowerInvariant()
            $value = $Matches['value'].Trim().Trim('"').Trim("'")

            switch ($key) {
                'edwin_org' { $auth.edwin_org = $value }
                'dexda_org' { if (-not $auth.edwin_org) { $auth.edwin_org = $value } }
                'client_id' { $auth.client_id = $value }
                'client_secret' { $auth.client_secret = $value }
            }
        }
    }

    if ([string]::IsNullOrWhiteSpace($auth.edwin_org) -or
        [string]::IsNullOrWhiteSpace($auth.client_id) -or
        [string]::IsNullOrWhiteSpace($auth.client_secret)) {
        throw 'Auth config file is missing one or more required values: edwin_org, client_id, client_secret.'
    }

    return [PSCustomObject]$auth
}
