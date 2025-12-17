# PSAppDeployToolkit CheatSheet

This is a CheatSheet for PSAppDeployToolkit v4.1.x, <https://psappdeploytoolkit.com/>

Author: Fredrik Wall  
Created: 2025-11-01  
Updated: 2025-12-04  
Version: 1.5  

## Table of Contents

- [PSAppDeployToolkit CheatSheet](#psappdeploytoolkit-cheatsheet)
  - [Table of Contents](#table-of-contents)
  - [Quick Start](#quick-start)
  - [Import PSAppDepolyToolkit for IntelliSense (VSCode)](#import-psappdepolytoolkit-for-intellisense-vscode)
  - [PSAppDeployToolkit variabels](#psappdeploytoolkit-variabels)
    - [ADTSession variables](#adtsession-variables)
    - [Variables](#variables)
    - [Environment Variables](#environment-variables)
  - [Invoke-AppDeployToolkit](#invoke-appdeploytoolkit)
    - [Install an EXE](#install-an-exe)
    - [Install an EXE with hidden window](#install-an-exe-with-hidden-window)
    - [Install an MSI](#install-an-msi)
    - [Install an MSI with a MST (transforms) file](#install-an-msi-with-a-mst-transforms-file)
    - [Install an MSP (patch)](#install-an-msp-patch)
    - [Uninstall an MSI](#uninstall-an-msi)
    - [Uninstall with an EXE](#uninstall-with-an-exe)
    - [Remove Desktop Shortcut from all users desktop](#remove-desktop-shortcut-from-all-users-desktop)
    - [Copy files from DirSupportFiles](#copy-files-from-dirsupportfiles)
    - [Copy settings file to all users profile](#copy-settings-file-to-all-users-profile)
    - [Remove Registry key](#remove-registry-key)
    - [Create a custom application key for detection purposes](#create-a-custom-application-key-for-detection-purposes)
    - [Remove custom application key](#remove-custom-application-key)
    - [Custom message at the end of the installation](#custom-message-at-the-end-of-the-installation)

## Quick Start

This is a Quick Start to be able to do a PSAppDeployToolkit package in a couple of minutes.  
I uselly set up a structure with template/s.

Download the file **PSAppDeployToolkit_Template_v4.zip** from the latest Release on  
<https://github.com/psappdeploytoolkit/psappdeploytoolkit>

Unpack the zip file to a folder and then you need to unblock all files  
in the folder. If you does not do this you can encounter strange issues.

```powershell
Get-ChildItem -Path "C:\Your\Folder" -Recurse | Unblock-File
```

## Import PSAppDepolyToolkit for IntelliSense (VSCode)

An easy way to have access to PSAppDeployToolkit cmdlets, variables and help is to Import PSAppDeployToolkit in VSCode.  
This is very easy and Torsten Rywelski have written a nice blog post about it here: <https://shiftavenue.com/en/articles/psadt-scripting-with-visualstudio-code>

I have just copyed the 2 PSAppDeployToolkit folders to a PSAppDeployToolkit folder in the module folder.  
C:\Program Files\WindowsPowerShell\Modules\PSAppDeployToolkit and unblocked all files.

And then I just run his code (with the new path) every time I need it.

```powershell
try { 
    # Import PSAppDepolyToolkit for IntelliSense 
    Import-Module "C:\Program Files\WindowsPowerShell\Modules\PSAppDeployKit\PSAppDeployToolkit\PSAppDeployToolkit.psd1" 
    # Import PSAppDepolyToolkit.Extensions for IntelliSense (Only if CustomExtensions are present) 
    Import-Module "C:\Program Files\WindowsPowerShell\Modules\PSAppDeployKit\PSAppDeployToolkit.Extensions\PSAppDeployToolkit.Extensions.psd1" 
} 
catch {} 
try { 
    # Initialize ADT Module 
    Initialize-ADTModule -ScriptDirectory $psscriptroot 
    (Get-ADTConfig).Toolkit.RequireAdmin = $false 
    Export-ADTEnvironmentTableToSessionState -SessionState $ExecutionContext.SessionState 
    $adtSession = [System.Collections.Generic.List[PSADT.Module.DeploymentSession]]::new() 
} 
catch {} 

Clear-Host
```

## PSAppDeployToolkit variabels

There are several PSAppDeployToolkit variabels that are really nice to have when doing a PSAppDeployToolkit application package.  
And for v4.1 there are a new structure for this.  
All of them can be found here <https://psappdeploytoolkit.com/docs/reference/variables> and here <https://psappdeploytoolkit.com/docs/reference/adtsession-object>.

I will list the most common used PSAppDeployToolkit variabels.

### ADTSession variables

The ADTSession object is a core component of PSAppDeployToolkit, managing the state and information throughout a deployment session. It gathers essential details about the deployment environment and provides convenient properties and methods for use in scripts.

| Property | Description | Example |
|----------|-------------|---------|
| DirFiles | PathPath to the "Files" directory used by the toolkit | $($adtSession.DirFiles) |
| DirSupportFiles | PathPath to the "SupportFiles" directory used by the toolkit | $($adtSession.DirSupportFiles) |
| AppVendor | The vendor of the application | $($adtSession.AppVendor) |  
| AppName | The name of the application | $($adtSession.AppName) |
| AppVersion | The name of the application | $($adtSession.AppName) |
| AppArch | The architecture (e.g., x86, x64) of the application | $($adtSession.AppArch) |  

### Variables

When you open an ADTSession (automatically handled in Invoke-AppDeployToolkit.ps1), several useful variables are created. These include hardware information, system and user paths, and Active Directory domain details, among others.

### Environment Variables

| Variable | Description |
|----------|-------------|
| $envAllUsersProfile | %ALLUSERSPROFILE%, e.g. C:\ProgramData |
| $envCommonDesktop | C:\Users\Public\Desktop |
| $envCommonStartMenu | C:\ProgramData\Microsoft\Windows\Start Menu |
| $envProgramData | %PROGRAMDATA%, e.g. C:\ProgramData |
| $envProgramFiles | %PROGRAMFILES%, e.g. C:\Program Files |
| $envProgramFilesX86 | %ProgramFiles(x86)%, e.g. C:\Program Files (x86) (Only on 64 bit. Used to store 32 bit apps.) |

## Invoke-AppDeployToolkit

### Install an EXE

It will start the setup.exe file with the parameter /s, this may be different from setup to setup.  
The file should be in the Files folder in the PSAppDeployToolkit structure.

```powershell
Start-ADTProcess -FilePath 'setup.exe' -ArgumentList '/s'
```

If you have the setup file in a own folder in the Files folder you can use the DirFiles variable.

```powershell
Start-ADTProcess -FilePath "$($adtSession.DirFiles)\<ApplicationName>\setup.exe" -ArgumentList '/s'
```

### Install an EXE with hidden window

It will start the setup.exe file with the parameter /s, this may be different from setup to setup.  
This uses the WindowsStyle parameter for those setups that starts a cmd window or similar to do things.

The file should be in the Files folder in the PSAppDeployToolkit structure.

```powershell
Start-ADTProcess -FilePath 'setup.exe' -ArgumentList '/s' -WindowStyle 'Hidden'
```

If you have the setup file in a own folder in the Files folder you can use the DirFiles variable.

```powershell
Start-ADTProcess -FilePath "$($adtSession.DirFiles)\<ApplicationName>\setup.exe" -ArgumentList '/s'
```

### Install an MSI

It will start the setup.msi file with the parameter /QN.  
The file should be in the Files folder in the PSAppDeployToolkit structure.

```powershell
Start-ADTMsiProcess -Action 'Install' -FilePath 'setup.msi' -ArgumentList '/QN'
```

If you have the setup file in a own folder in the Files folder you can use the DirFiles variable.

```powershell
Start-ADTMsiProcess -Action 'Install' -FilePath "$($adtSession.DirFiles)\<ApplicationName>\setup.msi" -ArgumentList '/QN'
```

### Install an MSI with a MST (transforms) file

It will start the setup.msi file the transforms file setup.mst and with the parameter /QN.  
The file should be in the Files folder in the PSAppDeployToolkit structure.

```powershell
Start-ADTMsiProcess -Action 'Install' -FilePath 'setup.msi' -Transforms 'setup.mst' -ArgumentList '/QN'
```

If you have the setup file and the transforms file in a own folder in the Files folder you can use the DirFiles variable.

```powershell
Start-ADTMsiProcess -Action 'Install' -FilePath "$($adtSession.DirFiles)\<ApplicationName>\setup.msi" -Transforms "$($adtSession.DirFiles)\<ApplicationName>\setup.mst" -ArgumentList '/QN'
```

### Install an MSP (patch)

It will start the patch.msp file.
The file should be in the Files folder in the PSAppDeployToolkit structure.

```powershell
Start-ADTMspProcess -FilePath 'patch.msp'
```

If you have the patch file in a own folder in the Files folder you can use the DirFiles variable.

```powershell
Start-ADTMspProcess -FilePath "$($adtSession.DirFiles)\<ApplicationName>\patch.msp"
```

### Uninstall an MSI

```powershell
Uninstall-ADTApplication -Name '<ApplicationName>'
```

### Uninstall with an EXE

This will use the uninstaller.exe from the Files folder in the package.

```powershell
Start-ADTProcess -FilePath 'uninstaller.exe' -ArgumentList '/S' -WindowStyle 'Hidden'
```

This will use the same uninstaller but will do a check if the application is instaalled first

```powershell
if (Get-ADTApplication -Name '<ApplicationName>') {
    Start-ADTProcess -FilePath 'uninstaller.exe' -ArgumentList '/S' -WindowStyle 'Hidden'
}
```

And if we want to check if an uninstaller is present localy we can do like this:

```powershell
if (Test-Path -Path "C:\Program Files\<ApplicationName>\uninstall.exe") {
    Start-ADTProcess -FilePath "C:\Program Files\<ApplicationName>\uninstall.exe" -ArgumentList '/S' -WindowStyle 'Hidden'
}
```

### Remove Desktop Shortcut from all users desktop

```powershell
Remove-ADTFile -path "C:\Users\Public\Desktop\<ApplicationName>.lnk"
```

### Copy files from DirSupportFiles

Copy all files from SupportFiles to a specific path

```powershell
Copy-ADTFile -Path "$($adtSession.DirSupportFiles)\*" -Destination "C:\some\random\file\path"
```

### Copy settings file to all users profile

Copy global.ini to AppData\Roaming\<ApplicationName> in all user profiles

```powershell
Copy-ADTFileToUserProfiles -Path "$($adtSession.DirSupportFiles)\global.ini" -Destination "AppData\Roaming\<ApplicationName>" -Recurse
```

### Remove Registry key

When working with application packages we often run in to old packages that have information or detection rules in the registry  
that we want to remove.

This is a simple way to do it.

```powershell
Remove-ADTRegistryKey -Path "HKEY_LOCAL_MACHINE\SOFTWARE\<CompanyName>\Applications\<ApplicationNameOrGUID>"
```

### Create a custom application key for detection purposes

To create a simple detection rule in the registry we can do like this.

```powershell
# Change <CustomerName> to your organization name or similar
$CustomerName = "<CustomerName>"

# Change the key name as needed
$CustomKeyName = "$($adtSession.AppVendor)_$($adtSession.AppName)_$($adtSession.AppVersion)_$($adtSession.AppArch)"

# Create the registry key indicating the application is installed
# Path : HKEY_LOCAL_MACHINE\SOFTWARE\<CustomerName>\Applications\<CustKeyName>
Set-ADTRegistryKey -LiteralPath "HKEY_LOCAL_MACHINE\SOFTWARE\$($CustomerName)\Applications\$($CustomKeyName)" -Name 'Installed' -Type 'DWord' -Value '1'
```

### Remove custom application key

When uninstalling a application package that have created a custom detection rule we want to remove it.

```powershell
# Change <CustomerName> to your organization name or similar
$CustomerName = "<CustomerName>"
$CustomKeyName = "$($adtSession.AppVendor)_$($adtSession.AppName)_$($adtSession.AppVersion)_$($adtSession.AppArch)"
Remove-ADTRegistryKey -Path "HKEY_LOCAL_MACHINE\SOFTWARE\$($CustomerName)\Applications\$($CustomKeyName)"
```

### Custom message at the end of the installation

There are a message at the end of the installation as default.  
But you need to change the message for every package as default.  

In this way we get a message that sayes "Installation of `<AppVendor>` `<AppName>` `<AppVersion>` is complete. every time without changing anything.

```powershell
if (!$adtSession.UseDefaultMsi)
{
    $CustomName = "$($adtSession.AppVendor) $($adtSession.AppName) $($adtSession.AppVersion)"
    Show-ADTInstallationPrompt -Message "Installation of $($CustomName) is complete." -ButtonRightText 'OK' -Icon Information -NoWait
}
```
