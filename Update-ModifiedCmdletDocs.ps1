<#
.SYNOPSIS
Updates markdown documentation for modified PowerShell cmdlets based on git changes.

.DESCRIPTION
By default, this script finds Public cmdlet files changed in local commits that have not
been pushed to the upstream tracking branch, then updates their markdown documentation.

Use -ChangeSource WorkingTree to instead process staged and/or unstaged working tree changes.

Use -AllPublicCmdlets to regenerate documentation for every Public/*.ps1 cmdlet file.
Use -CmdletName to regenerate one or more cmdlets by name.

.PARAMETER Path
The base path to the repository. Defaults to current directory.

.PARAMETER DocumentationPath
Path to the documentation directory. Defaults to "./Documentation/"

.PARAMETER PublicPath
Path to the Public cmdlets directory. Defaults to "./Public/"

.PARAMETER ChangeSource
Unpushed uses commits on HEAD that are not on the upstream branch. WorkingTree uses git status.

.PARAMETER IncludeStaged
When ChangeSource is WorkingTree, include staged files in addition to unstaged changes.

.PARAMETER RecreateUpdatedDocs
When true, existing markdown files are deleted and regenerated. When false, existing files are updated in place.

.PARAMETER RepairAllDocumentation
When true, repairs PlatyPS placeholder text in all markdown files under DocumentationPath and regenerates external help.

.PARAMETER AllPublicCmdlets
When true, regenerates documentation for all Public/*.ps1 files under PublicPath, ignoring git changes.

.PARAMETER CmdletName
One or more cmdlet names to regenerate regardless of git changes.

.EXAMPLE
.\Update-ModifiedCmdletDocs.ps1

.EXAMPLE
.\Update-ModifiedCmdletDocs.ps1 -ChangeSource WorkingTree

.EXAMPLE
.\Update-ModifiedCmdletDocs.ps1 -AllPublicCmdlets

.EXAMPLE
.\Update-ModifiedCmdletDocs.ps1 -CmdletName Get-LMSDT,Get-LMCollectorEvent

.EXAMPLE
.\Update-ModifiedCmdletDocs.ps1 -RepairAllDocumentation
#>

[CmdletBinding()]
param(
    [string]$Path = ".",
    [string]$DocumentationPath = "$PSScriptRoot\Documentation\",
    [string]$PublicPath = "$PSScriptRoot\Public\",
    [ValidateSet('Unpushed', 'WorkingTree')]
    [string]$ChangeSource = 'Unpushed',
    [bool]$IncludeStaged = $true,
    [bool]$RecreateUpdatedDocs = $true,
    [bool]$RepairAllDocumentation = $false,
    [switch]$AllPublicCmdlets,
    [string[]]$CmdletName
)

function Get-UnpushedGitRange {
    git rev-parse --abbrev-ref '@{u}' 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) {
        return '@{u}..HEAD'
    }

    $defaultRemoteBranch = git symbolic-ref refs/remotes/origin/HEAD 2>$null
    if ($defaultRemoteBranch -match 'origin/(.+)$') {
        return "origin/$($Matches[1])..HEAD"
    }

    return 'origin/main..HEAD'
}

function Get-WorkingTreeChangedPaths {
    param(
        [bool]$IncludeStaged = $true
    )

    $paths = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)

    foreach ($path in @(git diff --name-only)) {
        if ($path) {
            [void]$paths.Add($path)
        }
    }

    if ($IncludeStaged) {
        foreach ($path in @(git diff --cached --name-only)) {
            if ($path) {
                [void]$paths.Add($path)
            }
        }

        foreach ($path in @(git ls-files --others --exclude-standard)) {
            if ($path) {
                [void]$paths.Add($path)
            }
        }
    }

    return @($paths)
}

function Get-ModifiedPublicCmdletsFromGitPaths {
    param(
        [string[]]$ChangedPaths = @()
    )

    if (-not $ChangedPaths -or $ChangedPaths.Count -eq 0) {
        return @()
    }

    return $ChangedPaths | Where-Object {
        $_ -replace '\\', '/' -match '^Public/.+\.ps1$'
    } | ForEach-Object {
        $normalizedPath = $_ -replace '\\', '/'
        if ($normalizedPath -match 'Public/(?:.+/)*([^/]+)\.ps1$') {
            $Matches[1]
        }
    } | Select-Object -Unique
}

function Get-PublicCmdletNamesFromPath {
    param(
        [Parameter(Mandatory)]
        [string]$PublicPath
    )

    $resolvedPublicPath = Resolve-Path -Path $PublicPath -ErrorAction Stop

    return @(Get-ChildItem -Path $resolvedPublicPath -Filter '*.ps1' -Recurse -File | ForEach-Object {
        [IO.Path]::GetFileNameWithoutExtension($_.Name)
    } | Sort-Object -Unique)
}

function Get-CmdletsToDocument {
    param(
        [string]$PublicPath,
        [ValidateSet('Unpushed', 'WorkingTree')]
        [string]$ChangeSource,
        [bool]$IncludeStaged,
        [switch]$AllPublicCmdlets,
        [string[]]$CmdletName
    )

    if ($CmdletName) {
        return @($CmdletName | Sort-Object -Unique)
    }

    if ($AllPublicCmdlets) {
        $publicCmdlets = Get-PublicCmdletNamesFromPath -PublicPath $PublicPath
        return @($publicCmdlets | Where-Object { Get-Command $_ -ErrorAction SilentlyContinue })
    }

    if ($ChangeSource -eq 'Unpushed') {
        $gitRange = Get-UnpushedGitRange
        Write-Host "Checking for cmdlet changes in unpushed commits ($gitRange)..." -ForegroundColor Cyan

        $changedPaths = @(git diff --name-only $gitRange)
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to list changed files for git range '$gitRange'."
        }

        $script:noChangesMessage = "No modified cmdlet files found in unpushed commits."
    }
    else {
        Write-Host "Checking for modified PowerShell files in working tree..." -ForegroundColor Cyan

        $changedPaths = @(Get-WorkingTreeChangedPaths -IncludeStaged $IncludeStaged)

        $script:noChangesMessage = "No modified cmdlet files found in git status."
    }

    if (-not $changedPaths -or $changedPaths.Count -eq 0) {
        return @()
    }

    return @(Get-ModifiedPublicCmdletsFromGitPaths -ChangedPaths $changedPaths)
}

function Update-CmdletDocumentationFiles {
    param(
        [Parameter(Mandatory)]
        [string[]]$Cmdlets,

        [Parameter(Mandatory)]
        [string]$DocumentationPath,

        [Parameter(Mandatory)]
        [string]$DevModuleName,

        [Parameter(Mandatory)]
        [string]$ProductionModuleName,

        [Parameter(Mandatory)]
        [string]$RepositoryRoot,

        [bool]$RecreateUpdatedDocs = $true
    )

    $successCount = 0
    $failCount = 0
    $createCount = 0

    foreach ($cmdlet in $Cmdlets) {
        $mdPath = Join-Path $DocumentationPath "$cmdlet.md"

        if (Test-Path $mdPath) {
            try {
                Write-Host "Updating $mdPath..." -ForegroundColor Cyan
                if ($RecreateUpdatedDocs) {
                    Remove-Item $mdPath -ErrorAction SilentlyContinue
                    New-FlatMarkdownCommandHelp -CommandName $cmdlet -OutputFolder $DocumentationPath -TargetPath $mdPath
                }
                else {
                    Update-FlatMarkdownCommandHelp -MarkdownPath $mdPath
                }

                Set-FlatMarkdownModuleMetadata -MarkdownPath $mdPath -DevModuleName $DevModuleName -ProductionModuleName $ProductionModuleName
                Repair-PlatyPSMarkdownPlaceholders -MarkdownPath $mdPath

                Write-Host "  ✓ Successfully updated $cmdlet.md" -ForegroundColor Green
                $successCount++
            }
            catch {
                Write-Host "  ✗ Failed to update $cmdlet.md: $_" -ForegroundColor Red
                $failCount++
            }
        }
        else {
            Write-Host "Creating $mdPath..." -ForegroundColor Cyan
            try {
                New-FlatMarkdownCommandHelp -CommandName $cmdlet -OutputFolder $DocumentationPath -TargetPath $mdPath

                Set-FlatMarkdownModuleMetadata -MarkdownPath $mdPath -DevModuleName $DevModuleName -ProductionModuleName $ProductionModuleName
                Repair-PlatyPSMarkdownPlaceholders -MarkdownPath $mdPath

                Write-Host "  ✓ Successfully created $cmdlet.md" -ForegroundColor Green
                $createCount++
            }
            catch {
                Write-Host "  ✗ Failed to create $cmdlet.md: $_" -ForegroundColor Red
                $failCount++
            }
        }
    }

    Write-Host ""
    Write-Host "Summary:" -ForegroundColor Cyan
    Write-Host "  Updated: $successCount" -ForegroundColor Green
    Write-Host "  Created: $createCount" -ForegroundColor Green
    if ($failCount -gt 0) {
        Write-Host "  Failed/Missing: $failCount" -ForegroundColor Yellow
    }

    if ($successCount -gt 0 -or $createCount -gt 0) {
        Write-Host ""
        Write-Host "Regenerating external help files..." -ForegroundColor Cyan
        try {
            $enUSPath = Join-Path $RepositoryRoot "en-US"
            Export-FlatExternalHelp -DocumentationPath $DocumentationPath -OutputPath $enUSPath -ProductionModuleName $ProductionModuleName
            Write-Host "  ✓ Successfully regenerated external help in $enUSPath" -ForegroundColor Green
        }
        catch {
            Write-Host "  ✗ Failed to regenerate external help: $_" -ForegroundColor Red
        }
    }
}

function Test-PlatyPSV1 {
    return $null -ne (Get-Command New-MarkdownCommandHelp -ErrorAction SilentlyContinue)
}

function New-FlatMarkdownCommandHelp {
    param(
        [Parameter(Mandatory)]
        [string]$CommandName,

        [Parameter(Mandatory)]
        [string]$OutputFolder,

        [Parameter(Mandatory)]
        [string]$TargetPath
    )

    if (Test-PlatyPSV1) {
        $commandInfo = Get-Command $CommandName -ErrorAction Stop
        New-MarkdownCommandHelp -CommandInfo $commandInfo -OutputFolder $OutputFolder -Force -ErrorAction Stop | Out-Null

        $moduleMarkdownPath = Join-Path $OutputFolder $commandInfo.Module.Name "$CommandName.md"
        if (-not (Test-Path $moduleMarkdownPath)) {
            throw "Expected markdown file was not created at '$moduleMarkdownPath'."
        }

        Move-Item -Path $moduleMarkdownPath -Destination $TargetPath -Force

        $moduleFolder = Join-Path $OutputFolder $commandInfo.Module.Name
        if (Test-Path $moduleFolder) {
            $remainingItems = @(Get-ChildItem -Path $moduleFolder -Force -ErrorAction SilentlyContinue)
            if ($remainingItems.Count -eq 0) {
                Remove-Item -Path $moduleFolder -Force -ErrorAction SilentlyContinue
            }
        }

        return
    }

    if (Get-Command New-MarkdownHelp -ErrorAction SilentlyContinue) {
        New-MarkdownHelp -Command $CommandName -OutputFolder $OutputFolder -ErrorAction Stop | Out-Null
        return
    }

    throw "PlatyPS is not installed. Install Microsoft.PowerShell.PlatyPS (recommended) or legacy platyPS."
}

function Update-FlatMarkdownCommandHelp {
    param(
        [Parameter(Mandatory)]
        [string]$MarkdownPath
    )

    if (Test-PlatyPSV1) {
        Update-MarkdownCommandHelp -Path $MarkdownPath -NoBackup -ErrorAction Stop | Out-Null
        return
    }

    if (Get-Command Update-MarkdownHelp -ErrorAction SilentlyContinue) {
        Update-MarkdownHelp -Path $MarkdownPath -Force -ErrorAction Stop | Out-Null
        return
    }

    throw "PlatyPS is not installed. Install Microsoft.PowerShell.PlatyPS (recommended) or legacy platyPS."
}

function Set-FlatMarkdownModuleMetadata {
    param(
        [Parameter(Mandatory)]
        [string]$MarkdownPath,

        [Parameter(Mandatory)]
        [string]$DevModuleName,

        [Parameter(Mandatory)]
        [string]$ProductionModuleName
    )

    $helpFileName = "$ProductionModuleName-help.xml"
    $content = Get-Content $MarkdownPath -Raw
    $content = $content -replace '(?m)^external help file:.*$', "external help file: $helpFileName"
    $content = $content -replace "Module Name: $DevModuleName", "Module Name: $ProductionModuleName"
    Set-Content -Path $MarkdownPath -Value $content -NoNewline
}

function Repair-PlatyPSMarkdownPlaceholders {
    param(
        [Parameter(Mandatory)]
        [string]$MarkdownPath
    )

    $content = Get-Content $MarkdownPath -Raw

    # PlatyPS 1.0 boilerplate sections with no module content.
    $content = $content -replace '(?ms)^## ALIASES\r?\n\r?\nThis cmdlet has the following aliases,\r?\n  \{\{Insert list of aliases\}\}\r?\n\r?\n',''

    # Remove any standalone PlatyPS placeholder line.
    $content = $content -replace '(?m)^[ \t]*\{\{[^}\r\n]+\}\}\s*(?:\r?\n|$)', ''

    # Drop bare type headings left behind when PlatyPS invents pipeline input types.
    $content = $content -replace '(?ms)(?<=## INPUTS\r?\n\r?\n)^### (?:None\.|System\.[A-Za-z0-9_.\[\]]+)\r?\n\r?\n(?=### |## )',''

    # Normalize excessive blank lines introduced by removals.
    $content = $content -replace '(\r?\n){3,}', "`r`n`r`n"

    Set-Content -Path $MarkdownPath -Value $content -NoNewline
}

function Export-FlatExternalHelp {
    param(
        [Parameter(Mandatory)]
        [string]$DocumentationPath,

        [Parameter(Mandatory)]
        [string]$OutputPath,

        [Parameter(Mandatory)]
        [string]$ProductionModuleName
    )

    $helpFileName = "$ProductionModuleName-help.xml"
    $targetHelpPath = Join-Path $OutputPath $helpFileName

    if (Test-PlatyPSV1) {
        $markdownFiles = @(Measure-PlatyPSMarkdown -Path (Join-Path $DocumentationPath '*.md') -ErrorAction Stop)
        $commandMarkdownFiles = @($markdownFiles | Where-Object { $_.Filetype -match 'CommandHelp' })

        if ($commandMarkdownFiles.Count -eq 0) {
            throw "No command help markdown files found in '$DocumentationPath'."
        }

        $tempOutputPath = Join-Path ([System.IO.Path]::GetTempPath()) ("platyps-maml-$([Guid]::NewGuid().ToString())")
        New-Item -ItemType Directory -Path $tempOutputPath -Force | Out-Null

        try {
            $commandHelp = @(
                $commandMarkdownFiles |
                    Import-MarkdownCommandHelp -Path { $_.FilePath } |
                    ForEach-Object {
                        $_.ExternalHelpFile = $helpFileName
                        $_.ModuleName = $ProductionModuleName
                        $_
                    }
            )

            $commandHelp |
                Export-MamlCommandHelp -OutputFolder $tempOutputPath -Force -ErrorAction Stop | Out-Null

            $generatedHelpFiles = @(
                Get-ChildItem -Path $tempOutputPath -Recurse -Filter '*-help.xml' -File -ErrorAction SilentlyContinue
            )

            if ($generatedHelpFiles.Count -eq 0) {
                throw "No MAML help files were generated."
            }

            $mergedHelpFile = $generatedHelpFiles |
                Where-Object { $_.Name -ieq $helpFileName } |
                Sort-Object Length -Descending |
                Select-Object -First 1

            if (-not $mergedHelpFile) {
                throw "Expected MAML file '$helpFileName' was not generated."
            }

            New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
            Move-Item -Path $mergedHelpFile.FullName -Destination $targetHelpPath -Force
        }
        finally {
            Remove-Item -Path $tempOutputPath -Recurse -Force -ErrorAction SilentlyContinue
            Get-ChildItem -Path $OutputPath -Directory -ErrorAction SilentlyContinue |
                Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        }

        return
    }

    if (Get-Command New-ExternalHelp -ErrorAction SilentlyContinue) {
        New-ExternalHelp -OutputPath $OutputPath -Path $DocumentationPath -Force -ErrorAction Stop | Out-Null
        return
    }

    throw "PlatyPS is not installed. Install Microsoft.PowerShell.PlatyPS (recommended) or legacy platyPS."
}

# Change to the repository directory
Push-Location $Path

try {
    if (-not (Get-Module Microsoft.PowerShell.PlatyPS -ListAvailable) -and -not (Get-Module PlatyPS -ListAvailable)) {
        throw "PlatyPS is not installed. Install Microsoft.PowerShell.PlatyPS with: Install-Module Microsoft.PowerShell.PlatyPS"
    }

    if (Get-Module Microsoft.PowerShell.PlatyPS -ListAvailable) {
        Import-Module Microsoft.PowerShell.PlatyPS -ErrorAction Stop
        Write-Host "Using Microsoft.PowerShell.PlatyPS $((Get-Module Microsoft.PowerShell.PlatyPS).Version)" -ForegroundColor Gray
    }
    else {
        Import-Module PlatyPS -ErrorAction Stop
        Write-Host "Using legacy platyPS $((Get-Module PlatyPS).Version)" -ForegroundColor Yellow
    }

    # Dynamically find the Dev module file (Dev.*.psd1)
    $devModule = Get-ChildItem -Path $PSScriptRoot -Filter "Dev.*.psd1" -File | Select-Object -First 1
    
    if (-not $devModule) {
        throw "No Dev module file (Dev.*.psd1) found in $PSScriptRoot"
    }
    
    Write-Host "Loading module: $($devModule.Name)" -ForegroundColor Cyan
    Import-Module $devModule.FullName -Force
    
    # Extract the production module name (remove "Dev." prefix)
    $productionModuleName = $devModule.BaseName -replace '^Dev\.', ''
    Write-Host "Production module name: $productionModuleName" -ForegroundColor Gray
}
catch {
    Write-Error "Failed to load Dev module: $_"
    Pop-Location
    return
}

try {
    if ($RepairAllDocumentation) {
        Write-Host "Repairing PlatyPS placeholders in all documentation files..." -ForegroundColor Cyan

        $documentationFiles = @(Get-ChildItem -Path $DocumentationPath -Filter '*.md' -File -ErrorAction Stop)
        foreach ($documentationFile in $documentationFiles) {
            Repair-PlatyPSMarkdownPlaceholders -MarkdownPath $documentationFile.FullName
        }

        Write-Host "  ✓ Repaired $($documentationFiles.Count) documentation file(s)" -ForegroundColor Green

        Write-Host ""
        Write-Host "Regenerating external help files..." -ForegroundColor Cyan
        $enUSPath = Join-Path $PSScriptRoot "en-US"
        Export-FlatExternalHelp -DocumentationPath $DocumentationPath -OutputPath $enUSPath -ProductionModuleName $productionModuleName
        Write-Host "  ✓ Successfully regenerated external help in $enUSPath" -ForegroundColor Green
        return
    }

    if ($AllPublicCmdlets) {
        Write-Host "Generating documentation for all Public cmdlets under $PublicPath..." -ForegroundColor Cyan
    }

    $script:noChangesMessage = "No modified cmdlet files found."
    $modifiedCmdlets = @(Get-CmdletsToDocument -PublicPath $PublicPath -ChangeSource $ChangeSource -IncludeStaged $IncludeStaged -AllPublicCmdlets:$AllPublicCmdlets -CmdletName $CmdletName)

    if (-not $modifiedCmdlets -or $modifiedCmdlets.Count -eq 0) {
        Write-Host $script:noChangesMessage -ForegroundColor Yellow
        return
    }

    Write-Host "Found $($modifiedCmdlets.Count) cmdlet(s) to document:" -ForegroundColor Green
    $modifiedCmdlets | ForEach-Object { Write-Host "  - $_" -ForegroundColor Gray }
    Write-Host ""

    Update-CmdletDocumentationFiles -Cmdlets $modifiedCmdlets -DocumentationPath $DocumentationPath -DevModuleName $devModule.BaseName -ProductionModuleName $productionModuleName -RepositoryRoot $PSScriptRoot -RecreateUpdatedDocs $RecreateUpdatedDocs
}
catch {
    Write-Error "An error occurred: $_"
}
finally {
    Pop-Location
}