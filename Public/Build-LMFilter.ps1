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
    param(
        [Switch]$PassThru
    )

    $Caller = $null
    #Check if called by another function, will be used to determine available fields in the future
    $CallStack = Get-PSCallStack
    if ($CallStack.Count -gt 1) {
        $Caller = $CallStack[1].FunctionName
    }

    Write-Host "Called by: $Caller"

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

    Write-SpectreHost -Message "Welcome to the [bold yellow]Logic Monitor[/] API Filter Builder! Use this wizard to build a filter expression for the [bold]Get-LM*[/] cmdlets."

    while ($true) {
        #Explain the different types of filters
        Write-SpectreHost -Message ""
        Write-SpectreHost -Message "There are two types of filters: [bold yellow]Basic[/] and [bold yellow]Advanced[/]:"
        Write-SpectreHost -Message "   - Basic filters are used to filter based on a single field and a value such as displayName."
        Write-SpectreHost -Message "   - Advanced filters are used to filter based on a property and a value that is within that property. Applies to auto, system, inherited and custom properties."
        Write-SpectreHost -Message ""
        Write-SpectreHost -Message "[bold yellow]Note:[/] You can combine basic/advanced filters within the same filter equation using the [bold yellow]AND[/] or [bold yellow]OR[/] logical operators."
        Write-SpectreHost -Message "[bold yellow]Note:[/] Currently, only devices, device groups, and alerts support advanced property filtering."
        Write-SpectreHost -Message ""
        # Get value type first
        $selectedValueType = Read-SpectreSelection `
            -Message "Select filter type:" `
            -Choices $valueTypes `
            -ChoiceLabelProperty "Name" `
            -Color yellow
        $keyChar = $selectedValueType.Value

        # Get property name based on filter type
        switch ($keyChar) {
            "B" {
                $property = Read-SpectreText -Message "Enter attribute name:"
                # Get operator
                $selectedOperator = Read-SpectreSelection `
                    -Message "Select operator:" `
                    -Choices $operators `
                    -ChoiceLabelProperty "Name" `
                    -Color yellow
                $operator = $selectedOperator.Value
                $valueInput = Read-SpectreText -Message "Enter value:"
                $value = "`"$valueInput`""
            }
            "A" {
                $selectedProperty = Read-SpectreSelection `
                    -Message "Select property type:" `
                    -Choices $propertyTypes `
                    -ChoiceLabelProperty "Name" `
                    -Color yellow
                $property = $selectedProperty.Value
                # Get operator
                $selectedOperator = Read-SpectreSelection `
                    -Message "Select operator:" `
                    -Choices $operators `
                    -ChoiceLabelProperty "Name" `
                    -Color yellow
                $operator = $selectedOperator.Value
                $jsonProperty = Read-SpectreText -Message "Enter property name:"
                $jsonValue = Read-SpectreText -Message "Enter property value:"
                $jsonObject = [ordered]@{ name = $jsonProperty; value = $jsonValue } | ConvertTo-Json -Compress | ConvertTo-Json
                $value = $jsonObject
            }
        }

        $conditions += "$property $operator $value"

        # First ask if they want to continue
        $continue = Read-SpectreConfirm `
            -Message "Would you like to add another condition?" `
            -DefaultAnswer "n" `
            -ConfirmSuccess "Adding another condition..." `
            -ConfirmFailure "Finishing filter equation..."

        if (-not $continue) {
            break
        }

        # If they want to continue, ask for the logical operator
        $selectedLogicalOperator = Read-SpectreSelection `
            -Message "Select logical operator" `
            -Choices $logicalOperators `
            -ChoiceLabelProperty "Name" `
            -Color yellow
        $conditions += $selectedLogicalOperator.Value
    }

    $filterEquation = $conditions -join ' '
    Set-Variable -Name "LMFilter" -Value $filterEquation -Scope global

    If (!$PassThru) {
        Format-SpectrePanel -Data ("'" + $filterEquation + "'") -Title "LM Api Filter Equation" -Border "Rounded" -Color "Green"
        Write-SpectreHost -Message "Filter equation has been saved to the [bold yellow]LMFilter[/] variable."
        return
    }
    Else {
        Write-Host -Message "Filter equation has been saved to the `$LMFilter variable." -ForegroundColor Green
        return $($filterEquation)
    }
} 