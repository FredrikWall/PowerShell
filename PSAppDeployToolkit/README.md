# PSAppDeployToolkit Resources

A comprehensive collection of resources, templates, and documentation for working with PSAppDeployToolkit — a powerful, community-driven PowerShell framework for creating and managing software deployments.

## Overview

PSAppDeployToolkit (PSADT) is a robust framework that simplifies the process of deploying applications in enterprise environments. This folder contains curated resources to help you quickly create, deploy, and maintain application packages using PSAppDeployToolkit v4.x.

## What is PSAppDeployToolkit?

PSAppDeployToolkit is a PowerShell-based framework designed to provide a consistent and user-friendly experience for application deployments. It handles common deployment tasks such as:

- **User Interaction** - Professional dialogs for installation progress and user prompts
- **Process Management** - Detect and close running applications gracefully
- **Installation Logic** - Support for MSI, EXE, and custom installations
- **File Operations** - Copy, move, and manage files and folders
- **Registry Management** - Create, modify, and remove registry keys
- **Logging** - Comprehensive logging for troubleshooting
- **Detection Methods** - Create custom detection rules for deployment tools

## Folder Structure

### 📚 [CheatSheet](CheatSheet/)
Quick reference guide and examples for common PSAppDeployToolkit commands and patterns.

**Contents:**
- Common PSAppDeployToolkit commands and syntax
- Variable reference (ADTSession, environment variables)
- Installation/uninstallation examples
- File operations and registry management
- Custom detection methods
- Best practices and tips

**Perfect for:** Quick lookups while creating deployment scripts

### 🧩 [Snippets](Snippets/)
Visual Studio Code snippets for rapid PSAppDeployToolkit development.

**Contents:**
- `powershell.json` - Code snippets for VS Code
- Custom detection registry key templates
- Common installation patterns
- Author and date auto-completion

**Perfect for:** Accelerating script development with auto-completion

### 📦 [Template](Template/)
Ready-to-use PSAppDeployToolkit project templates and folder structures.

**Contents:**
- Complete PSAppDeployToolkit v4.x folder structure
- Pre-configured `Invoke-AppDeployToolkit.ps1` template
- Documentation templates
- Example configurations

**Perfect for:** Starting new application packages quickly

## Quick Start Guide

### 1. Download PSAppDeployToolkit

