function Copy-ApplicationIcon {
    <#
    .SYNOPSIS
        Copies an application icon to the application package icon folder.
    
    .DESCRIPTION
        The Copy-ApplicationIcon function copies an icon file from a source location 
        to the destination application package's icon folder. It validates that both 
        the source icon and destination folder exist before copying.
        
        Supported icon formats: .ico, .png, .jpg, .jpeg, .bmp, .gif
    
    .PARAMETER SourceIconPath
        The full path to the source icon file. Can be a file path or just a filename 
        if the icon is in a standard location.
    
    .PARAMETER DestinationPath
        The path to the application package folder where the icon should be copied.
        The function will automatically append '\ICON' to this path.
    
    .PARAMETER Force
        If specified, overwrites the icon file if it already exists in the destination.
    
    .EXAMPLE
        Copy-ApplicationIcon -SourceIconPath "C:\Icons\MyApp.ico" -DestinationPath "C:\Packages\Vendor_App_1.0_x64_01"
        
        Copies MyApp.ico to C:\Packages\Vendor_App_1.0_x64_01\ICON\MyApp.ico
    
    .EXAMPLE
        Copy-ApplicationIcon -SourceIconPath "C:\Icons\MyApp.png" -DestinationPath "C:\Packages\Vendor_App_1.0_x64_01" -Force
        
        Copies MyApp.png to the destination, overwriting if it exists.
    
    .EXAMPLE
        Get-ChildItem "C:\Icons\*.ico" | ForEach-Object { Copy-ApplicationIcon -SourceIconPath $_.FullName -DestinationPath "C:\Packages\App_01" }
        
        Copies multiple icons to the destination folder.
    
    .INPUTS
        System.String. You can pipe icon file paths to this function.
    
    .OUTPUTS
        None. The function displays verbose messages about the copy operation.
    
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
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Icon', 'IconPath')]
        [ValidateNotNullOrEmpty()]
        [string]$SourceIconPath,
        
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DestinationPath,
        
        [Parameter(Mandatory = $false)]
        [switch]$Force
    )
    
    process {
        try {
            # Validate source icon exists
            if (-not (Test-Path -Path $SourceIconPath -PathType Leaf)) {
                Write-Error "Source icon file does not exist: $SourceIconPath"
                return
            }
            
            # Validate icon file extension
            $validExtensions = @('.ico', '.png', '.jpg', '.jpeg', '.bmp', '.gif')
            $sourceFile = Get-Item -Path $SourceIconPath
            if ($sourceFile.Extension.ToLower() -notin $validExtensions) {
                Write-Error "Invalid icon file format. Supported formats: $($validExtensions -join ', ')"
                return
            }
            
            # Construct destination icon folder path
            $iconFolderPath = Join-Path -Path $DestinationPath -ChildPath "ICON"
            
            # Validate destination folder exists
            if (-not (Test-Path -Path $iconFolderPath -PathType Container)) {
                Write-Error "Destination ICON folder does not exist: $iconFolderPath"
                return
            }
            
            # Construct full destination file path
            $destinationFilePath = Join-Path -Path $iconFolderPath -ChildPath $sourceFile.Name
            
            # Check if file already exists
            if ((Test-Path -Path $destinationFilePath) -and -not $Force) {
                Write-Warning "Icon file already exists at destination: $destinationFilePath. Use -Force to overwrite."
                return
            }
            
            # Copy the icon file
            Copy-Item -Path $SourceIconPath -Destination $destinationFilePath -Force:$Force -ErrorAction Stop
            
            Write-Verbose "Successfully copied icon from '$SourceIconPath' to '$destinationFilePath'"
            
        }
        catch {
            Write-Error "Failed to copy icon file: $($_.Exception.Message)"
        }
    }
}