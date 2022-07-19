function Disable-ShowKnownFileExtension {
<#
    .SYNOPSIS
        Disabels Show Known File Extension in Windows
    .DESCRIPTION
        Disabels Show Known File Extension in Windows on the current user
    .EXAMPLE
        C:\PS> Disable-ShowKnownFileExtension
    .NOTES
        NAME:       Disable-ShowKnownFileExtension
        AUTHOR:     Fredrik Wall, fredrik.powershell@gmail.com
        VERSION:    1.0
        CREATED:    12/27/2021
#>
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Value "1"
}