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
            VERSION:    1.1
            CREATED:	08/03/2015
            UPDATED:    26/12/2024
    #>
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory = $false)]
        $ApplicationName
    )

    $uninstallPaths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    )

    foreach ($path in $uninstallPaths) {
        Get-ChildItem $path | Get-ItemProperty | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Where-Object {
            if ($ApplicationName) {
                $_.DisplayName -match $ApplicationName
            } else {
                $null -ne $_.DisplayName
            }
        } | Sort-Object -Property DisplayName
    }
}AC
