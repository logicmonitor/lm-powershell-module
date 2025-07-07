<#
.SYNOPSIS
Updates a LogicMonitor user configuration.

.DESCRIPTION
The Set-LMUser function modifies an existing user in LogicMonitor, including their roles, permissions, and settings.

.PARAMETER Id
Specifies the ID of the user to modify.

.PARAMETER Username
Specifies the current username.

.PARAMETER NewUsername
Specifies the new username.

.PARAMETER Email
Specifies the email address for the user.

.PARAMETER UserGroups
Specifies an array of user group names to assign to the user.

.PARAMETER AcceptEULA
Indicates whether the user has accepted the EULA.

.PARAMETER Password
Specifies the new password for the user.

.PARAMETER FirstName
Specifies the user's first name.

.PARAMETER LastName
Specifies the user's last name.

.PARAMETER ForcePasswordChange
Indicates whether to force the user to change their password at next login.

.PARAMETER Phone
Specifies the user's phone number.

.PARAMETER Note
Specifies a note for the user.

.PARAMETER RoleNames
Specifies an array of role names to assign to the user.

.PARAMETER Status
Specifies the user's status. Valid values: "active", "suspended".

.PARAMETER Views
Specifies the views the user has access to. Valid values: "Alerts", "Dashboards", "Logs", "Maps", "Reports", "Resources", "Settings", "Websites", "All".

.EXAMPLE
Set-LMUser -Id 123 -NewUsername "newuser" -Email "user@domain.com" -Status "active"
Updates the user with new username, email, and status.

.INPUTS
None.

