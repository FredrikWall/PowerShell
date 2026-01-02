function Invoke-DownloadPSADTTemplates {
    <#
    .SYNOPSIS
        Download PSAppDeployToolkit templates from GitHub repository
    
    .DESCRIPTION
        Downloads all PSAppDeployToolkit template files recursively from Fredrik Wall's PowerShell
        GitHub repository. The function downloads the repository as a ZIP file, extracts it, and
        copies files from the PSAppDeployToolkit/Template folder to the specified local directory.
        This method avoids GitHub API rate limits and is faster than downloading files individually.
    
    .PARAMETER DestinationPath
        The local path where the downloaded templates will be saved. If the directory doesn't exist,
        it will be created automatically. Defaults to ".\PSADTTemplates" in the current directory.
    
    .EXAMPLE
        Invoke-DownloadPSADTTemplates
        Downloads all PSADT templates to the default PSADTTemplates folder in the current directory
    
    .EXAMPLE
        Invoke-DownloadPSADTTemplates -DestinationPath "C:\ApplicationPackaging\Templates"
        Downloads all PSADT templates to C:\ApplicationPackaging\Templates
    
    .EXAMPLE
        Invoke-DownloadPSADTTemplates -DestinationPath "$env:USERPROFILE\Documents\PSADTTemplates" -Verbose
        Downloads all PSADT templates to the Documents folder with verbose output
    
    .INPUTS
        None. You cannot pipe objects to Invoke-DownloadPSADTTemplates.
    
    .OUTPUTS
        None. The function downloads files to the specified destination path.
    
    .NOTES
        Author:  Fredrik Wall
        Email:   wall.fredrik@gmail.com
        Blog:    www.poweradmin.se
        Twitter: @walle75
        Created: 2026-01-02
        Updated: 2026-01-02
        Version: 1.1
        
        Changelog:
        1.1 (2026-01-02) - Changed to ZIP download method, no API rate limits, faster downloads
        1.0 (2026-01-02) - Initial version with GitHub API integration
        
        Repository: https://github.com/FredrikWall/PowerShell
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$DestinationPath = ".\PSADTTemplates"
    )
    
    begin {
        $owner = "FredrikWall"
        $repo = "PowerShell"
        $sourcePath = "PSAppDeployToolkit/Template"
        
        # Ensure destination path exists
        if (-not (Test-Path -Path $DestinationPath)) {
            Write-Verbose "Creating destination directory: $DestinationPath"
            $null = New-Item -Path $DestinationPath -ItemType Directory -Force
        }
        
        # Convert to absolute path if it exists
        if (Test-Path -Path $DestinationPath) {
            $DestinationPath = (Resolve-Path -Path $DestinationPath).Path
        }
    }
    
    process {
        $tempZip = $null
        $tempExtract = $null
        
        try {
            # Create temp paths
            $tempZip = Join-Path -Path $env:TEMP -ChildPath "$repo-$(Get-Date -Format 'yyyyMMddHHmmss').zip"
            $tempExtract = Join-Path -Path $env:TEMP -ChildPath "$repo-extract-$(Get-Date -Format 'yyyyMMddHHmmss')"
            
            Write-Host "Starting PSADT template download..." -ForegroundColor Cyan
            Write-Host "Repository: $owner/$repo" -ForegroundColor Cyan
            Write-Host "Destination: $DestinationPath" -ForegroundColor Cyan
            Write-Host ""
            
            # Download repository as ZIP
            $zipUrl = "https://github.com/$owner/$repo/archive/refs/heads/master.zip"
            Write-Host "Downloading repository ZIP..." -ForegroundColor Cyan
            Write-Verbose "URL: $zipUrl"
            Write-Verbose "Temp ZIP: $tempZip"
            
            Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing -ErrorAction Stop
            Write-Host "Repository downloaded successfully" -ForegroundColor Green
            
            # Extract ZIP
            Write-Host "Extracting archive..." -ForegroundColor Cyan
            Write-Verbose "Extract path: $tempExtract"
            Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force -ErrorAction Stop
            Write-Host "Archive extracted successfully" -ForegroundColor Green
            
            # Find the template folder (accounting for repo name in extracted folder)
            $extractedRepoFolder = Get-ChildItem -Path $tempExtract -Directory | Select-Object -First 1
            $templateSourcePath = Join-Path -Path $extractedRepoFolder.FullName -ChildPath $sourcePath
            
            Write-Verbose "Template source path: $templateSourcePath"
            
            if (-not (Test-Path -Path $templateSourcePath)) {
                throw "Template folder not found at expected path: $templateSourcePath"
            }
            
            # Get all files recursively
            Write-Host "Collecting template files..." -ForegroundColor Cyan
            $templateFiles = Get-ChildItem -Path $templateSourcePath -Recurse -File
            
            Write-Host "Found $($templateFiles.Count) files" -ForegroundColor Green
            Write-Host "Copying files..." -ForegroundColor Cyan
            
            # Copy files maintaining folder structure
            $copiedCount = 0
            foreach ($file in $templateFiles) {
                # Calculate relative path from template source
                $relativePath = $file.FullName.Substring($templateSourcePath.Length + 1)
                $destinationFile = Join-Path -Path $DestinationPath -ChildPath $relativePath
                
                # Ensure subdirectory exists
                $destinationDir = Split-Path -Path $destinationFile -Parent
                if (-not (Test-Path -Path $destinationDir)) {
                    $null = New-Item -Path $destinationDir -ItemType Directory -Force
                }
                
                Write-Verbose "Copying: $relativePath"
                Copy-Item -Path $file.FullName -Destination $destinationFile -Force
                $copiedCount++
                
                # Show progress for every 10 files
                if ($copiedCount % 10 -eq 0) {
                    Write-Host "  Copied $copiedCount of $($templateFiles.Count) files..." -ForegroundColor Gray
                }
            }
            
            Write-Host "`nDownload completed successfully!" -ForegroundColor Green
            Write-Host "Copied $copiedCount files to: $DestinationPath" -ForegroundColor Green
        }
        catch {
            Write-Error "Failed to complete PSADT template download: $($_.Exception.Message)"
            throw
        }
        finally {
            # Clean up temp files
            Write-Verbose "Cleaning up temporary files..."
            if ($tempZip -and (Test-Path -Path $tempZip)) {
                Remove-Item -Path $tempZip -Force -ErrorAction SilentlyContinue
                Write-Verbose "Removed temp ZIP: $tempZip"
            }
            if ($tempExtract -and (Test-Path -Path $tempExtract)) {
                Remove-Item -Path $tempExtract -Recurse -Force -ErrorAction SilentlyContinue
                Write-Verbose "Removed temp extract folder: $tempExtract"
            }
        }
    }
}