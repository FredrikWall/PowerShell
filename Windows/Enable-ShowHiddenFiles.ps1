function Enable-ShowHiddenFiles {
    <#
    .SYNOPSIS
        Enabels Show Hidden Files, Folders and Drives in Windows
    .DESCRIPTION
        Enabels Show Hidden Files, Folders and Drives in Windows
    .EXAMPLE
        C:\PS> Enable-ShowHiddenFiles
    .NOTES
        NAME:       Enable-ShowHiddenFiles
        AUTHOR:     Fredrik Wall, fredrik.powershell@gmail.com
        VERSION:    1.0
        CREATED:    12/27/2021
#>
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -Value "1"
}