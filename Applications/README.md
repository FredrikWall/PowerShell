# Application Management Functions

A collection of PowerShell functions for managing, querying, and downloading Windows applications. These functions provide simplified interfaces for working with application metadata, registry information, and installation packages.

## Overview

This module contains utility functions for application management tasks including extracting version information from EXE and MSI files, querying installed applications, retrieving uninstall strings, and downloading applications from the internet. All functions support modern PowerShell features including pipeline input and structured object output.

## Prerequisites

- PowerShell 3.0 or higher (tested with Windows PowerShell 5.1 and PowerShell 7+)
- Windows operating system
- Administrator rights may be required for certain registry operations
- For MSI functions: Windows Installer COM automation interface

## Functions

### Get-ExeAppInformation

Extracts application metadata from EXE files using the FileVersionInfo API.

**Syntax:**
```powershell
Get-ExeAppInformation -Path <String> [-Property <String[]>]
```

**Parameters:**
- `Path` - Path to the EXE file (supports pipeline input)
- `Property` - Optional. One or more properties to retrieve: ProductName, ProductVersion, CompanyName, Language

**Examples:**
```powershell
# Get all properties from an EXE file
Get-ExeAppInformation -Path "JavaSetup8u144.exe"

# Get specific properties
Get-ExeAppInformation -Path "JavaSetup8u144.exe" -Property ProductName,ProductVersion

# Pipeline support
"JavaSetup8u144.exe" | Get-ExeAppInformation

# Get only ProductName
Get-ExeAppInformation -Path "MyApp.exe" -Property ProductName
```

**Features:**
- Reads FileVersionInfo metadata without executing the file
- Returns PSCustomObject for easy property access
- Pipeline-friendly for bulk operations
- Supports multiple properties in a single call
- Comprehensive error handling

**Output Properties:**
- Path - The file path that was queried
- ProductName - The product name from version info
- ProductVersion - The product version string
- CompanyName - The company/publisher name
- Language - The language of the application

---

### Get-InstalledApplications

Retrieves installed applications from Windows registry uninstall keys.

**Syntax:**
```powershell
Get-InstalledApplications [-ApplicationName <String>] [-ExactMatch]
```

**Parameters:**
- `ApplicationName` - Optional. Regex or substring to match against DisplayName (supports pipeline input)
- `ExactMatch` - Switch. Use exact (case-insensitive) matching instead of regex

**Examples:**
```powershell
# Get all installed applications
Get-InstalledApplications

# Search for specific application
Get-InstalledApplications -ApplicationName Chrome

# Pipeline support
'Adobe' | Get-InstalledApplications

# Exact match
Get-InstalledApplications -ApplicationName "Google Chrome" -ExactMatch

# Use in conditional statements
if (Get-InstalledApplications -ApplicationName "7-Zip") {
    Write-Host "7-Zip is installed"
}
```

**Features:**
- Queries both 64-bit and 32-bit (WOW6432Node) registry locations
- De-duplicates entries that appear in multiple registry hives
- Returns structured PSCustomObject with all registry properties
- Regex support for flexible application name matching
- Pipeline-friendly for bulk queries

**Output Properties:**
- DisplayName - Application display name
- DisplayVersion - Version string
- Publisher - Software publisher/vendor
- InstallDate - Installation date (if available)
- UninstallString - Uninstall command
- InstallLocation - Installation directory
- And other registry properties as available

**Screenshots:**

