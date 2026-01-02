function Invoke-DownloadPackagingTools {
    <#
    .SYNOPSIS
        Download application packaging tools and helper scripts
    
    .DESCRIPTION
        Downloads essential tools and PowerShell scripts for application packaging to a specified
        directory. This includes the Microsoft Intune Win32 Content Prep Tool and various helper
        scripts for working with EXE and MSI files (Get-ExeAppInformation, Get-MSIAppInformation,
        Get-InstalledApplications, Get-UninstallString). The function creates the necessary folder
        structure and skips downloads if files already exist.
    
    .PARAMETER DestinationPath
        The local path where the tools and scripts will be downloaded. The function will create
        subdirectories for organization (IntuneWinAppUtil, Functions, etc.). This parameter is
        mandatory.
    
    .EXAMPLE
        Invoke-DownloadPackagingTools -DestinationPath "C:\ApplicationPackaging\Tools"
        Downloads all packaging tools to C:\ApplicationPackaging\Tools
    
    .EXAMPLE
        Invoke-DownloadPackagingTools -DestinationPath "C:\Tools" -Verbose
        Downloads all packaging tools with verbose output showing download progress
    
    .EXAMPLE
        Invoke-DownloadPackagingTools -DestinationPath "$env:USERPROFILE\PackagingTools"
        Downloads all packaging tools to the PackagingTools folder in the user profile
    
    .INPUTS
        None. You cannot pipe objects to Invoke-DownloadPackagingTools.
    
    .OUTPUTS
        System.String. The function outputs a success message indicating where tools were installed.
    
    .NOTES
        Author:  Fredrik Wall
        Email:   wall.fredrik@gmail.com
        Blog:    www.poweradmin.se
        Twitter: @walle75
        Created: 2025-12-31
        Updated: 2026-01-02
        Version: 1.1
        
        Changelog:
        1.1 (2026-01-02) - Added comment based help, improved error handling, added folder structure creation
        1.0 (2025-12-31) - Initial version with IntuneWinAppUtil and helper scripts
        
        Tools Downloaded:
        - Microsoft Intune Win32 Content Prep Tool (IntuneWinAppUtil.exe)

        Functions Downloaded:
        - Get-ExeAppInformation.ps1
        - Get-MSIAppInformation.ps1
        - Get-InstalledApplications.ps1
        - Get-UninstallString.ps1
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DestinationPath
    )

    # Microsoft Win32 Content Prep Tool
    $contentPrepToolUrl = "https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/blob/master/IntuneWinAppUtil.exe"

    $foldersToCreate = @(
        $DestinationPath,
        "$DestinationPath\IntuneWinAppUtil",
        "$DestinationPath\Functions",
        "$DestinationPath\ExeApplicationInformationTool",
        "$DestinationPath\MsiApplicationInformationTool"
    )
    foreach ($folder in $foldersToCreate) {
        if (-not (Test-Path -Path $folder -PathType Container)) {   
            Write-Verbose "Creating folder: $folder"
            New-Item -Path $folder -ItemType Directory -Force | Out-Null
        }   
    }    

    try {
        if (Test-Path -Path "$DestinationPath\IntuneWinAppUtil\IntuneWinAppUtil.exe") {
            Write-Verbose "Intune Win32 Content Prep Tool already exists at '$DestinationPath'. Skipping download."
        } else {

            Write-Verbose "Downloading Intune Win32 Content Prep Tool..."
            Invoke-WebRequest -Uri $contentPrepToolUrl -OutFile "$DestinationPath\IntuneWinAppUtil\IntuneWinAppUtil.exe"
            Write-Verbose "Intune Win32 Content Prep Tool downloaded successfully."
        }
    }
    catch {
        throw "Failed to download Intune Win32 Content Prep Tool: $_"
    }
    
    # Get-ExeAppInformation
    $GetExeAppInfoUrl = "https://raw.githubusercontent.com/FredrikWall/PowerShell/refs/heads/master/Applications/Get-ExeAppInformation.ps1"

    try {
        if (Test-Path -Path "$DestinationPath\Functions\Get-ExeAppInformation.ps1") {
            Write-Verbose "Get-ExeAppInformation already exists at '$DestinationPath'. Skipping download."
        } else {
            Write-Verbose "Downloading Get-ExeAppInformation script..."
            Invoke-WebRequest -Uri $GetExeAppInfoUrl -OutFile "$DestinationPath\Functions\Get-ExeAppInformation.ps1"
            Write-Verbose "Get-ExeAppInformation script downloaded successfully."
        }
    }
    catch {
        throw "Failed to download Get-ExeAppInformation script: $_"
    }
    
    # Get-MSIAppInformation
    $GetMSIAppInfoUrl = "https://raw.githubusercontent.com/FredrikWall/PowerShell/refs/heads/master/Applications/Get-MSIAppInformation.ps1"

    try {
        if (Test-Path -Path "$DestinationPath\Functions\Get-MSIAppInformation.ps1") {
            Write-Verbose "Get-MSIAppInformation already exists at '$DestinationPath'. Skipping download."
        } else {
            Write-Verbose "Downloading Get-MSIAppInformation script..."
            Invoke-WebRequest -Uri $GetMSIAppInfoUrl -OutFile "$DestinationPath\Functions\Get-MSIAppInformation.ps1"
            Write-Verbose "Get-MSIAppInformation script downloaded successfully."
        }
    }
    catch {
        throw "Failed to download Get-MSIAppInformation script: $_"
    }

    # Get-InstalledApplications
    $GetInstalledAppsUrl = "https://raw.githubusercontent.com/FredrikWall/PowerShell/refs/heads/master/Applications/Get-InstalledApplications.ps1"

    try {
        if (Test-Path -Path "$DestinationPath\Functions\Get-InstalledApplications.ps1") {
            Write-Verbose "Get-InstalledApplications already exists at '$DestinationPath'. Skipping download."
        } else {
            Write-Verbose "Downloading Get-InstalledApplications script..."
            Invoke-WebRequest -Uri $GetInstalledAppsUrl -OutFile "$DestinationPath\Functions\Get-InstalledApplications.ps1"
            Write-Verbose "Get-InstalledApplications script downloaded successfully."
        }
    }
    catch {
        throw "Failed to download Get-InstalledApplications script: $_"
    }

    # Get-UninstallString
    $GetUninstallStringUrl = "https://raw.githubusercontent.com/FredrikWall/PowerShell/refs/heads/master/Applications/Get-UninstallString.ps1"

    try {
        if (Test-Path -Path "$DestinationPath\Functions\Get-UninstallString.ps1") {
            Write-Verbose "Get-UninstallString already exists at '$DestinationPath'. Skipping download."
        } else {
            Write-Verbose "Downloading Get-UninstallString script..."
            Invoke-WebRequest -Uri $GetUninstallStringUrl -OutFile "$DestinationPath\Functions\Get-UninstallString.ps1"
            Write-Verbose "Get-UninstallString script downloaded successfully."
        }
    }
    catch {
        throw "Failed to download Get-UninstallString script: $_"
    }


    Write-Output "Application Packaging Tools installed successfully at '$DestinationPath'."
}