.OUTPUTS
Returns a LogicMonitor.User object containing the updated user configuration.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
function Set-LMUser {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'None')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingUsernameAndPasswordParams', '', Justification = 'Required for the FilterWizard to work')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Username')]
        [String]$Username,

        [String]$NewUsername,

        [String]$Email,

        [String[]]$UserGroups,

        [Nullable[boolean]]$AcceptEULA,

        [SecureString]$Password,

        [String]$FirstName,

        [String]$LastName,

        [Nullable[boolean]]$ForcePasswordChange,

        [String]$Phone,

        [String]$Note,

        [String[]]$RoleNames,

        [String]$SmsEmail,

        [ValidateSet("sms", "fulltext")]
        [String]$SmsEmailFormat,

        [ValidateSet("active", "suspended")]
        [String]$Status,

        [ValidateSet("Africa/Abidjan", "Africa/Accra", "Africa/Addis_Ababa", "Africa/Algiers", "Africa/Asmara", "Africa/Bamako", "Africa/Bangui", "Africa/Banjul", "Africa/Bissau", "Africa/Blantyre", "Africa/Brazzaville", "Africa/Bujumbura", "Africa/Cairo", "Africa/Casablanca", "Africa/Ceuta", "Africa/Conakry", "Africa/Dakar", "Africa/Dar_es_Salaam", "Africa/Djibouti", "Africa/Douala", "Africa/El_Aaiun", "Africa/Freetown", "Africa/Gaborone", "Africa/Harare", "Africa/Johannesburg", "Africa/Juba", "Africa/Kampala", "Africa/Khartoum", "Africa/Kigali", "Africa/Kinshasa", "Africa/Lagos", "Africa/Libreville", "Africa/Lome", "Africa/Luanda", "Africa/Lubumbashi", "Africa/Lusaka", "Africa/Malabo", "Africa/Maputo", "Africa/Maseru", "Africa/Mbabane", "Africa/Mogadishu", "Africa/Monrovia", "Africa/Nairobi", "Africa/Ndjamena", "Africa/Niamey", "Africa/Nouakchott", "Africa/Ouagadougou", "Africa/Porto-Novo", "Africa/Sao_Tome", "Africa/Tripoli", "Africa/Tunis", "Africa/Windhoek", "America/Adak", "America/Anchorage", "America/Anguilla", "America/Antigua", "America/Araguaina", "America/Argentina/Buenos_Aires", "America/Argentina/Catamarca", "America/Argentina/Cordoba", "America/Argentina/Jujuy", "America/Argentina/La_Rioja", "America/Argentina/Mendoza", "America/Argentina/Rio_Gallegos", "America/Argentina/Salta", "America/Argentina/San_Juan", "America/Argentina/San_Luis", "America/Argentina/Tucuman", "America/Argentina/Ushuaia", "America/Aruba", "America/Asuncion", "America/Atikokan", "America/Bahia", "America/Bahia_Banderas", "America/Barbados", "America/Belem", "America/Belize", "America/Blanc-Sablon", "America/Boa_Vista", "America/Bogota", "America/Boise", "America/Cambridge_Bay", "America/Campo_Grande", "America/Cancun", "America/Caracas", "America/Cayenne", "America/Cayman", "America/Chicago", "America/Chihuahua", "America/Costa_Rica", "America/Creston", "America/Cuiaba", "America/Curacao", "America/Danmarkshavn", "America/Dawson", "America/Dawson_Creek", "America/Denver", "America/Detroit", "America/Dominica", "America/Edmonton", "America/Eirunepe", "America/El_Salvador", "America/Fort_Nelson", "America/Fortaleza", "America/Glace_Bay", "America/Goose_Bay", "America/Grand_Turk", "America/Grenada", "America/Guadeloupe", "America/Guatemala", "America/Guayaquil", "America/Guyana", "America/Halifax", "America/Havana", "America/Hermosillo", "America/Indiana/Indianapolis", "America/Indiana/Knox", "America/Indiana/Marengo", "America/Indiana/Petersburg", "America/Indiana/Tell_City", "America/Indiana/Vevay", "America/Indiana/Vincennes", "America/Indiana/Winamac", "America/Inuvik", "America/Iqaluit", "America/Jamaica", "America/Juneau", "America/Kentucky/Louisville", "America/Kentucky/Monticello", "America/Kralendijk", "America/La_Paz", "America/Lima", "America/Los_Angeles", "America/Lower_Princes", "America/Maceio", "America/Managua", "America/Manaus", "America/Marigot", "America/Martinique", "America/Matamoros", "America/Mazatlan", "America/Menominee", "America/Merida", "America/Metlakatla", "America/Mexico_City", "America/Miquelon", "America/Moncton", "America/Monterrey", "America/Montevideo", "America/Montserrat", "America/Nassau", "America/New_York", "America/Nipigon", "America/Nome", "America/Noronha", "America/North_Dakota/Beulah", "America/North_Dakota/Center", "America/North_Dakota/New_Salem", "America/Nuuk", "America/Ojinaga", "America/Panama", "America/Pangnirtung", "America/Paramaribo", "America/Phoenix", "America/Port_of_Spain", "America/Port-au-Prince", "America/Porto_Velho", "America/Puerto_Rico", "America/Punta_Arenas", "America/Rainy_River", "America/Rankin_Inlet", "America/Recife", "America/Regina", "America/Resolute", "America/Rio_Branco", "America/Santarem", "America/Santiago", "America/Santo_Domingo", "America/Sao_Paulo", "America/Scoresbysund", "America/Sitka", "America/St_Barthelemy", "America/St_Johns", "America/St_Kitts", "America/St_Lucia", "America/St_Thomas", "America/St_Vincent", "America/Swift_Current", "America/Tegucigalpa", "America/Thule", "America/Thunder_Bay", "America/Tijuana", "America/Toronto", "America/Tortola", "America/Vancouver", "America/Whitehorse", "America/Winnipeg", "America/Yakutat", "America/Yellowknife", "Antarctica/Casey", "Antarctica/Davis", "Antarctica/DumontDUrville", "Antarctica/Macquarie", "Antarctica/Mawson", "Antarctica/McMurdo", "Antarctica/Palmer", "Antarctica/Rothera", "Antarctica/Syowa", "Antarctica/Troll", "Antarctica/Vostok", "Arctic/Longyearbyen", "Asia/Aden", "Asia/Almaty", "Asia/Amman", "Asia/Anadyr", "Asia/Aqtau", "Asia/Aqtobe", "Asia/Ashgabat", "Asia/Atyrau", "Asia/Baghdad", "Asia/Bahrain", "Asia/Baku", "Asia/Bangkok", "Asia/Barnaul", "Asia/Beirut", "Asia/Bishkek", "Asia/Brunei", "Asia/Chita", "Asia/Choibalsan", "Asia/Colombo", "Asia/Damascus", "Asia/Dhaka", "Asia/Dili", "Asia/Dubai", "Asia/Dushanbe", "Asia/Famagusta", "Asia/Gaza", "Asia/Hebron", "Asia/Ho_Chi_Minh", "Asia/Hong_Kong", "Asia/Hovd", "Asia/Irkutsk", "Asia/Jakarta", "Asia/Jayapura", "Asia/Jerusalem", "Asia/Kabul", "Asia/Kamchatka", "Asia/Karachi", "Asia/Kathmandu", "Asia/Khandyga", "Asia/Kolkata", "Asia/Krasnoyarsk", "Asia/Kuala_Lumpur", "Asia/Kuching", "Asia/Kuwait", "Asia/Macau", "Asia/Magadan", "Asia/Makassar", "Asia/Manila", "Asia/Muscat", "Asia/Nicosia", "Asia/Novokuznetsk", "Asia/Novosibirsk", "Asia/Omsk", "Asia/Oral", "Asia/Phnom_Penh", "Asia/Pontianak", "Asia/Pyongyang", "Asia/Qatar", "Asia/Qostanay", "Asia/Qyzylorda", "Asia/Riyadh", "Asia/Sakhalin", "Asia/Samarkand", "Asia/Seoul", "Asia/Shanghai", "Asia/Singapore", "Asia/Srednekolymsk", "Asia/Taipei", "Asia/Tashkent", "Asia/Tbilisi", "Asia/Tehran", "Asia/Thimphu", "Asia/Tokyo", "Asia/Tomsk", "Asia/Ulaanbaatar", "Asia/Urumqi", "Asia/Ust-Nera", "Asia/Vientiane", "Asia/Vladivostok", "Asia/Yakutsk", "Asia/Yangon", "Asia/Yekaterinburg", "Asia/Yerevan", "Atlantic/Azores", "Atlantic/Bermuda", "Atlantic/Canary", "Atlantic/Cape_Verde", "Atlantic/Faroe", "Atlantic/Madeira", "Atlantic/Reykjavik", "Atlantic/South_Georgia", "Atlantic/St_Helena", "Atlantic/Stanley", "Australia/Adelaide", "Australia/Brisbane", "Australia/Broken_Hill", "Australia/Darwin", "Australia/Eucla", "Australia/Hobart", "Australia/Lindeman", "Australia/Lord_Howe", "Australia/Melbourne", "Australia/Perth", "Australia/Sydney", "Europe/Amsterdam", "Europe/Andorra", "Europe/Astrakhan", "Europe/Athens", "Europe/Belgrade", "Europe/Berlin", "Europe/Bratislava", "Europe/Brussels", "Europe/Bucharest", "Europe/Budapest", "Europe/Busingen", "Europe/Chisinau", "Europe/Copenhagen", "Europe/Dublin", "Europe/Gibraltar", "Europe/Guernsey", "Europe/Helsinki", "Europe/Isle_of_Man", "Europe/Istanbul", "Europe/Jersey", "Europe/Kaliningrad", "Europe/Kiev", "Europe/Kirov", "Europe/Lisbon", "Europe/Ljubljana", "Europe/London", "Europe/Luxembourg", "Europe/Madrid", "Europe/Malta", "Europe/Mariehamn", "Europe/Minsk", "Europe/Monaco", "Europe/Moscow", "Europe/Oslo", "Europe/Paris", "Europe/Podgorica", "Europe/Prague", "Europe/Riga", "Europe/Rome", "Europe/Samara", "Europe/San_Marino", "Europe/Sarajevo", "Europe/Saratov", "Europe/Simferopol", "Europe/Skopje", "Europe/Sofia", "Europe/Stockholm", "Europe/Tallinn", "Europe/Tirane", "Europe/Ulyanovsk", "Europe/Uzhgorod", "Europe/Vaduz", "Europe/Vatican", "Europe/Vienna", "Europe/Vilnius", "Europe/Volgograd", "Europe/Warsaw", "Europe/Zagreb", "Europe/Zaporozhye", "Europe/Zurich", "Indian/Antananarivo", "Indian/Chagos", "Indian/Christmas", "Indian/Cocos", "Indian/Comoro", "Indian/Kerguelen", "Indian/Mahe", "Indian/Maldives", "Indian/Mauritius", "Indian/Mayotte", "Indian/Reunion", "Pacific/Apia", "Pacific/Auckland", "Pacific/Bougainville", "Pacific/Chatham", "Pacific/Chuuk", "Pacific/Easter", "Pacific/Efate", "Pacific/Enderbury", "Pacific/Fakaofo", "Pacific/Fiji", "Pacific/Funafuti", "Pacific/Galapagos", "Pacific/Gambier", "Pacific/Guadalcanal", "Pacific/Guam", "Pacific/Honolulu", "Pacific/Kiritimati", "Pacific/Kosrae", "Pacific/Kwajalein", "Pacific/Majuro", "Pacific/Marquesas", "Pacific/Midway", "Pacific/Nauru", "Pacific/Niue", "Pacific/Norfolk", "Pacific/Noumea", "Pacific/Pago_Pago", "Pacific/Palau", "Pacific/Pitcairn", "Pacific/Pohnpei", "Pacific/Port_Moresby", "Pacific/Rarotonga", "Pacific/Saipan", "Pacific/Tahiti", "Pacific/Tarawa", "Pacific/Tongatapu", "Pacific/Wake", "Pacific/Wallis")]
        [String]$Timezone,

        [Nullable[boolean]]$TwoFAEnabled,

        [ValidateSet("Alerts", "Dashboards", "Logs", "Maps", "Reports", "Resources", "Settings", "Websites", "All")]
        [String[]]$Views
    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Lookup Id if supplying username
            if ($Username) {
                $LookupResult = (Get-LMUser -Name $Username).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Username) {
                    return
                }
                $Id = $LookupResult
            }

            #Build admin group props to update user group
            $AdminGroup = ""
            $AdminGroupIds = ""
            if ($UserGroups) {
                $AdminGroup = @()
                $AdminGroupIds = @()
                foreach ($Group in $UserGroups) {
                    if ($Group -match "\*") {
                        Write-Error "Wildcard values not supported for groups."
                        return
                    }
                    $Group = (Get-LMUserGroup -Name $Group | Select-Object -First 1 )
                    if (!$Group) {
                        Write-Error "Unable to find username: $Username, please check spelling and try again."
                        return
                    }
                    $AdminGroup += @{id = $Group.id; name = $Group.name }
                    $AdminGroupIds += $Group.id
                }
            }

            #Build role id list
            $Roles = @()
            foreach ($Role in $RoleNames) {
                $RoleId = (Get-LMRole -Name $Role | Select-Object -First 1 ).Id
                if ($RoleId) {
                    $Roles += @{id = $RoleId }
                }
                else {
                    Write-Warning "[WARN]: Unable to locate user role named $Role, it will be skipped"
                }
            }

            #Build view permissions hashtable
            $ViewPermission = ""
            if ($Views) {
                $ViewPermission = @{
                    Alerts     = $false
                    Dashboards = $false
                    Logs       = $false
                    Maps       = $false
                    Reports    = $false
                    Resources  = $false
                    Settings   = $false
                    Websites   = $false
                }

                foreach ($View in $Views) {
                    if ($View -eq "All") {
                        foreach ($key in $($ViewPermission.keys)) {
                            $ViewPermission[$key] = $true
                        }
                        break
                    }
                    elseif ($ViewPermission.ContainsKey($View)) {
                        $ViewPermission[$View] = $true
                    }
                }
            }

            #Build header and uri
            $ResourcePath = "/setting/admins/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | Username: $($PSItem.username)"
            }
            elseif ($Username) {
                $Message = "Id: $Id | Username: $Username"
            }
            else {
                $Message = "Id: $Id"
            }

            $Data = @{
                username            = $NewUsername
                email               = $Email
                acceptEULA          = $AcceptEULA
                password            = $Password
                firstName           = $FirstName
                lastName            = $LastName
                forcePasswordChange = $ForcePasswordChange
                phone               = $(if ($Phone) { "+" + $Phone.Replace("-", "") }else { "" })
                note                = $Note
                roles               = $Roles
                smsEmail            = $SmsEmail
                smsEmailFormat      = $SmsEmailFormat
                status              = $Status
                timezone            = $Timezone
                twoFAEnabled        = $TwoFAEnabled
                viewPermission      = $ViewPermission
                adminGroup          = $AdminGroup
                adminGroupIds       = $AdminGroupIds

            }
            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys

            if ($PSCmdlet.ShouldProcess($Message, "Set User")) {
                try {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request using new centralized method with retry logic
                    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.User" )
                }
                catch {

                    return
                }
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
