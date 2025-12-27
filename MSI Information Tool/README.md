# MSI Application Information Tool

A professional Windows GUI application for extracting metadata from Windows Installer (.msi) packages, built with modern WPF technology.

## Overview

This tool provides a simple, user-friendly interface to extract package metadata from MSI files without installing them. It retrieves information directly from the MSI database's Property table, including product name, version, manufacturer, product code, and language information.

## Features

- 🔍 **Extract Metadata** - Get Product Name, Product Version, Manufacturer, Product Code, and Language
- 🎨 **Modern UI** - Clean, professional Windows interface with WPF styling
- 📋 **Copy to Clipboard** - Export all information in a formatted text block
- ⌨️ **Keyboard Shortcuts** - Efficient navigation with hotkeys
- 🔒 **Safe Operation** - Reads MSI database without installing or modifying the package
- 🎯 **Auto-populate** - Information extracted automatically when file is selected
- 🌐 **Universal** - Works with any standard Windows Installer package

## Application Details

**File:** `MSIApplicationInformation-WPF.ps1`

Built with Windows Presentation Foundation (WPF), featuring:
- Professional, modern UI design with smooth animations
- Responsive layout with proper spacing
- Color-coded action buttons for better usability
- Enhanced keyboard shortcuts (Ctrl+O, Ctrl+G, Esc)
- Real-time status feedback
- Improved error handling with user-friendly messages
- Auto-populate information on file selection
- Better accessibility and user experience

**Requirements:**
- PowerShell 5.1 or higher
- .NET Framework 4.5+ (included with Windows 10/11)
- Windows Installer (built into Windows)
- Windows 7 or higher

## Screenshot

