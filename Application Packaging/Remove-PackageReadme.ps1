function Remove-PackageReadme {
    <#
    .SYNOPSIS
        Removes README.md files from an application package structure.
    
    .DESCRIPTION
        The Remove-PackageReadme function recursively searches for and removes README.md files
        within an application package folder structure. This is useful for cleaning up template
        files after creating a new application package.
        
        By default, the function supports -WhatIf to preview what would be deleted.
    
    .PARAMETER Path
        The path to the application package folder to clean. Can be the root package folder
        or a specific subfolder. The function will recursively search all subfolders.
    
    .PARAMETER Force
        If specified, suppresses confirmation prompts and removes files without asking.
    
    .EXAMPLE
        Remove-PackageReadme -Path "C:\Packages\Vendor_App_1.0_x64_01"
        
        Removes all README.md files from the package folder and its subfolders.
    
    .EXAMPLE
        Remove-PackageReadme -Path "C:\Packages\Vendor_App_1.0_x64_01" -WhatIf
        
        Shows what README.md files would be removed without actually deleting them.
    
    .EXAMPLE
        Remove-PackageReadme -Path "C:\Packages\Vendor_App_1.0_x64_01" -Force
        
        Removes all README.md files without confirmation prompts.
    
    .EXAMPLE
        Get-ChildItem "C:\Packages" -Directory | Remove-PackageReadme -Force
        
        Removes README.md files from all package folders in the Packages directory.
    
    .INPUTS
        System.String. You can pipe folder paths to this function.
    
    .OUTPUTS
        None. The function displays verbose messages about the removal operations.
    
    .NOTES
        Author:  Fredrik Wall
        Email:   wall.fredrik@gmail.com
        Blog:    www.poweradmin.se
        Twitter: @walle75
        Created: 2026-01-03
        Updated: 2026-01-03
        Version: 1.0
        
        Changelog:
        1.0 (2026-01-03) - Initial version
    
    .LINK
        https://github.com/FredrikWall/PowerShell
    #>
    
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('FullName', 'PSPath')]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        
        [Parameter(Mandatory = $false)]
        [switch]$Force
    )
    
    process {
        try {
            # Validate path exists
            if (-not (Test-Path -Path $Path -PathType Container)) {
                Write-Error "Path does not exist or is not a directory: $Path"
                return
            }
            
            Write-Verbose "Searching for README.md files in: $Path"
            
            # Find all README.md files
            $searchParams = @{
                Path = $Path
                Filter = 'README.md'
                File = $true
                Recurse = $true
                ErrorAction = 'Stop'
            }
            
            $readmeFiles = Get-ChildItem @searchParams
            
            if ($readmeFiles.Count -eq 0) {
                Write-Verbose "No README.md files found in: $Path"
                return
            }
            
            Write-Verbose "Found $($readmeFiles.Count) README.md file(s)"
            
            # Remove each README.md file
            foreach ($file in $readmeFiles) {
                if ($Force -or $PSCmdlet.ShouldProcess($file.FullName, "Remove README.md")) {
                    try {
                        Remove-Item -Path $file.FullName -Force -ErrorAction Stop
                        Write-Verbose "Removed: $($file.FullName)"
                    }
                    catch {
                        Write-Error "Failed to remove '$($file.FullName)': $($_.Exception.Message)"
                    }
                }
            }
            
            if (-not $Force -and -not $WhatIfPreference) {
                Write-Verbose "Successfully processed $($readmeFiles.Count) README.md file(s) in: $Path"
            }
        }
        catch {
            Write-Error "Failed to process path '$Path': $($_.Exception.Message)"
        }
    }
}
