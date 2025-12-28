# PSAppDeployToolkit Template

Ready-to-use templates and folder structure for creating PSAppDeployToolkit-based application packages. Provides a standardized starting point for building deployment packages with best practices built in.

## Overview

This folder contains complete template structures for PSAppDeployToolkit deployments. Each template includes the necessary folder hierarchy, configuration files, and example scripts to quickly start packaging applications for enterprise deployment.

## Features

- 📦 **Complete Folder Structure** - Pre-configured directories for all package components
- 🚀 **Quick Start Templates** - Ready-to-customize deployment scripts
- 📝 **Documentation Templates** - Built-in documentation structure
- 🎨 **Icon Support** - Dedicated folder for application icons
- ☁️ **Azure Integration Ready** - Folder structure for Win32 app conversion
- 🔧 **Support Files Organization** - Separated configuration and installation files

## Template Structure

### Main Folders

```
PSAppDeployToolkit v<version>/
└── App_Vendor_Application_Version_Architecture/
    ├── Azure/              - Win32 converted application for Intune deployment
    ├── DOC/                - Package documentation
    │   └── Application_Information.txt
    ├── ICON/               - Application icon files
    └── PSADT/              - PSAppDeployToolkit core files
        ├── Files/          - Installation files to be deployed
        ├── SupportFiles/   - Configuration files for deployment
        ├── Invoke-AppDeployToolkit.exe
        └── Invoke-AppDeployToolkit.ps1
```

### Directory Details

| Directory | Purpose | Contents |
|-----------|---------|----------|
| **Azure** | Intune deployment | Win32 converted application package |
| **DOC** | Documentation | Package notes, detection rules, vendor info |
| **ICON** | Branding | Application icon for deployment UI |
| **PSADT** | Core toolkit | PSAppDeployToolkit framework files |
| **PSADT/Files** | Installation files | MSI, EXE, or other installers |
| **PSADT/SupportFiles** | Configuration | Settings files, configs, registry files |

### Key Files

**Invoke-AppDeployToolkit.exe**
- Main executable for launching deployments
- Called by deployment systems (SCCM, Intune, etc.)
- Handles command-line parameters

**Invoke-AppDeployToolkit.ps1**
- Main deployment script
- Contains installation/uninstallation logic
- Customize for your specific application

**Application_Information.txt**
- Package documentation template
- Vendor, application name, version
- Detection rules and notes

## How to Use

### Step 1: Select Template Version
```powershell
# Choose the latest version folder
cd "PSAppDeployToolkit v4.1.7"
```

### Step 2: Copy Template
```powershell
# Copy the template folder to your packaging location
Copy-Item "App_Vendor_Application_Version_Architecture" -Destination "C:\Packaging\" -Recurse
```

### Step 3: Rename Package Folder
```powershell
# Rename following the naming convention
# Format: App_Vendor_Application_Version_Architecture
Rename-Item "App_Vendor_Application_Version_Architecture" -NewName "App_Adobe_Acrobat_24.2.1_x64"
```

### Step 4: Customize Deployment Script
Edit `PSADT\Invoke-AppDeployToolkit.ps1`:
- Update application metadata (name, version, vendor)
- Add installation commands in the Installation section
- Add uninstallation commands in the Uninstallation section
- Configure pre/post installation tasks

### Step 5: Add Installation Files
```powershell
# Copy installer files to Files folder
Copy-Item "AcrobatSetup.exe" -Destination "PSADT\Files\"
```

### Step 6: Add Configuration Files
```powershell
# Copy configuration files to SupportFiles folder
Copy-Item "settings.xml" -Destination "PSADT\SupportFiles\"
```

## Testing Deployments

### Interactive Installation
Test with full UI to verify deployment behavior:
```powershell
# Run as Administrator
.\Invoke-AppDeployToolkit.exe -DeploymentType Install -DeployMode Interactive
```

### Silent Installation
Test silent deployment (typical for production):
```powershell
# Run as Administrator
.\Invoke-AppDeployToolkit.exe -DeploymentType Install -DeployMode Silent
```

### Uninstallation
Test removal process:
```powershell
# Run as Administrator
.\Invoke-AppDeployToolkit.exe -DeploymentType Uninstall -DeployMode Interactive
```

### NonInteractive Mode
For deployment systems:
```powershell
# Used by SCCM/Intune/other deployment tools
.\Invoke-AppDeployToolkit.exe -DeploymentType Install -DeployMode NonInteractive
```

