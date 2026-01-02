function New-ApplicationPackageStructure {
    <#
    .SYNOPSIS
        Creates a new directory structure for application packages.
    
    .DESCRIPTION
        This function creates a predefined directory structure for managing application packages.
        Creates a root ApplicationPackaging folder with organized subdirectories for templates,
        production packages, development packages, tools, icons, and temporary files.
    
    .PARAMETER Path
        The base path where the application package structure will be created.
        The function will create an "ApplicationPackaging" folder at this location.
    
    .EXAMPLE
        New-ApplicationPackageStructure -Path "C:\Code\ApplicationPackage"
        Creates the application packaging structure at C:\Code\ApplicationPackage\ApplicationPackaging
    
    .EXAMPLE
        New-ApplicationPackageStructure -Path "D:\Projects" -Verbose
        Creates the structure with verbose output showing each directory created
    
    .NOTES
        Author:  Fredrik Wall
        Email:   wall.fredrik@gmail.com
        Blog:    www.poweradmin.se
        Twitter: @walle75
        Created: 2024-01-01
        Updated: 2026-01-02
        Version: 1.2
        
        Changelog:
        1.2 (2026-01-02) - Some changes to the folder structure 
        1.1 (2025-12-31) - Optimized performance, improved error handling, removed redundant Test-Path checks
        1.0 (2024-01-01) - Initial version
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )
    
    begin {
        # Create base path if it doesn't exist
        if (-not (Test-Path -Path $Path -PathType Container)) {
            Write-Verbose "Base path '$Path' does not exist. Creating it..."
            try {
                $null = New-Item -Path $Path -ItemType Directory -Force -ErrorAction Stop
            }
            catch {
                throw "Failed to create base path '$Path': $_"
            }
        }
        
        # Define folder structure
        $folders = @(
            "01_Templates",
            "02_Dev",
            "03_Prod",
            "04_Tools",
            "05_Icons",
            "06_Downloads",
            "07_Temp"
        )
        
        $basePath = Join-Path -Path $Path -ChildPath "ApplicationPackaging"
    }
    
    process {
        try {
            # Check if base directory already exists
            if (Test-Path -Path $basePath -PathType Container) {
                Write-Verbose "The ApplicationPackaging directory already exists at $basePath"
                return
            }
            
            # Create base directory
            Write-Verbose "Creating ApplicationPackaging directory at $basePath"
            $null = New-Item -Path $basePath -ItemType Directory -Force -ErrorAction Stop
            
            # Create all subdirectories in one pass using -Force (no need to check if they exist)
            foreach ($folder in $folders) {
                $folderPath = Join-Path -Path $basePath -ChildPath $folder
                Write-Verbose "Creating subdirectory: $folder"
                $null = New-Item -Path $folderPath -ItemType Directory -Force -ErrorAction Stop
            }
            
            Write-Output "Successfully created application package structure at $basePath"
        }
        catch {
            Write-Error "Failed to create directory structure: $_"
            throw
        }
    }
}