Download the latest version from the official repository:
- **Official Site:** [https://psappdeploytoolkit.com/](https://psappdeploytoolkit.com/)
- **GitHub Releases:** [https://github.com/psappdeploytoolkit/psappdeploytoolkit/releases](https://github.com/psappdeploytoolkit/psappdeploytoolkit/releases)

### 2. Unblock Downloaded Files

After downloading, unblock all files to prevent execution issues:

```powershell
Get-ChildItem -Path "C:\Path\To\PSAppDeployToolkit" -Recurse | Unblock-File
```

### 3. Use the Template

1. Navigate to the [Template](Template/) folder
2. Copy the template folder structure
3. Rename to match your application (e.g., `App_Adobe_Reader_2024.1_x64`)
4. Add your installation files to the `Files` folder
5. Edit `Invoke-AppDeployToolkit.ps1` to customize the deployment

### 4. Reference the CheatSheet

Open [CheatSheet/README.md](CheatSheet/README.md) for quick command references while scripting.

### 5. Install Code Snippets

Follow instructions in [Snippets/README.md](Snippets/README.md) to add VS Code snippets for faster development.

## Common Use Cases

### Enterprise Application Deployment
- Deploy applications via SCCM, Intune, or other deployment tools
- Manage complex installations with dependencies
- Handle user interactions and prompts
- Provide professional user experience

### Application Packaging
- Create standardized deployment packages
- Implement custom detection methods
- Handle pre/post installation tasks
- Manage configuration files and settings

### Software Updates
- Deploy application updates and patches
- Manage MSP (patch) installations
- Handle version detection and upgrades

### Uninstallations
- Clean application removal with registry cleanup
- Remove files and shortcuts
- Handle user profile cleanup

## Key Features of PSAppDeployToolkit

### User Experience
- **Professional Dialogs** - Custom branded installation windows
- **Progress Feedback** - Real-time installation progress
- **Defer Options** - Allow users to defer installations
- **Close Apps Prompts** - Gracefully close running applications

### Technical Capabilities
- **MSI Support** - Install, uninstall, repair MSI packages
- **EXE Support** - Execute setup files with parameters
- **File Operations** - Copy, move, delete files and folders
- **Registry Management** - Full registry CRUD operations
- **Service Management** - Start, stop, modify services
- **Shortcut Management** - Create and remove shortcuts
- **Process Management** - Detect and terminate processes

### Integration
- **SCCM/ConfigMgr** - Full integration with Configuration Manager
- **Microsoft Intune** - Win32 app deployment support
- **Detection Methods** - Custom registry keys for detection
- **Exit Codes** - Standard and custom exit codes
- **Logging** - Comprehensive logging for troubleshooting

## Documentation Links

### Official Documentation
- **Main Site:** [https://psappdeploytoolkit.com/](https://psappdeploytoolkit.com/)
- **Documentation:** [https://psappdeploytoolkit.com/docs/](https://psappdeploytoolkit.com/docs/)
- **Reference:** [https://psappdeploytoolkit.com/docs/reference/](https://psappdeploytoolkit.com/docs/reference/)
- **GitHub:** [https://github.com/psappdeploytoolkit/psappdeploytoolkit](https://github.com/psappdeploytoolkit/psappdeploytoolkit)

### Community Resources
- **Reddit:** [r/PSAppDeployToolkit](https://www.reddit.com/r/PSAppDeployToolkit/)
- **Discord:** Check official site for invite link
- **Blog Posts:** Search for "PSAppDeployToolkit" tutorials

## Version Information

This resource collection is designed for:
- **PSAppDeployToolkit v4.1.x** (primary focus)
- **PowerShell 5.1+** (Windows PowerShell)
- **PowerShell 7+** (PowerShell Core - limited support)

## Best Practices

### Project Organization
1. Use consistent naming: `App_Vendor_Application_Version_Architecture`
2. Maintain separate folders for Files and SupportFiles
3. Document your deployment in the DOC folder
4. Include application icons in the ICON folder

### Script Development
1. Always test in a non-production environment first
2. Use the CheatSheet for command references
3. Leverage VS Code snippets for consistency
4. Implement proper error handling
5. Use verbose logging during development

### Deployment Preparation
1. Unblock all files after download/copy
2. Test both install and uninstall operations
3. Verify detection methods work correctly
4. Document special requirements or dependencies
5. Test with different user contexts (user vs. system)

## Support & Contributing

### Getting Help
- Check the [CheatSheet](CheatSheet/README.md) for quick answers
- Review official documentation at [psappdeploytoolkit.com](https://psappdeploytoolkit.com/)
- Search the GitHub issues for similar problems
- Ask in community forums (Reddit, Discord)

### Contributing
Contributions to these resources are welcome! To contribute:
1. Test your additions thoroughly
2. Follow existing documentation style
3. Provide clear examples
4. Update relevant READMEs
5. Submit via pull request

## Author

**Fredrik Wall**
- Email: wall.fredrik@gmail.com
- Blog: [www.poweradmin.se](http://www.poweradmin.se)
- Twitter: [@walle75](https://twitter.com/walle75)
- GitHub: [https://github.com/FredrikWall](https://github.com/FredrikWall)

## Version History

### Version 1.5 (2025-12-04)
- Updated for PSAppDeployToolkit v4.1.x
- Enhanced CheatSheet with ADTSession variables
- Added comprehensive examples
- Improved documentation structure

### Version 1.0
- Initial resource collection
- Basic templates and examples
- Core documentation

## License

PSAppDeployToolkit is licensed under the LGPL v3.0. See the official repository for license details.

This resource collection follows the same license as the main repository.

## Tips & Tricks

### VS Code Setup
- Install the PowerShell extension for VS Code
- Import PSAppDeployToolkit module for IntelliSense
- Use snippets from the Snippets folder
- Enable PowerShell script analysis

### Testing Deployments
```powershell
# Interactive installation (shows UI)
.\Invoke-AppDeployToolkit.exe -DeploymentType Install -DeployMode Interactive

# Silent installation (no UI)
.\Invoke-AppDeployToolkit.exe -DeploymentType Install -DeployMode Silent

# Uninstallation
.\Invoke-AppDeployToolkit.exe -DeploymentType Uninstall

# Non-interactive mode (default for system context)
.\Invoke-AppDeployToolkit.exe -DeploymentType Install -DeployMode NonInteractive
```

### Common Variables
```powershell
$adtSession.AppVendor        # Application vendor
$adtSession.AppName          # Application name
$adtSession.AppVersion       # Application version
$adtSession.AppArch          # Architecture (x86/x64)
$adtSession.DirFiles         # Path to Files folder
$adtSession.DirSupportFiles  # Path to SupportFiles folder
```

### Quick Commands
```powershell
# Install MSI
Invoke-ADTMsiPackage -Action 'Install' -Path 'app.msi'

# Install EXE
Start-ADTProcess -FilePath 'setup.exe' -ArgumentList '/silent'

# Copy files
Copy-ADTFile -Path "$($adtSession.DirSupportFiles)\config.xml" -Destination "$envProgramData\MyApp"

# Create registry key
Set-ADTRegistryKey -Key 'HKLM\Software\MyApp' -Name 'Version' -Value '1.0'

# Close process
Stop-ADTProcess -Name 'application' -EnableLogging
```

## Additional Resources

- **Applications** - Utility functions for working with installed applications  

