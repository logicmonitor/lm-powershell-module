<#
.SYNOPSIS
Updates a LogicMonitor Service Template (dynamic Service Insight rule).

.DESCRIPTION
The Set-LMDynamicServiceInsight function updates an existing Service Template
via /serviceTemplates/updateTemplate. Unlike Set-LMDevice-style cmdlets,
this endpoint accepts a genuine partial update — only the fields you
specify are sent (plus Id and the model discriminator), and anything
you don't pass is left as-is on the template.

A Service Template is the rule LogicMonitor uses to dynamically spawn
individual Service Insights from a resource property (e.g. one per
distinct "customer" property value) — this is separate from a static
Service Insight (see New-/Get-/Set-/Remove-LMServiceInsight), which has
a fixed, manually defined membership list instead of a property-driven
rule.

.PARAMETER Id
The ID of the Service Template to update. Mandatory.

.PARAMETER IsEnabled
Enable or disable the template. A newly created template
(New-LMDynamicServiceInsight) starts disabled — this is how you activate it,
matching LogicMonitor's own UI flow (create, then a separate enable
step).

.PARAMETER Name
New name for the template.

.PARAMETER Description
New description for the template.

.PARAMETER Cardinality
Replaces the template's cardinality array entirely (see
New-LMDynamicServiceInsight for the shape).

.PARAMETER PropertySelector
Replaces the template's propertySelector array entirely.

.PARAMETER Properties
Replaces the template's properties array entirely.

.PARAMETER ServiceNamingPattern
Replaces the naming pattern array entirely, e.g. @("prefix-", "##customer##", "-suffix").

.PARAMETER GroupNamingPattern
Replaces the group naming pattern array entirely.

.PARAMETER CreateGroup
Whether to create groups for spawned services.

.PARAMETER DefaultCriticality
New default criticality ("Low", "Medium", "High", "Critical" per LM's
usual scale).

.PARAMETER MembershipEvaluationInterval
New membership re-evaluation interval, in minutes.

.PARAMETER FilterType
New filter type.

.PARAMETER ResourceGroupRecords
Replaces resourceGroupRecords entirely.

.PARAMETER Criticality
Replaces the criticality array entirely.

.PARAMETER StaticGroup
Replaces the staticGroup array entirely.

.PARAMETER ManageRuleLevel
LogicMonitor's own UI sends "PARTIAL" here when editing an
already-activated template's fields (as opposed to the initial
enable-toggle call, which omits it). Defaults to "PARTIAL" whenever any
field besides -IsEnabled is being changed; omitted otherwise. Override
only if you've confirmed a different value is needed.

.EXAMPLE
#Activate a newly created template
Set-LMDynamicServiceInsight -Id 7 -IsEnabled $true

.EXAMPLE
#Change the naming pattern on an active template
Set-LMDynamicServiceInsight -Id 7 -ServiceNamingPattern @("prefix-", "##customer##", "-suffix")

.NOTES
You must run Connect-LMAccount with -SessionSync before running this
command — this endpoint does not support LMv1 or Bearer auth.
Request shape confirmed via a HAR capture of LogicMonitor's own
dynamic Service Insight creation and editing UI against
/serviceTemplates/updateTemplate.

.INPUTS
You can pipe objects containing an Id property to this function.

