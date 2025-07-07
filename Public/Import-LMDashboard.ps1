<#
.SYNOPSIS
Imports LogicMonitor dashboards from various sources.

.DESCRIPTION
The Import-LMDashboard function allows you to import LogicMonitor dashboards from different sources, such as local files, GitHub repositories, or LogicMonitor dashboard groups. It supports importing dashboards in JSON format.

.PARAMETER FilePath
Specifies the path to a local file or directory containing the JSON dashboard files to import.

.PARAMETER File
Specifies a single JSON dashboard file to import.

.PARAMETER GithubUserRepo
Specifies the GitHub repository (in the format "username/repo") from which to import JSON dashboard files.

.PARAMETER GithubAccessToken
Specifies the GitHub access token for authenticated requests. Required for large repositories due to API rate limits.

.PARAMETER ParentGroupId
The ID of the parent dashboard group where imported dashboards will be placed.

.PARAMETER ParentGroupName
The name of the parent dashboard group where imported dashboards will be placed.

.PARAMETER ReplaceAPITokensOnImport
Switch to replace API tokens in imported dashboards with a dynamically generated token.

.PARAMETER APIToken
The API token to use when replacing tokens in imported dashboards.

.PARAMETER PrivateUserName
The username of dashboard owner when creating dashboard as private.

.EXAMPLE
#Import dashboards from a directory
Import-LMDashboard -FilePath "C:\Dashboards" -ParentGroupId 12345 -ReplaceAPITokensOnImport -APIToken $apiToken

