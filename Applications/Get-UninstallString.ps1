function Get-UninstallString {
    <#
    .SYNOPSIS
        Get uninstall string(s) from the local computer
    
    .DESCRIPTION
        Retrieves uninstall strings from the Windows registry for installed applications.
        These are the uninstall strings provided by the manufacturer and are typically
        not silent uninstall commands. Searches both 64-bit and 32-bit registry locations.
    
    .PARAMETER ApplicationName
        The application name to search for. Supports wildcard matching.
        If not specified, returns uninstall strings for all installed applications.
    
    .EXAMPLE
        Get-UninstallString
        Displays all uninstall strings for applications on the local computer
    
    .EXAMPLE
        Get-UninstallString -ApplicationName Chrome
        Displays the uninstall string for Chrome if installed on the local computer
    
    .EXAMPLE
        Get-UninstallString -ApplicationName "Microsoft*"
        Displays uninstall strings for all Microsoft applications
    
    .INPUTS
        None. You cannot pipe objects to Get-UninstallString.
    
    .OUTPUTS
        PSCustomObject with DisplayName and UninstallString properties
    
    .NOTES
        Author:  Fredrik Wall
        Email:   wall.fredrik@gmail.com
        Blog:    www.poweradmin.se
        Twitter: @walle75
        Created: 2015-08-01
        Updated: 2025-12-31
        Version: 1.1
        
        Changelog:
        1.1 (2025-12-31) - Updated comment-based help to modern format
        1.0 (2015-08-01) - Initial version
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