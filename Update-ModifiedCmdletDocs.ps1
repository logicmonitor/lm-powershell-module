<#
.SYNOPSIS
Updates markdown documentation for modified PowerShell cmdlets based on git changes.

.DESCRIPTION
This script checks git status for modified .ps1 files in the Public directory and automatically
updates their corresponding markdown documentation files.

.PARAMETER Path
The base path to the repository. Defaults to current directory.

.PARAMETER DocumentationPath
Path to the documentation directory. Defaults to "./Documentation/"

.PARAMETER PublicPath
Path to the Public cmdlets directory. Defaults to "./Public/"

.PARAMETER IncludeStaged
Include staged files in addition to unstaged changes. Default is $true.

.EXAMPLE
.\Update-ModifiedCmdletDocs.ps1

.EXAMPLE
.\Update-ModifiedCmdletDocs.ps1 -Path "C:\Projects\Logic.Monitor"
#>

[CmdletBinding()]
param(
    [string]$Path = ".",
    [string]$DocumentationPath = "$PSScriptRoot\Documentation\",
    [string]$PublicPath = "$PSScriptRoot\Public\",
    [bool]$IncludeStaged = $true,
    [bool]$RecreateUpdatedDocs = $true
)

# Change to the repository directory
Push-Location $Path

try {
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
    Write-Host "Checking for modified PowerShell files..." -ForegroundColor Cyan
    
    # Get modified files from git (both staged and unstaged)
    $gitStatus = if ($IncludeStaged) {
        git status --porcelain
    } else {
        git status --porcelain | Where-Object { $_ -match '^\s*M' }
    }
    
    # Filter for .ps1 files in the Public directory
    $modifiedCmdlets = $gitStatus | Where-Object { 
        $_ -match "Public/.*\.ps1$" 
    } | ForEach-Object {
        # Extract filename without path and extension
        if ($_ -match "Public/([^/]+)\.ps1") {
            $matches[1]
        }
    } | Select-Object -Unique
    
    if (-not $modifiedCmdlets) {
        Write-Host "No modified cmdlet files found in git status." -ForegroundColor Yellow
        return
    }
    
    Write-Host "Found $($modifiedCmdlets.Count) modified cmdlet(s):" -ForegroundColor Green
    $modifiedCmdlets | ForEach-Object { Write-Host "  - $_" -ForegroundColor Gray }
    Write-Host ""
    
    # Update markdown documentation for each modified cmdlet
    $successCount = 0
    $failCount = 0
    $createCount = 0
    
    foreach ($cmdlet in $modifiedCmdlets) {
        $mdPath = Join-Path $DocumentationPath "$cmdlet.md"
        
        if (Test-Path $mdPath) {
            try {
                Write-Host "Updating $mdPath..." -ForegroundColor Cyan
                if ($RecreateUpdatedDocs) {
                    #Delete the existing documentation file
                    Remove-Item $mdPath -ErrorAction SilentlyContinue
                    #Create the new documentation file
                    New-MarkdownHelp -Command $cmdlet -OutputFolder $DocumentationPath -ErrorAction Stop | Out-Null
                } else {
                    Update-MarkdownHelp -Path $mdPath -Force -ErrorAction Stop | Out-Null
                }
                
                # Fix module name in the generated markdown file
                $content = Get-Content $mdPath -Raw
                $content = $content -replace "Module Name: $($devModule.BaseName)", "Module Name: $productionModuleName"
                Set-Content -Path $mdPath -Value $content -NoNewline
                
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
            Try {
                New-MarkdownHelp -Command $cmdlet -OutputFolder $DocumentationPath -ErrorAction Stop | Out-Null
                
                # Fix module name in the generated markdown file
                $content = Get-Content $mdPath -Raw
                $content = $content -replace "Module Name: $($devModule.BaseName)", "Module Name: $productionModuleName"
                Set-Content -Path $mdPath -Value $content -NoNewline
                    
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
    
    # Regenerate external help after all documentation updates
    if ($successCount -gt 0 -or $createCount -gt 0) {
        Write-Host ""
        Write-Host "Regenerating external help files..." -ForegroundColor Cyan
        try {
            $enUSPath = Join-Path $PSScriptRoot "en-US"
            New-ExternalHelp -OutputPath $enUSPath -Path $DocumentationPath -Force | Out-Null
            Write-Host "  ✓ Successfully regenerated external help in $enUSPath" -ForegroundColor Green
        }
        catch {
            Write-Host "  ✗ Failed to regenerate external help: $_" -ForegroundColor Red
        }
    }
}
catch {
    Write-Error "An error occurred: $_"
}
finally {
    Pop-Location
}