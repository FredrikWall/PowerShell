function Disable-ShowHiddenFiles {
<#
    .SYNOPSIS
        Disabels Show Hidden Files, Folders and Drives in Windows
    .DESCRIPTION
        Disabels Show Hidden Files, Folders and Drives in Windows on the current user
    .EXAMPLE
        C:\PS> Disable-ShowHiddenFiles
    .NOTES
        NAME:       Disable-ShowHiddenFiles
        AUTHOR:     Fredrik Wall, fredrik.powershell@gmail.com
        VERSION:    1.0
        CREATED:    12/27/2021
#>
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -Value "2"
}