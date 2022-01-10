function Get-InstalledApplications {
    <#
        .SYNOPSIS
            Get installed applications from the local computer
        .DESCRIPTION
            Get installed applications from the local computer
        .PARAMETER ApplicationName
            The application you want to get information about
        .EXAMPLE
            C:\PS> Get-InstalledApplications
            Will show all installed applications on the local computer
        .EXAMPLE
            C:\PS> Get-InstalledApplications -ApplicationName Chrome
            Will show the information about Chrome if it is installed on the local computer            
        .NOTES
            NAME:      	Get-InstalledApplications
            AUTHOR:    	Fredrik Wall, fredrik.powershell@gmail.com
            VERSION:    1.0
            CREATED:	08/03/2015
    #>
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory = $false)]
        $ApplicationName
    )

    if ($ApplicationName) {
        Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Where-Object -Property DisplayName -match $ApplicationName | Sort-Object -Property DisplayName
        Get-ChildItem HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Where-Object -Property DisplayName -match $ApplicationName | Sort-Object -Property DisplayName
    }
    else {
        Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Where-Object -Property DisplayName -ne $null | Sort-Object -Property DisplayName
        Get-ChildItem HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Where-Object -Property DisplayName -ne $null | Sort-Object -Property DisplayName
    }
}
if (-not(Get-InstalledApplications -ApplicationName "Nisses Application")) {
    Write-Output "Application not installed"
    Install-Application
}
