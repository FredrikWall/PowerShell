# PSAppDeployToolkit Code Snippets

A collection of Visual Studio Code snippets for PSAppDeployToolkit v4.x development. These snippets accelerate script creation by providing quick templates for common PSAppDeployToolkit patterns and configurations.

## Overview

This folder contains JSON snippet files that integrate with Visual Studio Code to provide IntelliSense-style code completion for PSAppDeployToolkit commands, patterns, and configurations. Simply type "PSADT" to see available snippets.

## Contents

- **powershell.json** - Main snippet file containing all PSAppDeployToolkit code templates

## Features

- 🚀 **Quick Templates** - Common PSAppDeployToolkit patterns at your fingertips
- ⌨️ **Type-ahead Support** - Just type "PSADT" to see available snippets
- 📝 **Auto-completion** - Reduce typing and prevent syntax errors
- 🎯 **Best Practices** - Snippets follow PSAppDeployToolkit v4.x conventions
- 🔧 **Customizable** - Easily modify snippets to match your standards

## Installation

### Method 1: VS Code User Snippets

1. Open Visual Studio Code
2. Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (Mac)
3. Type "Preferences: Configure User Snippets"
4. Select "powershell.json" (PowerShell)
5. Copy the contents of `powershell.json` from this folder
6. Paste into your user snippets file
7. Save the file

### Method 2: Workspace Snippets

1. In your PSAppDeployToolkit workspace, create a `.vscode` folder if it doesn't exist
2. Copy `powershell.json` to `.vscode/powershell.json`
3. Restart VS Code or reload the window

## Available Snippets

### Custom Detection Registry Key
**Prefix:** `PSADT`
**Trigger:** Type "PSADT" and select "Add Custom Detection Registry Key"

Creates a registry key for application detection in deployment tools (Intune, SCCM, etc.).

```powershell
# Custom Application Detection Registry Key
$CustomerName = "CustomerName"
$CustomerKeyName = "$($adtSession.AppVendor)_$($adtSession.AppName)_$($adtSession.AppVersion)_$($adtSession.AppArch)"
Set-ADTRegistryKey -LiteralPath "HKEY_LOCAL_MACHINE\SOFTWARE\$($CustomerName)\Applications\$($CustomerKeyName)" -Name 'Installed' -Type 'DWord' -Value '1'
```

### App Script Author
**Prefix:** `PSADT`
**Trigger:** Type "PSADT" and select "AppScriptAuthor"

Inserts author name placeholder.

### App Script Date
**Prefix:** `PSADT`
**Trigger:** Type "PSADT" and select "AppScriptDate"

Inserts current date in YYYY-MM-DD format automatically.

## How to Use Snippets

1. **Open a PowerShell script** in VS Code (`.ps1` file)
2. **Type the prefix** (e.g., "PSADT")
3. **Select the snippet** from the IntelliSense dropdown
4. **Tab through fields** to customize placeholder values
5. **Press Escape** when done to exit snippet mode

## Snippet Structure

Each snippet in `powershell.json` follows this structure:

```json
{
    "Snippet Name": {
        "prefix": "PSADT",
        "body": [
            "Line 1 of code",
            "Line 2 of code"
        ],
        "description": "What the snippet does"
    }
}
```

## Creating Custom Snippets

To add your own snippets:

1. Open `powershell.json`
2. Add a new entry following the structure above
3. Use `$1`, `$2`, etc. for tab stops
4. Use `${1:placeholder}` for tab stops with default text
5. Use special variables:
   - `$CURRENT_YEAR` - Current year
   - `$CURRENT_MONTH` - Current month (2 digits)
   - `$CURRENT_DATE` - Current day (2 digits)

### Example Custom Snippet

```json
{
    "PSADT Install MSI": {
        "prefix": "PSADT",
        "body": [
            "# Install MSI package",
            "Invoke-ADTMsiPackage -Action 'Install' -Path '${1:package.msi}' -Parameters '${2:/qn}'"
        ],
        "description": "Install an MSI package"
    }
}
```

## Common PSAppDeployToolkit Patterns

While creating your snippets, consider these common patterns:

