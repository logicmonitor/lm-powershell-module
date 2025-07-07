<#
.SYNOPSIS
Updates LogicMonitor portal settings.

.DESCRIPTION
The Set-LMPortalInfo function modifies various portal-wide settings in LogicMonitor, including whitelisting, two-factor authentication, alert totals, and session timeouts.

.PARAMETER Whitelist
Specifies IP addresses/ranges to whitelist for portal access.

.PARAMETER ClearWhitelist
Indicates whether to clear the existing whitelist.

.PARAMETER RequireTwoFA
Specifies whether to require two-factor authentication for all users.

.PARAMETER IncludeACKinAlertTotals
Specifies whether to include acknowledged alerts in alert totals.

.PARAMETER IncludeSDTinAlertTotals
Specifies whether to include alerts in SDT in alert totals.

.PARAMETER EnableRemoteSession
Specifies whether to enable remote session functionality.

.PARAMETER CompanyDisplayName
Specifies the company name to display in the portal.

.PARAMETER UserSessionTimeoutInMin
Specifies the session timeout in minutes. Valid values: 30, 60, 120, 240, 480, 1440, 10080, 43200.

.EXAMPLE
Set-LMPortalInfo -RequireTwoFA $true -UserSessionTimeoutInMin 60 -CompanyDisplayName "My Company"
Updates the portal settings to require 2FA, set session timeout to 60 minutes, and update company display name.

.INPUTS
None.

.OUTPUTS
Returns the response from the API containing the updated portal settings.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

function Set-LMPortalInfo {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [String]$Whitelist,

        [Switch]$ClearWhitelist,

        [Nullable[boolean]]$RequireTwoFA,

        [Nullable[boolean]]$IncludeACKinAlertTotals,

        [Nullable[boolean]]$IncludeSDTinAlertTotals,

        [Nullable[boolean]]$EnableRemoteSession,

        [String]$CompanyDisplayName,

        [ValidateSet(30, 60, 120, 240, 480, 1440, 10080, 43200)]
        [Nullable[Int]]$UserSessionTimeoutInMin

    )

    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/setting/companySetting"

            $Data = @{
                whiteList               = $Whitelist
                sessionTimeoutInSeconds = $UserSessionTimeoutInMin * 60
                requireTwoFA            = $RequireTwoFA
                alertTotalIncludeInAck  = $IncludeACKinAlertTotals
                alertTotalIncludeInSdt  = $IncludeSDTinAlertTotals
                companyDisplayName      = $CompanyDisplayName
                enableRemoteSession     = $EnableRemoteSession
            }

            #Remove empty keys so we dont overwrite them
            if ($ClearWhitelist) {
                $Data.whitelist = ""
            }

            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                -AlwaysKeepKeys @($(if ($ClearWhitelist) { 'whitelist' } else { @() }))

            $Message = "Portal: $($Script:LMAuth.Portal)"

            try {
                if ($PSCmdlet.ShouldProcess($Message, "Set Portal Info")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
                }
            }
            catch {
                return
            }

            if ($Response) {
                return $Response
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
