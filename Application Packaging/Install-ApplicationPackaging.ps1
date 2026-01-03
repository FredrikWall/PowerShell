<#
.SYNOPSIS
    Sets up a complete application packaging environment with tools, templates, and icons.

.DESCRIPTION
    This script automates the setup of an application packaging environment by:
    1. Creating a standardized folder structure for application packaging
    2. Downloading essential packaging tools
    3. Downloading PowerShell App Deployment Toolkit (PSADT) templates
    4. Downloading a collection of application icons
    
    All scripts are downloaded from the FredrikWall/PowerShell GitHub repository and
    executed in the current session using Invoke-Expression.

.PARAMETER None
    This script does not accept parameters. All paths are hardcoded to C:\ApplicationPackaging.

.EXAMPLE
    .\Install-ApplicationPackaging.ps1
    
    Executes the complete setup process, creating folders and downloading all required files
    to C:\ApplicationPackaging.

.NOTES
    Author:  Fredrik Wall
    Email:   wall.fredrik@gmail.com
    Blog:    www.poweradmin.se
    Twitter: @walle75
    Created: 2026-01-02
    Updated: 2026-01-02
    Version: 1.0
    Requires: Internet connection to download remote scripts and resources
    Requires: Administrative privileges may be required to write to C:\
    
.LINK
    https://github.com/FredrikWall/PowerShell
#>

# Clear the console for a clean output display
Clear-Host

#region Create Application Package Structure
# Download and execute the New-ApplicationPackageStructure script
# This creates the base folder structure at C:\ApplicationPackaging
Write-Output "Creating Application Package Structure..."

# Define the URI for the remote script (URL-encoded for spaces)
$uri = "https://raw.githubusercontent.com/FredrikWall/PowerShell/master/Application%20Packaging/New-ApplicationPackageStructure.ps1"

# Download the script content from GitHub and execute it in the current session
# Invoke-Expression executes the downloaded script, loading its functions into memory
Invoke-Expression (Invoke-WebRequest -Uri $uri -Headers @{ "User-Agent" = "PowerShell" }).Content

# Call the function that was just loaded to create the folder structure
New-ApplicationPackageStructure -Path "C:\"

# Add blank line for better readability in output
Write-Output ""
#endregion

#region Download Packaging Tools
# Download and execute the Invoke-DownloadPackagingTools script
# This downloads essential tools like 7-Zip, Notepad++, etc. to the Tools folder
Write-Output "Downloading Application Packaging Tools..."

# Define the URI for the packaging tools download script
$uri = "https://raw.githubusercontent.com/FredrikWall/PowerShell/master/Application%20Packaging/Invoke-DownloadPackagingTools.ps1"

# Download and execute the script to load the Invoke-DownloadPackagingTools function
Invoke-Expression (Invoke-WebRequest -Uri $uri -Headers @{ "User-Agent" = "PowerShell" }).Content

# Execute the function to download tools to the designated Tools folder
Invoke-DownloadPackagingTools -DestinationPath "C:\ApplicationPackaging\04_Tools"

# Add blank line for better readability in output
Write-Output ""
#endregion

#region Download PSADT Templates
# Download and execute the Invoke-DownloadPSADTTemplates script
# This downloads PowerShell App Deployment Toolkit templates for packaging applications
Write-Output "Downloading PSADT Templates..."

# Define the URI for the PSADT templates download script
$uri = "https://raw.githubusercontent.com/FredrikWall/PowerShell/master/Application%20Packaging/Invoke-DownloadPSADTTemplates.ps1"

# Download and execute the script to load the Invoke-DownloadPSADTTemplates function
Invoke-Expression (Invoke-WebRequest -Uri $uri -Headers @{ "User-Agent" = "PowerShell" }).Content

# Execute the function to download PSADT templates to the Templates folder
Invoke-DownloadPSADTTemplates -DestinationPath "C:\ApplicationPackaging\01_Templates"

# Add blank line for better readability in output
Write-Output ""
#endregion

#region Download Application Icons
# Download and execute the Invoke-DownloadIcons script
# This downloads a collection of application icons for use in packaging
Write-Output "Downloading Icons..."

# Define the URI for the icons download script
$uri = "https://raw.githubusercontent.com/FredrikWall/PowerShell/master/Application%20Packaging/Invoke-DownloadIcons.ps1"

# Download and execute the script to load the Invoke-DownloadIcons function
Invoke-Expression (Invoke-WebRequest -Uri $uri -Headers @{ "User-Agent" = "PowerShell" }).Content

# Execute the function to download icons to the designated Icons folder
Invoke-DownloadIcons -DestinationPath "C:\ApplicationPackaging\05_Icons"

# Add blank line for better readability in output
Write-Output ""
#endregion
