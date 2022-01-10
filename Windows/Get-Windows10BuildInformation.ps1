function Get-Windows10BuildInformation {
    <#
        .SYNOPSIS
            Will get information about the OS Build
        .DESCRIPTION
            Will get information about the OS Build from a json file with Windows 10 release information.
            It will provide version, availability date (release date), servicing option and Kb article.
        .PARAMETER OSBuildVersion
            Specifies OS Build number.
            Can handle both 19041.630 and 10.0.19041.630 format.
            Without this parameter It will show local computers OS Build version.
        .PARAMETER Online
            Will open default browser with the Url to the KB article
        .PARAMETER Force
            If Force parameter are provided the file will be downloaded even if the file is already downloaded.
        .EXAMPLE
            C:\PS> Get-Windows10BuildInformation
            Will show information about the local computers OS build version.
        .EXAMPLE
            C:\PS> Get-Windows10BuildInformation -OSBuildVersion "10.0.19041.630"
        .EXAMPLE
            C:\PS> Get-Windows10BuildInformation -OSBuildVersion "19041.630"
        .EXAMPLE
            C:\PS> Get-Windows10BuildInformation -OSBuildVersion "19041.630" -Force
        .NOTES
            NAME:      	Get-Windows10BuildInformation
            AUTHOR:    	Fredrik Wall, fredrik.powershell@gmail.com
            VERSION:    1.1
            CREATED:	19/11/2020
            
            INFO:
            
            The json file is compiled by the author of this function, but information comes from
            https://winreleaseinfoprod.blob.core.windows.net/winreleaseinfoprod/en-US.html

            If you use my Get-Windows10ReleaseInformation function you can create a new and fresh json file.
            And save It as Windows10BuildInformation.json in the same folder as the script.
    #>
    param(
        [cmdletbinding()]
        [Parameter(Mandatory = $false)]
        $OSBuildVersion,
        [Parameter(Mandatory = $false)]
        $Url = "https://raw.githubusercontent.com/FredrikWall/PowerShell/master/Windows/Windows10BuildInformation.json",
        [Parameter(Mandatory = $false)]
        [switch]$Online,
        [Parameter(Mandatory = $false)]
        [switch]$Force
    )
    
    if ($Force) {
        Invoke-WebRequest -Uri $Url -OutFile "$PSScriptRoot\Windows10BuildInformation.json"
    }
    else {
        if (-not (Test-Path "$PSScriptRoot\Windows10BuildInformation.json")) {
            Invoke-WebRequest -Uri $Url -OutFile "$PSScriptRoot\Windows10BuildInformation.json"    
        }
    }

    $Windows10OSBuildInfo = Get-Content -Raw "$PSScriptRoot\Windows10BuildInformation.json" | ConvertFrom-Json

    if ($null -eq $OSBuildVersion) {
        $CurrentBuild = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild
        $UBR = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").UBR
        $OSBuildVersion = "$CurrentBuild.$UBR"
    }
    else {
        $OSBuildVersion = $OSBuildVersion
    }

    if (($OSBuildVersion.split(".")).Count -eq 2) {
        $OSBuildVersion = $OSBuildVersion
    }

    if (($OSBuildVersion.split(".")).Count -eq 4) {
        $OSBuildVersion = "$(($OSBuildVersion.split(".")[2])).$(($OSBuildVersion.split(".")[3]))"
    }

    if (-not ($Windows10OSBuildInfo | Where-Object { $_.'OS build' -match $OSBuildVersion })) {
        $OSBuildVersion = $null
        Return $OSBuildVersion
    }
    else {
        $MyWindows10BuildInfo = $Windows10OSBuildInfo | Where-Object { $_.'OS build' -match $OSBuildVersion }

        if ($Online) {
            $KB = ($MyWindows10BuildInfo.'Kb article').Replace("KB ", "")
            Start-Process "https://support.microsoft.com/help/$KB"
        }

        Return $MyWindows10BuildInfo

    }
}