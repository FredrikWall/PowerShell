# PowerShell Functions & Scripts

A comprehensive collection of PowerShell functions, scripts, and tools for enterprise IT automation. This repository provides ready-to-use solutions for Active Directory management, application deployment, name generation, and system administration.

## 📋 Overview

This repository contains production-ready PowerShell code organized by functional area. Each folder includes detailed documentation, examples, and best practices for immediate use in enterprise environments.

## 🗂️ Repository Structure

### [Active Directory](Active%20Directory/)
LDAP-based functions for Active Directory management without requiring the AD module. Includes functions for querying and creating computers, groups, OUs, and users with support for LDAPS.

**Key Functions:**
- `Get-LDAPComputer`, `Get-LDAPGroup`, `Get-LDAPOU`, `Get-LDAPUser`
- `New-LDAPComputer`, `New-LDAPGroup`, `New-LDAPOU`, `New-LDAPUser`
- Direct LDAP communication without module dependencies

### [Applications](Applications/)
Application management functions for extracting metadata, managing installations, and downloading applications. Includes tools for working with EXE and MSI files.

**Key Functions:**
- `Get-ExeAppInformation` - Extract EXE file metadata
- `Get-MSIAppInformation` - Extract MSI package properties
- `Get-InstalledApplications` - Query installed software
- `Get-UninstallString` - Retrieve uninstall commands
- `Invoke-DownloadApplication` - Automated application downloads

### [EXE Application Information Tool](EXE%20Application%20Information%20Tool/)
Modern WPF-based GUI tool for extracting and displaying EXE file information. Professional interface with keyboard shortcuts and clipboard export functionality.

**Features:**
- File metadata extraction (version, company, description)
- Modern WPF interface
- Clipboard export (Ctrl+C)
- Keyboard shortcuts for quick workflow

### [Fundamentals](Fundamentals/)
Basic PowerShell examples and templates including data file formats, version management, and reference materials.

**Contents:**
- INI and XML templates
- PSD1 data file examples
- Version management scripts
- Reference links and text files

### [Internet](Internet/)
Network and internet-related utilities for system administrators.

**Functions:**
- `Get-MyIPAddress` - Retrieve public IP information

### [Mobicontrol](Mobicontrol/)
Mobile device management utilities for Mobicontrol systems.

**Functions:**
- `Restart-MobiControlService` - Service management automation

### [MSI Information Tool](MSI%20Information%20Tool/)
WPF-based GUI application for extracting and displaying MSI package information. Professional tool for quickly viewing installer metadata.

**Features:**
- Extract ProductName, ProductVersion, Manufacturer
- Display ProductCode and ProductLanguage
- Modern WPF interface
- Clipboard export functionality

### [Names](Names/)
Comprehensive name formatting and generation toolkit with multi-country support. Includes 6,754 given names and 1,700 surnames from six countries.

**Key Functions:**
- `Format-Name` - Smart title casing for names
- `Get-GivenName` - Random given name generation
- `Get-Surname` - Random surname generation
- `Convert-NamesToJson` - Data conversion utility

**Supported Countries:**
Denmark, England/Wales, Finland, Norway, Sweden, USA

### [PSAppDeployToolkit](PSAppDeployToolkit/)
Complete resources for PSAppDeployToolkit (PSADT) application packaging including templates, snippets, and comprehensive documentation.

**Contents:**
- Ready-to-use deployment templates
- VS Code snippets for faster development
- CheatSheet with common functions
- Best practices and examples

### [Windows](Windows/)
Windows system administration utilities for configuration and information gathering.

**Key Functions:**
- File explorer settings (show hidden files, file extensions)
- System information retrieval (manufacturer, model, serial number)
- Network utilities (ping status)
- Windows 10/11 build information

## 🚀 Quick Start

### Using Functions
```powershell
# Load a function
. .\Applications\Get-ExeAppInformation.ps1

# Use the function
Get-ExeAppInformation -Path "C:\Program Files\App\app.exe"
```

### Using GUI Tools
```powershell
# Launch EXE Information Tool
.\EXE Application Information Tool\ExeApplicationInformation.ps1

# Launch MSI Information Tool
.\MSI Information Tool\MSIApplicationInformation-WPF.ps1
```

### Generating Test Data
```powershell
# Load name generation functions
. .\Names\Get-GivenName.ps1
. .\Names\Get-Surname.ps1

# Generate random names
Get-GivenName -Country Sweden
Get-Surname -Country USA
```

## 📖 Documentation

Each folder contains a comprehensive README.md with:
- Function descriptions and syntax
- Usage examples
- Best practices
- Technical details
- Troubleshooting guidance

## 💡 Use Cases

### Active Directory Management
Create AD objects without requiring the ActiveDirectory module, perfect for environments with limited module availability.

### Application Packaging
Extract metadata from installers for documentation, detection rules, and package creation workflows.

### Test Data Generation
Generate realistic test users with authentic names from multiple countries for development and testing environments.

### Deployment Automation
Use PSAppDeployToolkit resources to standardize application packaging and deployment across enterprise environments.

### System Administration
Automate common Windows configuration tasks and gather system information efficiently.

## ⚙️ Requirements

- **PowerShell**: 5.1 or higher
- **OS**: Windows 10/11 or Windows Server 2016+
- **GUI Tools**: .NET Framework 4.5+ for WPF applications
- **Permissions**: Some functions require administrative privileges

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! When using this code:
- Please provide attribution
- Keep original comments and author information intact
- Share improvements back to the community

## 📝 License

See the [LICENSE](LICENSE) file for license information.

## 📧 Contact

**Fredrik Wall**
- Email: wall.fredrik@gmail.com
- Blog: [www.poweradmin.se](https://www.poweradmin.se)
- Twitter: [@walle75](https://twitter.com/walle75)
- GitHub: [github.com/FredrikWall](https://github.com/FredrikWall)

## 🌟 Acknowledgments

If you use these functions and scripts, a thank you is always appreciated! If you publish scripts using this code, please include proper attribution and keep the original comments intact.

---

*Happy PowerShelling! 🚀*
