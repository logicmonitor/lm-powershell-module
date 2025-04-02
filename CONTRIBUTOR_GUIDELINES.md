# Contributor Guidelines for Community PowerShell Module

Thank you for your interest in contributing to our PowerShell module! This document provides guidelines to ensure consistency and quality across all contributions.

## Table of Contents
- [Getting Started](#getting-started)
- [Development Environment Setup](#development-environment-setup)
- [Coding Standards](#coding-standards)
- [Documentation Requirements](#documentation-requirements)
- [Testing Guidelines](#testing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)
- [Community Expectations](#community-expectations)

## Getting Started

1. **Fork the repository** to your GitHub account
2. **Clone your fork** to your local development environment
3. **Create a new branch** for your contribution (use a descriptive name related to your change)
4. Make your changes following our guidelines below
5. Submit a pull request back to the main repository

## Development Environment Setup

### Required Tools
- PowerShell 5.1 or PowerShell Core 7.x
- VS Code with PowerShell extension (recommended)
- Pester 5.x for testing
- PSScriptAnalyzer for linting

### Initial Setup
```powershell
# Install required modules if you don't have them
Install-Module -Name Pester -MinimumVersion 5.0.0 -Force
Install-Module -Name PSScriptAnalyzer -Force

# Clone the repository
git clone https://github.com/YOUR-USERNAME/powershell-module.git
cd powershell-module

# Set up pre-commit hooks (optional but recommended)
./scripts/setup-dev-environment.ps1
```

## Coding Standards

### Naming Conventions
- Use **PascalCase** for function names, parameter names, and variable names
- Use **Approved Verbs** for functions (use `Get-Verb` to see the list)
- Use singular nouns for cmdlet names (e.g., `Get-User` not `Get-Users`)
- Use descriptive names that clearly indicate purpose

### Code Structure
- Each function should be in its own file named after the function
- Group related functions in appropriately named subdirectories
- Use the standard PowerShell module structure
- Place internal/helper functions in a `Private` directory

### Style Guidelines
- Use 4 spaces for indentation (not tabs)
- Follow [PowerShell Best Practices](https://github.com/PoshCode/PowerShellPracticeAndStyle)
- Limit line length to 100 characters where possible
- Include a blank line between logical sections of code
- Always use `{}` for script blocks, even one-liners

```powershell
# Good example
function Get-Example {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    
    process {
        # Function logic here
    }
}
```

## Documentation Requirements

### Comment-Based Help
Every function must include comment-based help with:
- Synopsis
- Description
- At least one example
- All parameters documented
- Any outputs described

Example:
```powershell
<#
.SYNOPSIS
    Retrieves user information from the system.

.DESCRIPTION
    The Get-UserInfo function retrieves detailed information about users
    in the system based on specified filters.

.PARAMETER Username
    The username to retrieve information for.

.EXAMPLE
    Get-UserInfo -Username "john.doe"
    Retrieves information for user john.doe.

.OUTPUTS
    System.Object. Returns a custom object with user properties.
#>
```

### README Updates
If your contribution adds new functionality, update the module README.md to reflect these changes.

### Changelog
Significant changes should be noted in the CHANGELOG.md file.

## Testing Guidelines

### Required Tests
All contributions must include Pester tests that:
- Cover new functionality
- Verify bug fixes
- Maintain or improve code coverage

### Running Tests
```powershell
# Run all tests
Invoke-Pester

# Run tests for a specific function
Invoke-Pester -Path "./tests/Get-Example.Tests.ps1"
```

### Test Structure
- Tests should be in the `tests` directory
- Test files should be named `<FunctionName>.Tests.ps1`
- Use descriptive test names that explain what is being tested
- Include both positive and negative test cases

## Pull Request Process

1. **Ensure all tests pass** locally before submitting
2. **Run PSScriptAnalyzer** to check for style issues:
   ```powershell
   Invoke-ScriptAnalyzer -Path ./path/to/your/script.ps1
   ```
3. **Update documentation** as needed
4. **Create a pull request** with a clear title and description
5. **Link any related issues** in your PR description
6. **Be responsive** to code review feedback

### PR Description Template
```
## Description
[Brief description of the changes]

## Related Issue
[Link to the related issue(s)]

## Motivation and Context
[Why is this change required? What problem does it solve?]

## How Has This Been Tested?
[Description of tests that you ran]

## Types of changes
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to change)
```

## Issue Reporting

When reporting issues:
1. Use the issue template if provided
2. Include PowerShell version (`$PSVersionTable`)
3. Provide steps to reproduce the issue
4. Include expected vs. actual behavior
5. Add any error messages or screenshots

## Community Expectations

### Code of Conduct
All contributors are expected to adhere to our [Code of Conduct](CODE_OF_CONDUCT.md).

### Review Process
- Pull requests require at least one maintainer review
- Feedback should be addressed before merging
- Be patient - maintainers will review PRs as time permits

### Recognition
Contributors will be recognized in the project:
- Added to CONTRIBUTORS.md file
- Mentioned in release notes for significant contributions

## Additional Resources

- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [PowerShell Best Practices and Style Guide](https://github.com/PoshCode/PowerShellPracticeAndStyle)
- [Writing Pester Tests](https://pester.dev/docs/quick-start)

---

Thank you for contributing to our community PowerShell module! Your efforts help make this tool better for everyone.
