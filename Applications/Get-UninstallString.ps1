function Get-UninstallString {
    <#
        .SYNOPSIS
            Get uninstall string/strings from the local computer
        .DESCRIPTION
            Get uninstall string/strings from the local computer.
            These are the uninstall strings from the manufacturer.
            Most of the time they are not silent.
        .PARAMETER ApplicationName
            The application you want to get the uninstall string to
        .EXAMPLE
            C:\PS> Get-UninstallString
            Will show all uninstall strings on the local computer
        .EXAMPLE
            C:\PS> Get-UninstallString -ApplicationName Chrome
            Will show the uninstall string for Chrome if Chrome is installed on the local computer            
        .NOTES
            NAME:      	Get-UninstallString
            AUTHOR:    	Fredrik Wall, fredrik.powershell@gmail.com
            VERSION:    1.0
            CREATED:	08/01/2015
    #>
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory = $false)]
        $ApplicationName
    )

    if ($ApplicationName) {
        Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Select-Object DisplayName, UninstallString | Where-Object -Property DisplayName -match $ApplicationName | Sort-Object -Property DisplayName
        Get-ChildItem HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Select-Object DisplayName, UninstallString | Where-Object -Property DisplayName -match $ApplicationName | Sort-Object -Property DisplayName
    }
    else {
        Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Select-Object DisplayName, UninstallString | Where-Object -Property DisplayName -ne $null | Sort-Object -Property DisplayName
        Get-ChildItem HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Select-Object DisplayName, UninstallString | Where-Object -Property DisplayName -ne $null | Sort-Object -Property DisplayName
    }
}
Get-UninstallString -ApplicationName Chrome