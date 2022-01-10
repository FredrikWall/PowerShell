# Applications

These are my functions for working with Applications.

All functions are stored in a separate .ps1 file.

With an standard example how to use them.

So almost all of the PowerShell files can be runned as they are.
If you just call them like on of the examples.

Get-ExeAppInformation.ps1
------------------
Gets Application information about a .exe file.
Supports ProductName, ProductVersion,CompanyName and Language.

Tested with:
Windows PowerShell 5.1 and PowerShell 7+

![alt text](https://github.com/PowerShellFredrik/PowerShellFunctions/blob/main/Applications/Pictures/Get-ExeAppInformation01.png?raw=true)

Get-InstalledApplications.ps1
------------------
Shows all installed applications or a single installed application on a local computer.

Tested with:
Windows PowerShell 5.1 and PowerShell 7+

![alt text](https://github.com/PowerShellFredrik/PowerShellFunctions/blob/main/Applications/Pictures/Get-InstalledApplications01.png?raw=true)

And It's not problem to use it with an if statement.

![alt text](https://github.com/PowerShellFredrik/PowerShellFunctions/blob/main/Applications/Pictures/Get-InstalledApplications02.png?raw=true)

Get-UninstallString.ps1
------------------
Shows uninstall string/strings for installed application/applications.

Tested with:
Windows PowerShell 5.1 and PowerShell 7+

All uninstall strings

![alt text](https://github.com/PowerShellFredrik/PowerShellFunctions/blob/main/Applications/Pictures/Get-UninstallString01.png?raw=true)

All uninstall strings for Citrix

![alt text](https://github.com/PowerShellFredrik/PowerShellFunctions/blob/main/Applications/Pictures/Get-UninstallString02.png?raw=true)

Uninstall string for Chrome

![alt text](https://github.com/PowerShellFredrik/PowerShellFunctions/blob/main/Applications/Pictures/Get-UninstallString04.png?raw=true)

Invoke-DownloadApplication.ps1
------------------
It's a simple function for downloading applications from the internet.