.OUTPUTS
Returns a LogicMonitor.ServiceTemplate object for the updated template.
#>
function Set-LMDynamicServiceInsight {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Nullable[Boolean]]$IsEnabled,

        [String]$Name,

        [String]$Description,

        [Array]$Cardinality,

        [Array]$PropertySelector,

        [Array]$Properties,

        [Array]$ServiceNamingPattern,

        [Array]$GroupNamingPattern,

        [Nullable[Boolean]]$CreateGroup,

        [String]$DefaultCriticality,

        [String]$MembershipEvaluationInterval,

        [String]$FilterType,

        [Array]$ResourceGroupRecords,

        [Array]$Criticality,

        [Array]$StaticGroup,

        [String]$ManageRuleLevel
    )

    begin {}
    process {
        if (-not ($Script:LMAuth.Valid -and $Script:LMAuth.Type -eq "SessionSync")) {
            Write-Error "This cmdlet is for internal use only at this time does not support LMv1 or Bearer auth. Use Connect-LMAccount to login with the correct auth type and try again"
            return
        }

        $fieldMap = @{
            Name                          = 'name'
            Description                   = 'description'
            Cardinality                   = 'cardinality'
            PropertySelector              = 'propertySelector'
            Properties                    = 'properties'
            ServiceNamingPattern          = 'serviceNamingPattern'
            GroupNamingPattern            = 'groupNamingPattern'
            CreateGroup                   = 'createGroup'
            DefaultCriticality            = 'defaultCriticality'
            MembershipEvaluationInterval  = 'membershipEvaluationInterval'
            FilterType                    = 'filterType'
            ResourceGroupRecords          = 'resourceGroupRecords'
            Criticality                   = 'criticality'
            StaticGroup                   = 'staticGroup'
        }

        $touchedOtherFields = ($fieldMap.Keys | Where-Object { $PSBoundParameters.ContainsKey($_) }).Count -gt 0

        if (-not $touchedOtherFields -and -not $PSBoundParameters.ContainsKey('IsEnabled')) {
            Write-Error "No fields specified to update - provide at least one parameter besides -Id."
            return
        }

        # /serviceTemplates/updateTemplate only genuinely supports a partial
        # update for the bare enable/disable toggle (confirmed empirically:
        # {id, model, isEnabled} alone works, but touching any other field
        # without also sending the rest of the object fails with
        # PARAMETER_REQUIRED). For anything else, fetch the current full
        # template and send the merged whole object back, matching what
        # LogicMonitor's own edit-fields UI flow does.
        if ($touchedOtherFields) {
            $current = Get-LMDynamicServiceInsight -Id $Id
            if (-not $current) {
                Write-Error "No Service Template found with Id $Id."
                return
            }

            # Get-LMDynamicServiceInsight -Id returns filterType as a read-side
            # label (e.g. "RESOURCE_AND_INSTANCE"), but the write side
            # expects the original numeric-string code (e.g. "2", the
            # default New-LMDynamicServiceInsight itself uses) - these aren't
            # interchangeable, confirmed by the write API rejecting the
            # label with a deserialization error. Only one mapping has
            # been observed; anything else falls back to the create
            # default rather than sending a value known to be wrong.
            $filterTypeWriteValue = switch ($current.filterType) {
                'RESOURCE_AND_INSTANCE' { '2' }
                default {
                    Write-Warning "Unrecognized filterType '$($current.filterType)' on template $Id - falling back to default '2'. Verify this is correct for this template."
                    '2'
                }
            }

            $item = [ordered]@{
                id                            = $Id
                model                         = 'RestServiceTemplate'
                name                          = $current.name
                description                   = $current.description
                defaultCriticality            = $current.defaultCriticality
                cardinality                   = $current.cardinality
                propertySelector              = $current.propertySelector
                serviceNamingPattern          = $current.serviceNamingPattern
                groupNamingPattern            = $current.groupNamingPattern
                membershipEvaluationInterval  = $current.membershipEvaluationInterval
                properties                    = $current.properties
                createGroup                   = $current.createGroup
                criticality                   = $current.criticality
                staticGroup                   = $current.staticGroup
                filterType                    = $filterTypeWriteValue
                resourceGroupRecords          = @()
            }

            foreach ($paramName in $fieldMap.Keys) {
                if ($PSBoundParameters.ContainsKey($paramName)) {
                    $item[$fieldMap[$paramName]] = Get-Variable -Name $paramName -ValueOnly
                }
            }

            if ($PSBoundParameters.ContainsKey('IsEnabled')) {
                $item['isEnabled'] = $IsEnabled
            }

            # LM's own UI sends manageRuleLevel "PARTIAL" on this
            # full-object edit flow, once a template has been activated.
            $item['manageRuleLevel'] = if ($PSBoundParameters.ContainsKey('ManageRuleLevel')) { $ManageRuleLevel } else { 'PARTIAL' }
        }
        else {
            # Pure enable/disable toggle - the genuinely minimal payload.
            $item = [ordered]@{
                id        = $Id
                model     = 'RestServiceTemplate'
                isEnabled = $IsEnabled
            }
        }

        $Data = @{
            data = @{
                items = @($item)
            }
            meta = @{
                addFromWizard = $false
            }
        } | ConvertTo-Json -Depth 10

        $ResourcePath = "/serviceTemplates/updateTemplate"
        $Message = "Id: $Id"

        if ($PSCmdlet.ShouldProcess($Message, "Update Service Template")) {

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Version 4
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            $template = $Response.data.byId.RestServiceTemplate.$Id
            return (Add-ObjectTypeInfo -InputObject $template -TypeName "LogicMonitor.ServiceTemplate")
        }
    }
    end {}
}
