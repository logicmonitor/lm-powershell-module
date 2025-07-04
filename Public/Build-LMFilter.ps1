<#
.SYNOPSIS
Builds a filter expression for Logic Monitor API queries.

.DESCRIPTION
The Build-LMFilter function creates a filter expression by interactively prompting for conditions and operators. It supports basic filtering for single fields and advanced filtering for property-based queries. Multiple conditions can be combined using AND/OR operators.

.PARAMETER PassThru
When specified, returns the filter expression as a string instead of displaying it in a panel.

.EXAMPLE
#Build a basic filter expression
Build-LMFilter
This example launches the interactive filter builder wizard.

.EXAMPLE
#Build a filter and return the expression
Build-LMFilter -PassThru
This example builds a filter and returns the expression as a string.

.NOTES
The filter expression is saved to the global $LMFilter variable.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
[String] Returns a PowerShell filter expression when using -PassThru.
#>

function Build-LMFilter {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for the function to work')]
    param(
        [Switch]$PassThru
    )

    # Helper function for getting user selection
    function Get-UserSelection {
        param(
            [Parameter(Mandatory = $true)]
            [string]$Prompt,
            [Parameter(Mandatory = $true)]
            [array]$Choices,
            [Parameter(Mandatory = $true)]
            [string]$ChoiceLabelProperty
        )

        Write-Host "$Prompt"
        for ($i = 0; $i -lt $Choices.Count; $i++) {
            Write-Host ("  " + ($i + 1) + ". " + $Choices[$i].($ChoiceLabelProperty))
        }

        $choiceNumber = 0
        do {
            $choiceInput = Read-Host "Enter selection number (1-$($Choices.Count))"
            if ([int]::TryParse($choiceInput, [ref]$choiceNumber) -and $choiceNumber -ge 1 -and $choiceNumber -le $Choices.Count) {
                # Valid input
            }
            else {
                Write-Host "Invalid input. Please enter a number between 1 and $($Choices.Count)." -ForegroundColor Red
                $choiceNumber = 0 # Reset to ensure loop continues
            }
        } while ($choiceNumber -eq 0)

        return $Choices[$choiceNumber - 1]
    }

    # Helper function for getting user confirmation
    function Get-UserConfirmation {
        param(
            [Parameter(Mandatory = $true)]
            [string]$Prompt,
            [string]$DefaultAnswer = "n",
            [string]$ConfirmSuccess = "Proceeding...",
            [string]$ConfirmFailure = "Stopping..."
        )

        $answer = ""
        $validAnswers = @("y", "n")
        do {
            $choiceInput = Read-Host "$Prompt (y/n) [$DefaultAnswer]"
            if ([string]::IsNullOrEmpty($choiceInput)) {
                $choiceInput = $DefaultAnswer
            }
            if ($validAnswers -contains $choiceInput.ToLower()) {
                $answer = $choiceInput.ToLower()
            }
            else {
                Write-Host "Invalid input. Please enter 'y' or 'n'." -ForegroundColor Red
            }
        } while ([string]::IsNullOrEmpty($answer))

        if ($answer -eq 'y') {
            Write-Host $ConfirmSuccess
            return $true
        }
        else {
            Write-Host $ConfirmFailure
            return $false
        }
    }

    # $Caller = $null
    # #Check if called by another function, will be used to determine available fields in the future
    # $CallStack = Get-PSCallStack
    # if ($CallStack.Count -gt 1) {
    #     $Caller = $CallStack[1].FunctionName
    # }

    $conditions = @()
    $operators = @(
        @{ Name = "Equals"; Value = "-eq" },
        @{ Name = "Not Equals"; Value = "-ne" },
        @{ Name = "Greater Than"; Value = "-gt" },
        @{ Name = "Less Than"; Value = "-lt" },
        @{ Name = "Contains"; Value = "-contains" },
        @{ Name = "Not Contains"; Value = "-notcontains" }
    )

    $valueTypes = @(
        @{ Name = "Basic Filtering"; Value = "B" },
        @{ Name = "Advanced Property Filtering"; Value = "A" }
    )

    $logicalOperators = @(
        @{ Name = "AND"; Value = "-and" },
        @{ Name = "OR"; Value = "-or" }
    )

    $propertyTypes = @(
        @{ Name = "System Property"; Value = "systemProperties" },
        @{ Name = "Auto Property"; Value = "autoProperties" },
        @{ Name = "Inherited Property"; Value = "inheritedProperties" },
        @{ Name = "Custom Property"; Value = "customProperties" }
    )

    Write-Host "Welcome to the Logic Monitor API Filter Builder! Use this wizard to build a filter expression for the Get-LM* cmdlets."

    #Explain the different types of filters
    Write-Host ""
    Write-Host "There are two types of filters: Basic and Advanced:"
    Write-Host "   - Basic filters are used to filter based on a single field and a value such as displayName."
    Write-Host "   - Advanced filters are used to filter based on a property and a value that is within that property. Applies to auto, system, inherited and custom properties."
    Write-Host ""
    Write-Host "Note: You can combine basic/advanced filters within the same filter equation using the AND or OR logical operators."
    Write-Host "Note: Currently, only devices, device groups, and alerts support advanced property filtering."
    Write-Host ""
    while ($true) {
        # Get value type first
        $selectedValueType = Get-UserSelection `
            -Prompt "Select filter type:" `
            -Choices $valueTypes `
            -ChoiceLabelProperty "Name"
        $keyChar = $selectedValueType.Value

        # Get property name based on filter type
        switch ($keyChar) {
            "B" {
                $property = Read-Host "Enter attribute name"
                # Get operator
                $selectedOperator = Get-UserSelection `
                    -Prompt "Select operator:" `
                    -Choices $operators `
                    -ChoiceLabelProperty "Name"
                $operator = $selectedOperator.Value
                $valueInput = Read-Host "Enter value"
                # Ensure string values are quoted for the filter
                $value = "`"$valueInput`""
            }
            "A" {
                $selectedProperty = Get-UserSelection `
                    -Prompt "Select property type:" `
                    -Choices $propertyTypes `
                    -ChoiceLabelProperty "Name"
                $property = $selectedProperty.Value
                # Get operator
                $selectedOperator = Get-UserSelection `
                    -Prompt "Select operator:" `
                    -Choices $operators `
                    -ChoiceLabelProperty "Name"
                $operator = $selectedOperator.Value
                $jsonProperty = Read-Host "Enter property name"
                $jsonValue = Read-Host "Enter property value"
                # Convert to JSON string suitable for LM API. Needs double conversion for proper escaping in the final filter string.
                $jsonObject = [ordered]@{ name = $jsonProperty; value = $jsonValue } | ConvertTo-Json -Compress | ConvertTo-Json -Compress
                $value = $jsonObject
            }
        }

        $conditions += "$property $operator $value"

        # First ask if they want to continue
        $continue = Get-UserConfirmation `
            -Prompt "Would you like to add another condition?" `
            -DefaultAnswer "n" `
            -ConfirmSuccess "Adding another condition..." `
            -ConfirmFailure "Finishing filter equation..."

        if (-not $continue) {
            break
        }

        # If they want to continue, ask for the logical operator
        $selectedLogicalOperator = Get-UserSelection `
            -Prompt "Select logical operator" `
            -Choices $logicalOperators `
            -ChoiceLabelProperty "Name"
        $conditions += $selectedLogicalOperator.Value
    }

    $filterEquation = $conditions -join ' '
    Set-Variable -Name "LMFilter" -Value $filterEquation -Scope global

    if (!$PassThru) {
        Write-Host "--- LM API Filter Equation ---"
        Write-Host "'$filterEquation'"
        Write-Host "-----------------------------"
        Write-Host "Filter equation has been saved to the `$LMFilter variable." -ForegroundColor Green
        return # Return nothing visually when not using PassThru
    }
    else {
        Write-Host "Filter equation has been saved to the `$LMFilter variable." -ForegroundColor Green
        return $filterEquation # Return the string when using PassThru
    }
}