### Installation Commands
- `Start-ADTProcess` - Execute installers
- `Invoke-ADTMsiPackage` - Install/uninstall MSI packages
- `Copy-ADTFile` - Copy files to destination
- `Remove-ADTFile` - Remove files/folders

### Registry Operations
- `Set-ADTRegistryKey` - Create/modify registry keys
- `Remove-ADTRegistryKey` - Remove registry keys
- `Get-ADTRegistryKey` - Read registry values

### User Interface
- `Show-ADTInstallationWelcome` - Welcome dialog
- `Show-ADTInstallationProgress` - Progress dialog
- `Show-ADTInstallationPrompt` - Custom prompts

### System Operations
- `Stop-ADTProcess` - Close running processes
- `Get-ADTInstalledApplication` - Query installed apps
- `Test-ADTPendingReboot` - Check for pending reboots

## Best Practices

### Snippet Naming
- Use descriptive names that indicate the snippet's purpose
- Keep prefixes consistent (e.g., "PSADT" for all snippets)
- Group related snippets with similar naming

### Code Quality
- Include comments in snippet body for clarity
- Use PSAppDeployToolkit v4.x syntax and conventions
- Follow PowerShell best practices (approved verbs, proper formatting)

### Maintenance
- Update snippets when PSAppDeployToolkit releases new versions
- Test snippets regularly to ensure they work as expected
- Document any custom modifications

## Integration with IntelliSense

For full IntelliSense support with PSAppDeployToolkit:

1. Import PSAppDeployToolkit module in VS Code
2. Follow the guide in the [CheatSheet README](../CheatSheet/README.md)
3. Combine with snippets for maximum productivity

## VS Code Settings

Enhance snippet experience with these VS Code settings:

```json
{
    "editor.tabCompletion": "on",
    "editor.quickSuggestions": {
        "other": true,
        "comments": false,
        "strings": true
    },
    "editor.suggest.snippetsPreventQuickSuggestions": false
}
```

## Troubleshooting

### Snippets Not Appearing
- Ensure you're in a `.ps1` file
- Check that `powershell.json` is in the correct location
- Verify JSON syntax is valid (no trailing commas, proper brackets)
- Restart VS Code

### Wrong Language Context
- Snippets are language-specific
- Ensure file is recognized as PowerShell
- Check VS Code language mode in the bottom-right corner

### Tab Stops Not Working
- Press `Tab` to move between placeholders
- Press `Shift+Tab` to move backward
- Press `Escape` to exit snippet mode

## Related Resources

- **CheatSheet** - Quick reference for PSAppDeployToolkit commands
- **Template** - Complete project structure and examples
- **PSAppDeployToolkit Documentation** - [https://psappdeploytoolkit.com/docs](https://psappdeploytoolkit.com/docs)
- **VS Code Snippets Guide** - [https://code.visualstudio.com/docs/editor/userdefinedsnippets](https://code.visualstudio.com/docs/editor/userdefinedsnippets)

## Contributing

To contribute new snippets:

1. Test the snippet thoroughly
2. Follow the existing naming conventions
3. Add clear descriptions
4. Document any special requirements
5. Submit via pull request or issue

## Author

**Fredrik Wall**
- Email: wall.fredrik@gmail.com
- Blog: [www.poweradmin.se](http://www.poweradmin.se)
- Twitter: [@walle75](https://twitter.com/walle75)
- GitHub: [https://github.com/FredrikWall](https://github.com/FredrikWall)

## Version History

### Version 1.0
- Initial snippet collection for PSAppDeployToolkit v4.x
- Custom detection registry key snippet
- Author and date snippets
- Basic installation patterns

## License

See the LICENSE file in the repository root for license information.

## Tips & Tricks

### Multiple Snippets in One File
You can chain snippets together by using multiple snippet insertions in sequence.

### Snippet Shortcuts
- `Tab` - Move to next placeholder
- `Shift+Tab` - Move to previous placeholder
- `Escape` - Exit snippet mode
- `Ctrl+Space` - Trigger IntelliSense manually

### Version Control
Track your `powershell.json` in version control to share snippets across teams and maintain consistency.

### Snippet Testing
Before adding snippets to your main file, test them in a scratch file to ensure proper formatting and functionality.
