function Invoke-DownloadApplication {
    <#
    .SYNOPSIS
        Download an application from a URL
    
    .DESCRIPTION
        Downloads an application file from a specified URL with improved speed by
        suppressing the progress bar. Automatically restores the original progress
        preference after download completes.
    
    .PARAMETER Url
        The URL of the application to be downloaded. Must be a valid HTTP or HTTPS URL.
    
    .PARAMETER Destination
        The full path where the downloaded file will be saved, including filename and extension.
    
    .EXAMPLE
        Invoke-DownloadApplication -Url "https://www.apple.com/itunes/download/win64" -Destination "$env:TEMP\iTunes64Setup.exe"
        Downloads the latest version of iTunes to the temp folder
    
    .EXAMPLE
        Invoke-DownloadApplication -Url "https://example.com/app.exe" -Destination "C:\Downloads\application.exe"
        Downloads a file to a specific location
    
    .INPUTS
        None. You cannot pipe objects to Invoke-DownloadApplication.
    
    .OUTPUTS
        None. The function downloads a file to the specified destination.
    
    .NOTES
        Author:  Fredrik Wall
        Email:   wall.fredrik@gmail.com
        Blog:    www.poweradmin.se
        Twitter: @walle75
        Created: 2018-02-08
        Updated: 2025-12-31
        Version: 1.2
        
        Changelog:
        1.2 (2025-12-31) - Updated help, improved error handling, added parameter validation, better variable naming
        1.1 (2021-01-12) - Restores original ProgressPreference setting, improved error messages
        1.0 (2018-02-08) - Initial version
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [uri]$Url,
        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Destination
    )
    
    begin {
        # Store original progress preference
        $originalProgressPreference = $ProgressPreference
    }
    
    process {
        try {
            # Suppress progress bar for better download speed
            $ProgressPreference = 'SilentlyContinue'
            
            Write-Verbose "Downloading from: $Url"
            Write-Verbose "Saving to: $Destination"
            
            # Ensure destination directory exists
            $destinationDir = Split-Path -Path $Destination -Parent
            if ($destinationDir -and -not (Test-Path -Path $destinationDir)) {
                Write-Verbose "Creating directory: $destinationDir"
                $null = New-Item -Path $destinationDir -ItemType Directory -Force
            }
            
            # Download the file
            Invoke-WebRequest -Uri $Url -OutFile $Destination -ErrorAction Stop -UseBasicParsing
            
            Write-Verbose "Download completed successfully"
        }
        catch {
            Write-Error "Failed to download application from '$Url': $($_.Exception.Message)"
            throw
        }
        finally {
            # Always restore original progress preference
            $ProgressPreference = $originalProgressPreference
        }
    }
}