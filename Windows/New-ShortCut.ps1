function New-Shortcut {
    <#
        .SYNOPSIS
            Creates new Shotcut
        .DESCRIPTION
            Creates new Shotcut
        .PARAMETER Source
            The path to the file you want to create shortcut to
        .PARAMETER Destination
            The path to the shortcut file
        .PARAMETER Icon
            The path to a icon file.
            This is not manadatory. Will use the standard icon if not used.
        .PARAMETER Description
            Description
        .PARAMETER WorkingDirectory
            Working Directory
        .PARAMETER WindowStyle
            If not used Normal will be used as default.
            You can use Normal, Minimised or Maximised.
        .PARAMETER Force
            This will delete old shortcut file if destination is the same path as an existing shortcut file.
        .EXAMPLE
            C:\PS> New-Shortcut -Source "$env:WinDir\system32\notepad.exe" -Destination "$env:Public\Desktop\Notepad.lnk"
            Will create a shortcut to notepad on All Users Desktop with standard icon.
        .EXAMPLE
            C:\PS> New-Shortcut -Source "$env:WinDir\system32\notepad.exe" -Destination "$env:Public\Desktop\Notepad.lnk" -WindowStyle Maximised
            Will create a shortcut to notepad on All Users Desktop with standard icon and set to open Maximised.
        .EXAMPLE
            C:\PS> New-Shortcut -Source "C:\Windows\System32\WindowsPowerShell\v1.0\powerShell.exe" -Destination "$env:Public\Desktop\EXE Application Information.lnk" -Arguments "C:\Scripts\ExeApplicationInformation.ps1" -WindowStyle Minimised
            Will create a shortcut to PowerShell on All Users Desktop with the path to ExeApplicationInformation.ps1 as an argument and start PowerShell minimised so the PowerShell application shows without the PowerShell console.
        .EXAMPLE
            C:\PS> New-Shortcut -Source "C:\Windows\System32\WindowsPowerShell\v1.0\powerShell.exe" -Destination "$env:Public\Desktop\EXE Application Information.lnk" -Arguments "C:\Scripts\ExeApplicationInformation.ps1" -WindowStyle Minimised -Icon "C:\Scripts\myicon.ico" -Force
            Will create a shortcut to PowerShell on All Users Desktop with the path to ExeApplicationInformation.ps1 as an argument and start PowerShell minimised so the PowerShell application shows without the PowerShell console.
            Plus changes the default PowerShell icon to another one.
        .NOTES
            NAME:      	New-Shortcut
            AUTHOR:    	Fredrik Wall, fredrik.powershell@gmail.com
            VERSION:    1.0
            CREATED:	07/03/2012
    #>
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory)]
        $Source,
        [Parameter(Mandatory)]
        $Destination,
        [Parameter()]
        $Icon,
        [Parameter()]
        $Description,
        [Parameter()]
        $WorkingDirectory,
        [Parameter()]
        [ValidateSet('Normal', 'Minimised', 'Maximised')]
        $WindowStyle,
        [Parameter()]
        $Arguments,
        [Parameter()]
        [Switch]$Force
    )


    IF ($Force) {
        if (Test-Path $Destination) {
            Remove-Item $Destination -Force
        }
    }

    $WshShell = New-Object -ComObject WScript.shell
    $Shortcut = $WshShell.CreateShortcut($Destination)
    $Shortcut.TargetPath = $Source

    if ($Icon) {
        $Shortcut.Iconlocation = $Icon
    }

    if ($Description) {
        $Shortcut.Description = $Description
    }

    if ($WorkingDirectory) {
        $Shortcut.WorkingDirectory = $WorkingDirectory
    }

    if ($WindowStyle) {
        switch ($WindowStyle) {
            "Normal" {
                [int]$WindowStyle = 1
            }
            "Minimised" {
                [int]$WindowStyle = 7
            }
            "Maximised" {
                [int]$WindowStyle = 3
            }
        }
        $Shortcut.WindowStyle = [int]$WindowStyle
    }

    if ($Arguments) {
        $Shortcut.Arguments = $Arguments
    }

    $Shortcut.Save() 

    $WshShell = $null
    $Icon = $null
    $Description = $null
    $Arguments = $null
}