![MSI Application Information Tool - WPF Edition](https://github.com/FredrikWall/PowerShell/blob/master/MSI%20Information%20Tool/Pictures/msiappInfotool.png?raw=true)

*Modern WPF interface with clean design and intuitive layout*

## How to Use

### Quick Start

1. **Run the application:**
   ```powershell
   .\MSIApplicationInformation.ps1
   ```

2. **Select an MSI file:**
   - Click the **Browse** button (or press `Ctrl+O`)
   - Navigate to and select any `.msi` file
   - Information is automatically extracted

3. **View the results:**
   - Product Name
   - Product Version
   - Manufacturer
   - Product Code
   - Product Language

4. **Copy information (optional):**
   - Click **Copy to Clipboard** to export all data
   - Information is formatted with labels and timestamp

5. **Clear for next file:**
   - Click **Clear** (or press `Esc`) to reset all fields

### Keyboard Shortcuts

Convenient keyboard shortcuts for efficient navigation:

| Shortcut | Action |
|----------|--------|
| `Ctrl+O` | Open file browser |
| `Ctrl+G` | Get information from selected file |
| `Ctrl+C` | Copy information to clipboard (when not in textbox) |
| `Esc` | Clear all fields |

## Extracted Information

### Product Name
The commercial name of the application/package as defined by the publisher. This is the name that typically appears in "Programs and Features" after installation.

### Product Version
The version string of the application (e.g., 1.2.3.4, 10.0.19041.0). This follows the standard Windows Installer versioning format.

### Manufacturer
The name of the company or organization that created and published the software package.

### Product Code
A unique GUID (Globally Unique Identifier) that identifies this specific product. This code is used by Windows Installer to track installations and upgrades. Format: {XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}

### Product Language
The language code identifier for the package's user interface (e.g., 1033 for English-US, 1031 for German).

## Use Cases

### Software Deployment
Verify MSI package information before deploying to production environments.

### Package Management
Quickly identify product codes and versions for scripted installations and removals.

### Compliance Auditing
Document software package details for compliance and audit purposes without installation.

### Application Packaging
Validate MSI properties during application repackaging or customization.

### Upgrade Planning
Check product codes and versions to plan upgrade strategies and detect conflicts.

### Troubleshooting
Identify MSI package details when troubleshooting installation issues.

## Technical Details

### How It Works
The tool uses the Windows Installer COM automation interface (`WindowsInstaller.Installer`) to open the MSI database in read-only mode and query the Property table. This provides direct access to all MSI properties without modifying or installing the package.

### MSI Database Access
- **Read-Only Mode** - Opens database with no write access
- **COM Automation** - Uses standard Windows Installer API
- **Property Table** - Queries the MSI Property table directly
- **Proper Cleanup** - Releases COM objects and forces garbage collection

### Supported File Types
- Standard Windows Installer packages (`.msi`)
- MSI files must be valid and not corrupted
- Works with both 32-bit and 64-bit MSI packages

## Error Handling

The application includes comprehensive error handling:
- **File not found** - Clear message if selected file no longer exists
- **Invalid MSI** - Validates file is a proper MSI database
- **Missing properties** - Displays "N/A" for unavailable properties
- **Access denied** - Handles permission issues gracefully
- **Corrupted database** - Detects and reports database errors

## Technical Architecture

**UI Framework:** Windows Presentation Foundation (WPF)
**Code Structure:** XAML-based UI with PowerShell logic
**Dependencies:** PresentationFramework, PresentationCore, WindowsBase
**COM Interface:** WindowsInstaller.Installer
**Design Pattern:** MVVM-inspired with event-driven architecture

## Installation

No installation required! Simply download and run:

1. Download `MSIApplicationInformation.ps1`
2. Right-click and select "Run with PowerShell"
   - Or open PowerShell and run: `.\MSIApplicationInformation.ps1`

**Note:** If you encounter execution policy issues:
```powershell
# Allow script execution for current session
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
.\MSIApplicationInformation.ps1
```

## Development

### Editing the Application
The application uses embedded XAML for UI definition. Edit the `$XAML` variable in the script to modify the interface.

### Core Function
The tool uses the `Get-MSIAppInformation` function from the Applications folder, which:
- Opens MSI database using COM automation
- Queries the Property table for metadata
- Returns PSCustomObject with property values
- Properly releases COM objects to prevent memory leaks

### Customization Options
- **Window size:** Modify `Height` and `Width` in XAML
- **Colors:** Update color values in the styles section
- **Button labels:** Change `Content` properties
- **Layout:** Adjust Grid rows/columns and margins
- **Additional fields:** Add more MSI properties by modifying the query

## Common MSI Properties

Beyond the displayed properties, MSI files can contain many other properties:

| Property | Description |
|----------|-------------|
| UpgradeCode | GUID for product family/upgrade series |
| ARPCONTACT | Support contact information |
| ARPHELPLINK | Product help/support URL |
| ARPURLINFOABOUT | Product information URL |
| Comments | Additional package comments |
| Keywords | Search keywords |
| InstallDate | Date of installation (after install) |

## Repository Structure

- **MSIApplicationInformation.ps1** - Main WPF application
- **Pictures/** - Screenshots and documentation images
- **README.md** - This documentation file

## Author

**Fredrik Wall**
- Email: wall.fredrik@gmail.com
- Blog: [www.poweradmin.se](http://www.poweradmin.se)
- Twitter: [@walle75](https://twitter.com/walle75)
- GitHub: [https://github.com/FredrikWall](https://github.com/FredrikWall)

## Version History

### Version 2.0 (2025-12-27) - WPF Edition
- Complete redesign using Windows Presentation Foundation
- Modern, professional UI with custom styling
- Auto-populate information on file selection
- Enhanced keyboard shortcuts
- Improved error handling and user feedback
- Better accessibility and usability
- Real-time status updates
- Formatted clipboard export with timestamp
- Uses optimized Get-MSIAppInformation function from Applications folder

### Version 1.0 (2014-12-05)
- Initial release with Windows Forms
- Basic MSI property extraction functionality
- Manual "Get" button operation

## License

See the LICENSE file in the repository root for license information.

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page if you want to contribute.

## Troubleshooting

### "File Not Found" Error
Ensure the selected MSI file still exists at the specified location.

### "N/A" Values
The MSI file may not contain values for all properties. This is normal for some packages.

### Cannot Run Script
Check PowerShell execution policy:
```powershell
Get-ExecutionPolicy
# If Restricted, run with:
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

### "Failed to open database" Error
- Verify the file is a valid MSI package
- Check file is not corrupted
- Ensure file is not locked by another process
- Confirm you have read permissions on the file

### Application Not Responding
If the window freezes, close and restart. This can happen with extremely large or corrupted MSI files.

## Tips

- You can drag and drop the window to resize it
- All textboxes are read-only to prevent accidental modifications
- Product Code GUIDs can be used in scripts for silent installations/uninstallations
- Language codes follow standard LCID (Locale Identifier) format
- Clipboard export includes a timestamp for record-keeping
- The tool works without requiring administrative privileges

## Related Tools

For related functionality, see also:
- **EXE Application Information Tool** - Extract metadata from executable files
- **Applications/Get-MSIAppInformation.ps1** - Standalone PowerShell function
- **Applications/Get-InstalledApplications.ps1** - Query installed applications

## MSI Command Line Usage

Once you have the Product Code, you can use it for scripted operations:

```powershell
# Silent installation
msiexec /i "package.msi" /qn

# Silent uninstallation using Product Code
msiexec /x "{PRODUCT-CODE-GUID}" /qn

# Installation with logging
msiexec /i "package.msi" /qn /l*v "install.log"

# Repair installation
msiexec /fa "{PRODUCT-CODE-GUID}" /qn
```

## Security Considerations

- The tool only reads MSI metadata and does not install or execute any code
- MSI files are opened in read-only mode
- No modifications are made to the MSI package
- COM objects are properly released after use
- Suitable for analyzing potentially untrusted MSI packages safely