## Deployment Modes

| Mode | Description | Use Case |
|------|-------------|----------|
| **Interactive** | Shows all UI dialogs | Testing, manual deployment |
| **Silent** | Minimal UI, auto-closes | Standard enterprise deployment |
| **NonInteractive** | No UI, runs silently | Automated deployment systems |

## Best Practices

### Naming Convention
```
App_<Vendor>_<Application>_<Version>_<Architecture>

Examples:
- App_Adobe_Acrobat_24.2.1_x64
- App_Microsoft_Office_365_2024_x86
- App_7zip_23.01_x64
```

### Documentation
1. Fill out `DOC\Application_Information.txt` with:
   - Application details
   - Installation parameters
   - Detection rules
   - Known issues

2. Keep packaging notes for future updates

### Testing Checklist
- ✅ Test interactive installation
- ✅ Test silent installation
- ✅ Verify all files copied correctly
- ✅ Test uninstallation process
- ✅ Check detection logic
- ✅ Verify no user interaction required in NonInteractive mode

### File Organization
- **Large installers** (>100MB): Keep in Files folder
- **Configuration files**: Use SupportFiles folder
- **Documentation**: Keep in DOC folder
- **Icons**: Store high-quality icons in ICON folder

## Common Customizations

### Installation Section
```powershell
##*===============================================
##* INSTALLATION
##*===============================================
[String]$installPhase = 'Installation'

# Example: Install MSI with custom parameters
Execute-MSI -Action Install -Path 'Setup.msi' -Parameters '/quiet ALLUSERS=1'

# Example: Install EXE silently
Execute-Process -Path 'Setup.exe' -Parameters '/S /quiet'

# Example: Copy configuration file
Copy-File -Path "$dirSupportFiles\config.xml" -Destination "$envProgramData\AppName\"
```

### Uninstallation Section
```powershell
##*===============================================
##* UNINSTALLATION
##*===============================================
[String]$installPhase = 'Uninstallation'

# Example: Uninstall by product code
Execute-MSI -Action Uninstall -Path '{PRODUCT-GUID-HERE}'

# Example: Remove configuration files
Remove-Folder -Path "$envProgramData\AppName"
```

## Tips and Tricks

### Development Environment
- **Use Visual Studio Code** with PowerShell extension for:
  - Syntax highlighting
  - IntelliSense support
  - Integrated debugging
  - PSADT snippets (see Snippets/README.md)

### Unblocking Files
```powershell
# Unblock downloaded ZIP files before extraction
Unblock-File -Path "PSAppDeployToolkit.zip"

# Or unblock entire folder after extraction
Get-ChildItem -Path ".\PSADT" -Recurse | Unblock-File
```

### Using Interactive Mode
**Best Practice**: Always test with `-DeployMode Interactive` first
- Shows all dialogs and progress
- Helps identify issues early
- Verifies user experience
- Displays detailed error messages

### Quick Reference
See the [CheatSheet README](../CheatSheet/README.md) for:
- Common functions
- Variable reference
- Quick examples
- Best practices

## Troubleshooting

### Common Issues

**Issue**: Script won't run
```powershell
# Solution: Check execution policy
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

**Issue**: Files marked as blocked
```powershell
# Solution: Unblock all files
Get-ChildItem -Recurse | Unblock-File
```

**Issue**: Can't find installation files
```powershell
# Solution: Verify path in script matches folder structure
# Use $dirFiles variable for Files folder
# Use $dirSupportFiles variable for SupportFiles folder
```

## References

### Official Resources
- **Official Website**: [psappdeploytoolkit.com](https://psappdeploytoolkit.com/)
- **GitHub Repository**: [github.com/psappdeploytoolkit/psappdeploytoolkit](https://github.com/psappdeploytoolkit/psappdeploytoolkit)
- **Documentation**: Official docs at psappdeploytoolkit.com

### Related Documentation
- [CheatSheet](../CheatSheet/README.md) - Quick reference guide
- [Snippets](../Snippets/README.md) - VS Code snippets for development

## Version Information

Templates are organized by PSAppDeployToolkit version:
- **v4.1.x** - Current stable version
- Each version folder contains tested, compatible templates
- Always use templates matching your PSADT version

## Author

**Fredrik Wall**
- Email: wall.fredrik@gmail.com
- Blog: [www.poweradmin.se](https://www.poweradmin.se)
- Twitter: [@walle75](https://twitter.com/walle75)

## License

See the LICENSE file in the repository root for license information.

