# EXE Application Information Tool

A professional Windows GUI application for extracting metadata from executable (.exe) files, built with modern WPF technology.

## Overview

This tool provides a simple, user-friendly interface to extract application metadata from EXE files without executing them. It retrieves information directly from the file's version information resource, including product name, version, company name, and language.

## Features

- 🔍 **Extract Metadata** - Get Product Name, Product Version, Company Name, and Language
- 🎨 **Modern UI** - Clean, professional Windows interface with WPF styling
- 📋 **Copy to Clipboard** - Export all information in a formatted text block
- ⌨️ **Keyboard Shortcuts** - Efficient navigation with hotkeys
- 🔒 **Safe Operation** - Reads file metadata without executing the file
- 🎯 **Auto-populate** - Information extracted automatically when file is selected
- 🌐 **Universal** - Works with any Windows EXE file that contains version information

## Application Details

**File:** `ExeApplicationInformation.ps1`

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
- Windows 7 or higher

## Screenshot

![EXE Application Information Tool - WPF Edition](https://github.com/FredrikWall/PowerShell/blob/master/EXE%20Application%20Information%20Tool/Pictures/exeappinfoWPF.png?raw=true)

*Modern WPF interface with clean design and intuitive layout*

## How to Use

### Quick Start

1. **Run the application:**
   ```powershell
   .\ExeApplicationInformation.ps1
   ```

2. **Select an EXE file:**
   - Click the **Browse** button (or press `Ctrl+O`)
   - Navigate to and select any `.exe` file
   - Information is automatically extracted

3. **View the results:**
   - Product Name
   - Product Version
   - Company Name
   - Language

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
The commercial name of the application as defined by the publisher.

### Product Version
The version string of the application (e.g., 8.0.1440.1, 1.2.3.4).

### Company Name
The name of the company or organization that created the software.

### Language
The language identifier for the application's user interface.

## Use Cases

### Software Inventory
Quickly identify versions of installed applications without launching them.

### Package Management
Verify application versions before deployment or installation.

### Compliance Auditing
Document software versions for compliance and audit purposes.

### Troubleshooting
Identify which version of an application is causing issues.

### Software Development
Verify version information is correctly embedded in compiled executables.

## Technical Details

### How It Works
The tool uses the .NET `System.Diagnostics.FileVersionInfo` class to read the version resource information embedded in Windows executables. This is the same information visible in Windows Explorer when you right-click a file and view Properties > Details.

### Code Function
The core functionality is also available as a standalone PowerShell function in:
- `Get-ExeAppInformation_function.ps1`

**Function Usage:**
```powershell
# Load the function
. .\Get-ExeAppInformation_function.ps1

# Get specific property
Get-ExeAppInformation -FilePath "C:\Path\To\Application.exe" -Property "ProductName"

# Example output
Java Platform SE 8 U144
```

### Supported File Types
- Windows executable files (`.exe`)
- Files must contain embedded version information resource
- Files without version information will return "N/A" for missing fields

## Error Handling

The WPF version includes comprehensive error handling:
- **File not found** - Clear message if selected file no longer exists
- **Missing version info** - Displays "N/A" for unavailable properties
- **Access denied** - Handles permission issues gracefully
- **Invalid file** - Validates file type and accessibility

## Technical Architecture

**UI Framework:** Windows Presentation Foundation (WPF)
**Code Structure:** XAML-based UI with PowerShell logic
**Dependencies:** PresentationFramework, PresentationCore, WindowsBase
**Design Pattern:** MVVM-inspired with event-driven architecture

## Installation

No installation required! Simply download and run:

1. Download `ExeApplicationInformation.ps1`
2. Right-click and select "Run with PowerShell"
   - Or open PowerShell and run: `.\ExeApplicationInformation.ps1`

**Note:** If you encounter execution policy issues:
```powershell
# Allow script execution for current session
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
.\ExeApplicationInformation.ps1
```

## Development

### Editing the Application
The application uses embedded XAML for UI definition. Edit the `$XAML` variable in the script to modify the interface.

### Customization Options
- **Window size:** Modify `Height` and `Width` in XAML
- **Colors:** Update color values in the styles section
- **Button labels:** Change `Content` properties
- **Layout:** Adjust Grid rows/columns and margins

## Repository Structure

- **ExeApplicationInformation.ps1** - Main WPF application
- **Pictures/** - Screenshots and documentation images
- **README.md** - This documentation file

## Author

**Fredrik Wall**
- Email: fredrik@poweradmin.se
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

### Version 1.0 (2018-04-02)
- Initial release with Windows Forms
- Created in PowerShell Studio 2019
- Basic information extraction functionality
- Manual "Get" button operation

## License

See the LICENSE file in the repository root for license information.

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page if you want to contribute.

## Troubleshooting

### "File Not Found" Error
Ensure the selected file still exists at the specified location.

### "N/A" Values
The EXE file may not contain version information for all fields. This is normal for some applications.

### Cannot Run Script
Check PowerShell execution policy:
```powershell
Get-ExecutionPolicy
# If Restricted, run with:
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

### Application Not Responding
If the window freezes, close and restart. This can happen with extremely large or corrupted EXE files.

## Tips

- You can drag and drop the window to resize it
- All textboxes are read-only to prevent accidental modifications
- The tool works best with modern Windows applications
- Some older or stripped executables may not contain version information
- Clipboard export includes a timestamp for record-keeping