.EXAMPLE
#Import dashboards from GitHub
Import-LMDashboard -GithubUserRepo "username/repo" -ParentGroupName "MyDashboards" -ReplaceAPITokensOnImport -APIToken $apiToken

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns imported dashboard objects.
#>
function Import-LMDashboard {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'FilePath-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'FilePath-GroupName')]
        [String]$FilePath,

        [Parameter(Mandatory, ParameterSetName = 'File-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'File-GroupName')]
        [String]$File,

        [Parameter(Mandatory, ParameterSetName = 'Repo-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Repo-GroupName')]
        [String]$GithubUserRepo, # format "username/repo"

        [Parameter(ParameterSetName = 'Repo-GroupId')]
        [Parameter(ParameterSetName = 'Repo-GroupName')]
        [String]$GithubAccessToken, #Required for large repos, github api is limited to 60 requests per hour when unauthenticated

        [Parameter(Mandatory, ParameterSetName = 'FilePath-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'File-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Repo-GroupId')]
        [String]$ParentGroupId,

        [Parameter(Mandatory, ParameterSetName = 'FilePath-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'File-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Repo-GroupName')]
        [String]$ParentGroupName,

        [Switch]$ReplaceAPITokensOnImport,

        $APIToken,

        [String]$PrivateUserName = ""
    )

    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            $Results = @()
            $DashboardList = @()

            if ($ParentGroupName) {
                $ParentGroupId = (Get-LMDashboardGroup -Name $ParentGroupName | Select-Object -First 1 ).Id
            }
            if ($ParentGroupId) {
                $ParentGroupName = (Get-LMDashboardGroup -Id $ParentGroupId | Select-Object -First 1 ).Name
            }

            if ($FilePath) {
                if ((Get-Item $FilePath) -is [System.IO.DirectoryInfo]) {
                    $FullPath = (Resolve-Path $FilePath).Path
                    $Files = Get-ChildItem $FullPath -Recurse | Where-Object { ([IO.Path]::GetExtension($_.Name) -eq '.json') }
                    foreach ($F in $Files) {
                        #Convert from json into object
                        $RawFile = Get-Content $F.FullName -Raw | ConvertFrom-Json
                        $DashboardList += @{
                            file       = $RawFile
                            path       = $($F.DirectoryName -split $FullPath)[1]
                            parentid   = $ParentGroupId
                            parentname = $ParentGroupName
                        }
                    }
                }
                else {
                    if (!(Test-Path -Path $FilePath) -and (!([IO.Path]::GetExtension($FilePath) -eq '.json'))) {
                        Write-Error "File not found or is not a valid json file, check file path and try again"
                        return
                    }

                    #Convert from json into object
                    $RawFile = Get-Content $FilePath -Raw | ConvertFrom-Json
                    $DashboardList += @{
                        file       = $RawFile
                        path       = ""
                        parentid   = $ParentGroupId
                        parentname = $ParentGroupName
                    }
                }
            }

            if ($File) {
                $DashboardList += @{
                    file       = $File | ConvertFrom-Json
                    path       = ""
                    parentid   = $ParentGroupId
                    parentname = $ParentGroupName
                }
            }

            if ($GithubUserRepo) {
                $Headers = @{}
                if ($GithubAccessToken) {
                    $Headers = @{"Authorization" = "token $GithubAccessToken" }
                }
                $Uri = "https://api.github.com/repos/$GithubUserRepo/git/trees/master?recursive=1"
                $RepoData = (Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Headers $Headers[0] -WebSession $Headers[1]).tree | Where-Object { $_.Path -like "*.json" -and $_.Path -notlike "Packages/LogicMonitor_Dashboards*" } | Select-Object path, url
                if ($RepoData) {
                    $TotalItems = ($RepoData | Measure-Object).Count
                    Write-Information "[INFO]: Found $TotalItems JSON files from Github repo ($GithubUserRepo)"
                    foreach ($Item in $RepoData) {
                        $EncodedDash = (Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Item.url -Headers $Headers[0] -WebSession $Headers[1]).content
                        $DashboardList += @{
                            file       = [Text.Encoding]::Utf8.GetString([Convert]::FromBase64String($EncodedDash)) | ConvertFrom-Json
                            path       = [System.IO.Path]::GetDirectoryName($Item.path)
                            parentid   = $ParentGroupId
                            parentname = $ParentGroupName
                        }

                        Write-Information "[INFO]: Successfully downloaded dashboard ($($Item.path)) from Github repo ($GithubUserRepo)"
                    }
                }
            }

            if ($ReplaceAPITokensOnImport -and !($APIToken)) {
                $DashboardAPIRoleName = "lm-dynamic-dashboards"
                $DashboardAPIUserName = "lm_dynamic_dashboards"
                $DashboardAPIRole = Get-LMRole -Name $DashboardAPIRoleName
                $DashboardAPIUser = Get-LMUser -Name $DashboardAPIUserName
                if (!$DashboardAPIRole) {
                    $DashboardAPIRole = New-LMRole -Name $DashboardAPIRoleName -ResourcePermission view -DashboardsPermission manage -Description "Auto provisioned for use with dynamic dashboards"
                    Write-Information "[INFO]: Successfully generated required API role ($DashboardAPIRoleName) for dynamic dashboards"
                }
                if (!$DashboardAPIUser) {
                    $DashboardAPIUser = New-LMAPIUser -Username "$DashboardAPIUserName" -note "Auto provisioned for use with dynamic dashboards" -RoleNames @($DashboardAPIRoleName)
                    Write-Information "[INFO]: Successfully generated required API user ($DashboardAPIUserName) for dynamic dashboards"
                }
                if ($DashboardAPIRole -and $DashboardAPIUser) {
                    $APIToken = New-LMAPIToken -Username $DashboardAPIUserName -Note "Auto provisioned for use with dynamic dashboards"
                    if ($APIToken) {
                        Write-Information "[INFO]: Successfully generated required API token for dynamic dashboards for user: $DashboardAPIUserName"
                    }
                }
                else {
                    Write-Warning "[WARN]: Unable to generate required API token for dynamic dashboards, manually update the required tokens to use dynamic dashboards"
                }
            }

            foreach ($Dashboard in $DashboardList) {
                #Swap apiKeys for dynamic dashboards
                if ($ReplaceAPITokensOnImport) {
                    if ($APIToken) {
                        if ($Dashboard.file.widgetTokens.name -contains "apiKey") {
                            $KeyIndex = $Dashboard.file.widgetTokens.name.toLower().IndexOf("apikey")
                            $Dashboard.file.widgetTokens[$KeyIndex].value = $APIToken.accessKey
                        }
                        if ($Dashboard.file.widgetTokens.name -contains "apiID") {
                            $IdIndex = $Dashboard.file.widgetTokens.name.toLower().IndexOf("apiid")
                            $Dashboard.file.widgetTokens[$IdIndex].value = $APIToken.accessId
                        }
                    }
                }

                #Check if a path has been provided and check if folder exists in selected root folder, if not create
                if ($Dashboard.path) {
                    [Array]$SubFolders = $Dashboard.path -split "\\|/" | Where-Object { $_ }

                    for ($Index = 0; $Index -lt $($SubFolders | Measure-Object).Count; $Index++) {

                        if ($Index -eq 0) {
                            $DashboardGroup = Get-LMDashboardGroup -ParentGroupId $ParentGroupId | Where-Object { $_.Name -eq $SubFolders[$Index] }

                            if (!$DashboardGroup) {
                                Write-Information "[INFO]: Existing dashboard group not found for $($Subfolders[$Index]) creating new resource group under root group ($ParentGroupName)"
                                $NewDashboardGroup = New-LMDashboardGroup -Name $SubFolders[$Index] -ParentGroupId $ParentGroupId
                                $Dashboard.parentid = $NewDashboardGroup.id
                                $Dashboard.parentname = $NewDashboardGroup.name

                            }
                            else {
                                $Dashboard.parentid = $DashboardGroup.id
                                $Dashboard.parentname = $DashboardGroup.name
                            }
                        }
                        else {
                            $DashboardGroup = Get-LMDashboardGroup -Name $Subfolders[$Index] | Where-Object { $_.fullPath -like "$($Subfolders[0])*$($Subfolders[$Index])" }

                            if (!$DashboardGroup) {

                                $NewDashboardParentGroup = Get-LMDashboardGroup -Name $Subfolders[$Index - 1] | Where-Object { $_.fullPath -like "$ParentGroupName*" -or $_.fullPath -eq $Subfolders[$Index - 1] }
                                Write-Information "[INFO]: Existing dashboard group not found for $($Subfolders[$Index]) creating new resource group under group ($($NewDashboardParentGroup.Name))"
                                $NewDashboardGroup = New-LMDashboardGroup -Name $SubFolders[$Index] -ParentGroupId $NewDashboardParentGroup.id

                                $Dashboard.parentid = $NewDashboardGroup.id
                                $Dashboard.parentname = $NewDashboardGroup.name

                            }
                            else {
                                $Dashboard.parentid = $DashboardGroup.id
                                $Dashboard.parentname = $DashboardGroup.name
                            }
                        }
                    }
                }

                #Construct our object for import
                $Data = @{
                    description          = $Dashboard.file.description
                    groupId              = [int]$Dashboard.parentid
                    groupName            = $Dashboard.parentname
                    name                 = $Dashboard.file.name
                    sharable             = if ($PrivateUserName) { $False } else { $True }
                    owner                = $PrivateUserName
                    template             = $Dashboard.file | Select-Object -ExcludeProperty group
                    widgetTokens         = $Dashboard.file.widgetTokens
                    widgetsConfigVersion = $Dashboard.file.widgetsConfigVersion
                }

                #Build header and uri
                $ResourcePath = "/dashboard/dashboards"

                try {
                    $Data = ($Data | ConvertTo-Json -Depth 10)

                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
                    Write-Output "Successfully imported dashboard: $($Dashboard.file.name)"

                    $Results += (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Dashboard" )

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
    end {
        $Results
    }
}