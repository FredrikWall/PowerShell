function New-ApplicationPackage {
    <#
    .SYNOPSIS
        Creates a new application package from a template.
    
    .DESCRIPTION
        The New-ApplicationPackage function creates a new application package by copying a template
        structure to a destination path and populating it with application-specific information.
        This is typically used with PowerShell App Deployment Toolkit (PSADT) templates for
        standardized application packaging.
    
    .PARAMETER Name
        The name of the application to package (e.g., "Notepad++", "7-Zip").
    
    .PARAMETER Version
        The version number of the application (e.g., "1.0.0", "8.5.3").
    
    .PARAMETER Vendor
        The vendor or publisher of the application (e.g., "Microsoft", "Adobe", "Mozilla").
    
    .PARAMETER TemplatePath
        The full path to the template directory that will be used as the basis for the new package.
        This should be a directory containing the PSADT template structure.
    
    .PARAMETER Path
        The path where the new application package will be created.
    
    .PARAMETER Language
        The language code for the package. Defaults to 'EN' (English).
        Examples: EN, SV (Swedish), DA (Danish), NO (Norwegian), DE (German).
    
    .PARAMETER Architecture
        The target architecture for the application package. Defaults to 'x64'.
        Valid values: x86, x64, ARM64, Any.
    
    .PARAMETER Creator
        The name of the person creating the package. Defaults to the current username ($env:USERNAME).
    
    .PARAMETER CreationDate
        The creation date for the package. Defaults to the current date and time.
    
    .EXAMPLE
        New-ApplicationPackage -Name "7-Zip" -Version "23.01" -Vendor "Igor Pavlov" -TemplatePath "C:\Templates\PSADT" -Path "C:\Packages"
        
        Creates a new package for 7-Zip version 23.01 using default values for Language (EN), 
        Architecture (x64), Creator (current user), and CreationDate (current date).
    
    .EXAMPLE
        New-ApplicationPackage -Name "Notepad++" -Version "8.5.8" -Vendor "Don Ho" -TemplatePath "C:\Templates\PSADT" -Path "C:\Packages" -Language "SV" -Architecture "x86"
        
        Creates a new package for Notepad++ with Swedish language and x86 architecture.
    
    .EXAMPLE
        New-ApplicationPackage -Name "Chrome" -Version "120.0" -Vendor "Google" -TemplatePath "C:\ApplicationPackaging\01_Templates\PSAppDeployToolkit v4.1.7\App_Vendor_Application_Version_Architecture" -Path "C:\ApplicationPackaging\02_Dev" -Creator "John Doe"
        
        Creates a new Chrome package with a specific creator name.
    
    .EXAMPLE
        [PSCustomObject]@{Name="Firefox"; Version="121.0"; Vendor="Mozilla"; TemplatePath="C:\Templates\PSADT"; Path="C:\Packages"} | New-ApplicationPackage
        
        Creates a package by piping an object with property names matching the function parameters.
    
    .EXAMPLE
        Import-Csv "C:\Apps.csv" | New-ApplicationPackage
        
        Creates multiple packages by piping data from a CSV file containing Name, Version, Vendor, 
        TemplatePath, and Path columns.
    
    .NOTES
        Author:  Fredrik Wall
        Email:   wall.fredrik@gmail.com
        Blog:    www.poweradmin.se
        Twitter: @walle75
        Created: 2026-01-03
        Updated: 2026-01-03
        Version: 1.1
        
        Changelog:
        1.1 (2026-01-03) - Added comment based help, examples, and pipeline support
        1.0 (2024-01-12) - Initial version
    
    .LINK
        https://github.com/FredrikWall/PowerShell
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Name,
        
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Version,
        
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Vendor,
        
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$TemplatePath,
        
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Path,
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$Language = 'EN',
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('x86', 'x64', 'ARM64', 'Any')]
        [string]$Architecture = 'x64',
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$Creator = $env:USERNAME,
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [datetime]$CreationDate = (Get-Date)
    )
    
    process {
        # Validate template path exists
        if (-not (Test-Path -Path $TemplatePath -PathType Container)) {
            Write-Error "Template path does not exist: $TemplatePath"
            return
        }

        # Validate destination path exists
        if (-not (Test-Path -Path $Path -PathType Container)) {
            Write-Error "Path does not exist: $Path"
            return
        }

        # Create the package folder name in format: Vendor_Name_Version_Architecture_01
        $packageFolderName = "${Vendor}_${Name}_${Version}_${Architecture}_01"
        
        # Remove any invalid characters from the folder name
        $invalidChars = [System.IO.Path]::GetInvalidFileNameChars()
        $invalidChars | ForEach-Object {
            $packageFolderName = $packageFolderName.Replace($_, '_')
        }
        
        # Build the full package path
        $packagePath = Join-Path -Path $Path -ChildPath $packageFolderName
        
        # Display package information
        Write-Verbose "Creating application package..."
        Write-Verbose "Name: $Name"
        Write-Verbose "Version: $Version"
        Write-Verbose "Vendor: $Vendor"
        Write-Verbose "Language: $Language"
        Write-Verbose "Architecture: $Architecture"
        Write-Verbose "Creator: $Creator"
        Write-Verbose "Creation Date: $($CreationDate.ToString('yyyy-MM-dd'))"
        Write-Verbose "Template Path: $TemplatePath"
        Write-Verbose "Path: $Path"
        Write-Verbose "Package Folder: $packageFolderName"
        
        try {
            # Check if package folder already exists
            if (Test-Path -Path $packagePath) {
                Write-Warning "Package folder already exists: $packagePath"
                return
            }
            
            # Copy template to the new package folder
            Write-Verbose "Copying template from '$TemplatePath' to '$packagePath'..."
            Copy-Item -Path $TemplatePath -Destination $packagePath -Recurse -Force -ErrorAction Stop
            
            Write-Verbose "Successfully created package at: $packagePath"
        }
        catch {
            Write-Error "Failed to create package: $_"
            return
        }
    }
}