![Get-InstalledApplications Example](https://github.com/PowerShellFredrik/PowerShellFunctions/blob/main/Applications/Pictures/Get-InstalledApplications01.png?raw=true)

![Get-InstalledApplications with If Statement](https://github.com/PowerShellFredrik/PowerShellFunctions/blob/main/Applications/Pictures/Get-InstalledApplications02.png?raw=true)

---

### Get-MSIAppInformation

Reads properties from MSI (Windows Installer) database files.

**Syntax:**
```powershell
Get-MSIAppInformation -FilePath <String> [-Property <String[]>]
```

**Parameters:**
- `FilePath` - Path to the MSI file (supports pipeline input, aliases: Path)
- `Property` - Optional. One or more MSI property names to retrieve (e.g., ProductName, ProductVersion, ProductCode)

**Examples:**
```powershell
# Get all properties from an MSI
Get-MSIAppInformation -FilePath 'C:\temp\MyApp.msi'

# Get specific property
Get-MSIAppInformation -FilePath 'C:\temp\MyApp.msi' -Property ProductName

# Get multiple properties (returns aggregated object)
Get-MSIAppInformation -FilePath 'C:\temp\MyApp.msi' -Property ProductName,ProductVersion,ProductCode

# Pipeline support
'C:\temp\MyApp.msi' | Get-MSIAppInformation

# Get product version from multiple MSI files
Get-ChildItem C:\Downloads\*.msi | Get-MSIAppInformation -Property ProductVersion
```

**Features:**
- Direct COM access to MSI database
- No installation required to read MSI properties
- Proper COM object cleanup and resource management
- Returns individual or aggregated PSCustomObjects
- Pipeline support for batch processing
- Works with FileInfo objects or string paths

**Common MSI Properties:**
- ProductName - Product display name
- ProductVersion - Product version
- ProductCode - Unique product GUID
- Manufacturer - Software publisher
- ProductLanguage - Language code
- UpgradeCode - Product family GUID

**Return Behavior:**
- No `-Property`: Streams all MSI properties as individual objects
- Single `-Property`: Returns one object with that property
- Multiple `-Property`: Returns one aggregated object with all requested properties

---

### Get-UninstallString

Retrieves uninstall command strings from the Windows registry.

**Syntax:**
```powershell
Get-UninstallString [-ApplicationName <String>]
```

**Parameters:**
- `ApplicationName` - Optional. Application name to filter results (regex matching)

**Examples:**
```powershell
# Get all uninstall strings
Get-UninstallString

# Get uninstall strings for specific application
Get-UninstallString -ApplicationName Chrome

# Get all Citrix uninstall strings
Get-UninstallString -ApplicationName Citrix

# Use uninstall string in automation
$uninstall = (Get-UninstallString -ApplicationName "7-Zip").UninstallString
```

**Features:**
- Queries both 64-bit and 32-bit registry uninstall locations
- Returns manufacturer-provided uninstall commands
- Sorted by DisplayName for easy reading
- Regex support for flexible filtering
- Useful for application removal automation

**Output Properties:**
- DisplayName - Application name
- UninstallString - Command to uninstall the application

**Important Notes:**
- Uninstall strings are typically **not silent** by default
- May require additional parameters for silent uninstallation
- Some uninstall strings may require administrator privileges
- Test uninstall commands before automation

**Screenshots:**

![All Uninstall Strings](https://github.com/PowerShellFredrik/PowerShellFunctions/blob/main/Applications/Pictures/Get-UninstallString01.png?raw=true)

![Citrix Uninstall Strings](https://github.com/PowerShellFredrik/PowerShellFunctions/blob/main/Applications/Pictures/Get-UninstallString02.png?raw=true)

![Chrome Uninstall String](https://github.com/PowerShellFredrik/PowerShellFunctions/blob/main/Applications/Pictures/Get-UninstallString04.png?raw=true)

---

### Invoke-DownloadApplication

Downloads applications from the internet with optimized performance.

**Syntax:**
```powershell
Invoke-DownloadApplication -Url <String> -Destination <String>
```

**Parameters:**
- `Url` - URL to the application to download (mandatory)
- `Destination` - Local file path where the application will be saved (mandatory)

**Examples:**
```powershell
# Download iTunes
Invoke-DownloadApplication -Url "https://www.apple.com/itunes/download/win64" -Destination "$env:TEMP\iTunes64Setup.exe"

# Download to specific location
Invoke-DownloadApplication -Url "https://example.com/installer.exe" -Destination "C:\Downloads\installer.exe"

# Download multiple applications
$downloads = @(
    @{Url = "https://example.com/app1.exe"; Destination = "C:\temp\app1.exe"},
    @{Url = "https://example.com/app2.exe"; Destination = "C:\temp\app2.exe"}
)
foreach ($download in $downloads) {
    Invoke-DownloadApplication @download
}
```

**Features:**
- Optimized download speed by suppressing progress bar
- Automatic restoration of original ProgressPreference setting
- Comprehensive error handling with exception details
- Uses Invoke-WebRequest with basic parsing
- Suitable for automation and scripting

**Performance:**
- Temporarily sets `$ProgressPreference = "SilentlyContinue"` to improve download speed
- Restores original preference after completion
- Significant speed improvement in older Windows PowerShell versions

**Error Handling:**
- Provides detailed error messages on download failure
- Outputs exception information for troubleshooting
- Stops execution on error with proper error handling

---

## Common Features

All functions in this collection share these characteristics:

- **Pipeline Support**: Most functions accept pipeline input for bulk operations
- **Structured Output**: Return PSCustomObject for easy property access and filtering
- **Modern PowerShell**: Compatible with both Windows PowerShell 5.1 and PowerShell 7+
- **Error Handling**: Comprehensive try-catch blocks for graceful error management
- **No External Dependencies**: Work with built-in Windows APIs and PowerShell cmdlets

## Usage Scenarios

### Application Inventory
```powershell
# Create inventory of all installed applications
Get-InstalledApplications | Export-Csv -Path "C:\Reports\InstalledApps.csv" -NoTypeInformation

# Check specific application versions across machines
$computers = "PC01","PC02","PC03"
Invoke-Command -ComputerName $computers -ScriptBlock ${function:Get-InstalledApplications} |
    Where-Object DisplayName -match "Office" |
    Select-Object PSComputerName, DisplayName, DisplayVersion
```

### Package Analysis
```powershell
# Analyze MSI packages before deployment
Get-ChildItem C:\Packages\*.msi | ForEach-Object {
    Get-MSIAppInformation -FilePath $_.FullName -Property ProductName,ProductVersion,Manufacturer
}

# Check EXE file versions
Get-ChildItem C:\Downloads\*.exe | Get-ExeAppInformation
```

### Automated Downloads
```powershell
# Download and verify applications
$apps = @{
    "Chrome" = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
    "Firefox" = "https://download.mozilla.org/?product=firefox-latest"
}

foreach ($app in $apps.GetEnumerator()) {
    $destination = "$env:TEMP\$($app.Key)_installer.exe"
    Invoke-DownloadApplication -Url $app.Value -Destination $destination
    if (Test-Path $destination) {
        Get-ExeAppInformation -Path $destination
    }
}
```

### Uninstall Automation
```powershell
# Prepare uninstall commands for specific software
$app = "Obsolete Software"
$uninstallInfo = Get-UninstallString -ApplicationName $app

if ($uninstallInfo) {
    Write-Output "Found: $($uninstallInfo.DisplayName)"
    Write-Output "Uninstall command: $($uninstallInfo.UninstallString)"
    # Add silent parameters as needed for automation
}
```

## Best Practices

### General Guidelines
- Always test functions in non-production environments first
- Use `-ErrorAction Stop` when you need strict error handling
- Leverage pipeline operations for bulk processing
- Store downloaded applications in temporary directories and clean up after use

### Security Considerations
- Verify download URLs before using Invoke-DownloadApplication
- Be cautious when executing uninstall strings programmatically
- Test uninstall commands manually before automation
- Ensure proper permissions when querying registry or creating files

### Performance Tips
- Use `-Property` parameter to limit data retrieval when possible
- Cache results of Get-InstalledApplications for repeated queries
- Use `-ExactMatch` when you know the exact application name
- Leverage regex patterns efficiently to reduce result sets

## Pictures Folder

The Pictures subfolder contains screenshot examples demonstrating the functions in action. These visual guides help understand the expected output and usage patterns.

## Author

**Fredrik Wall**
- Email: wall.fredrik@gmail.com
- Twitter: [@walle75](https://twitter.com/walle75)
- Blog: [http://www.poweradmin.se](http://www.poweradmin.se)
- GitHub: [https://github.com/FredrikWall](https://github.com/FredrikWall)

## License

See the LICENSE file in the repository root for license information.

## Contributing

Contributions, issues, and feature requests are welcome. Feel free to check the issues page if you want to contribute.

## Related Functions

For related functionality, see also:
- **EXE Application Information Tool** - GUI tool for EXE analysis
- **MSI Information Tool** - GUI tool for MSI analysis
- **PSAppDeployToolkit** - Advanced application deployment toolkit

