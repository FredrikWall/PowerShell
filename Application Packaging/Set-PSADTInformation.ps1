function Set-PSADTInformation {
    <#
    .SYNOPSIS
        Updates the PSADT Invoke-AppDeployToolkit.ps1 file with application information.
    
    .DESCRIPTION
        The Set-PSADTInformation function updates the $adtSession variables in the PSADT
        Invoke-AppDeployToolkit.ps1 file with application information. It can accept parameters
        directly or import them from a JSON file created by New-ApplicationInformationFile.
    
    .PARAMETER PSADTPath
        The path to the PSADT folder containing the Invoke-AppDeployToolkit.ps1 file.
        This should be the folder that contains the PSADT subfolder structure.
    
    .PARAMETER JsonPath
        The path to the Application_Information.json file to import settings from.
        If specified, all other parameters except PSADTPath will be ignored.
    
    .PARAMETER Name
        The name of the application.
    
    .PARAMETER Version
        The version number of the application.
    
    .PARAMETER Vendor
        The vendor or publisher of the application.
    
    .PARAMETER Language
        The language code for the package. Defaults to 'EN'.
    
    .PARAMETER Architecture
        The target architecture. Defaults to 'x64'.
        Valid values: x86, x64, ARM64, Any.
    
    .PARAMETER Revision
        The revision number for the package. Defaults to '01'.
    
    .PARAMETER Creator
        The name of the script author/creator.
    
    .PARAMETER CreationDate
        The script creation date.
    
    .PARAMETER ScriptVersion
        The script version. Defaults to '1.0.0'.
    
    .EXAMPLE
        Set-PSADTInformation -PSADTPath "C:\Packages\MyVendor_MyApp_1.0_x64_01" -JsonPath "C:\Packages\MyVendor_MyApp_1.0_x64_01\DOC\Application_Information.json"
        
        Updates the PSADT script using information from the JSON file.
    
    .EXAMPLE
        Set-PSADTInformation -PSADTPath "C:\Packages\MyApp" -Name "MyApp" -Version "1.0.0" -Vendor "MyVendor" -Architecture "x64"
        
        Updates the PSADT script with the specified parameters.
    
    .EXAMPLE
        $appInfo = Get-Content "C:\Packages\DOC\Application_Information.json" | ConvertFrom-Json
        Set-PSADTInformation -PSADTPath "C:\Packages" -JsonPath "C:\Packages\DOC\Application_Information.json"
        
        Imports settings from JSON and updates the PSADT script.
    
    .NOTES
        Author:  Fredrik Wall
        Email:   wall.fredrik@gmail.com
        Blog:    www.poweradmin.se
        Twitter: @walle75
        Created: 2025-08-13
        Updated: 2026-01-03
        Version: 1.2
        
        Changelog:
        1.2 (2026-01-03) - Added better pipeline support
        1.1 (2025-12-31) - Added JSON import functionality
        1.0 (2025-08-13) - Initial version
    
    .LINK
        https://github.com/FredrikWall/PowerShell
    #>
    
    [CmdletBinding(DefaultParameterSetName = 'Parameters')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Parameters')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Json')]
        [ValidateScript({ Test-Path $_ -PathType Container })]
        [string]$PSADTPath,
        
        [Parameter(Mandatory = $true, ParameterSetName = 'Json')]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$JsonPath,
        
        [Parameter(Mandatory = $true, ParameterSetName = 'Parameters', ValueFromPipelineByPropertyName = $true)]
        [string]$Name,
        
        [Parameter(Mandatory = $true, ParameterSetName = 'Parameters', ValueFromPipelineByPropertyName = $true)]
        [string]$Version,
        
        [Parameter(Mandatory = $true, ParameterSetName = 'Parameters', ValueFromPipelineByPropertyName = $true)]
        [string]$Vendor,
        
        [Parameter(Mandatory = $false, ParameterSetName = 'Parameters', ValueFromPipelineByPropertyName = $true)]
        [string]$Language = 'EN',
        
        [Parameter(Mandatory = $false, ParameterSetName = 'Parameters', ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('x86', 'x64', 'ARM64', 'Any')]
        [string]$Architecture = 'x64',
        
        [Parameter(Mandatory = $false, ParameterSetName = 'Parameters', ValueFromPipelineByPropertyName = $true)]
        [string]$Revision = '01',
        
        [Parameter(Mandatory = $false, ParameterSetName = 'Parameters', ValueFromPipelineByPropertyName = $true)]
        [string]$Creator = $env:USERNAME,
        
        [Parameter(Mandatory = $false, ParameterSetName = 'Parameters', ValueFromPipelineByPropertyName = $true)]
        [datetime]$CreationDate = (Get-Date),
        
        [Parameter(Mandatory = $false, ParameterSetName = 'Parameters', ValueFromPipelineByPropertyName = $true)]
        [string]$ScriptVersion = '1.0.0'
    )
    
    process {
        # If JsonPath is provided, import settings from JSON
    if ($PSCmdlet.ParameterSetName -eq 'Json') {
        try {
            Write-Verbose "Importing application information from JSON file: $JsonPath"
            $appInfo = Get-Content -Path $JsonPath -Raw | ConvertFrom-Json
            
            # Map JSON properties to variables
            $Name = $appInfo.Name
            $Version = $appInfo.Version
            $Vendor = $appInfo.Vendor
            $Language = $appInfo.Language
            $Architecture = $appInfo.Architecture
            $Creator = $appInfo.Creator
            $CreationDate = [datetime]::Parse($appInfo.CreationDate)
            $ScriptVersion = '1.0.0'
            $Revision = '01'
        }
        catch {
            Write-Error "Failed to import JSON file: $_"
            return
        }
    }
    
    # Find the Invoke-AppDeployToolkit.ps1 file
    $psadtScriptPath = Join-Path -Path $PSADTPath -ChildPath "Invoke-AppDeployToolkit.ps1"
    
    if (-not (Test-Path -Path $psadtScriptPath -PathType Leaf)) {
        Write-Error "Could not find Invoke-AppDeployToolkit.ps1 at: $psadtScriptPath"
        return
    }
    
    Write-Verbose "Reading PSADT script from: $psadtScriptPath"
    
    # Read the script content
    try {
        $scriptContent = Get-Content -Path $psadtScriptPath -Raw -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to read PSADT script: $_"
        return
    }
    
    # Update the $adtSession hashtable values using regex
    Write-Verbose "Updating PSADT script variables..."
    
    # Update AppVendor
    $scriptContent = $scriptContent -replace "(?<=AppVendor\s*=\s*')[^']*(?=')", $Vendor
    
    # Update AppName
    $scriptContent = $scriptContent -replace "(?<=AppName\s*=\s*')[^']*(?=')", $Name
    
    # Update AppVersion
    $scriptContent = $scriptContent -replace "(?<=AppVersion\s*=\s*')[^']*(?=')", $Version
    
    # Update AppArch
    $scriptContent = $scriptContent -replace "(?<=AppArch\s*=\s*')[^']*(?=')", $Architecture
    
    # Update AppLang
    $scriptContent = $scriptContent -replace "(?<=AppLang\s*=\s*')[^']*(?=')", $Language
    
    # Update AppRevision
    $scriptContent = $scriptContent -replace "(?<=AppRevision\s*=\s*')[^']*(?=')", $Revision
    
    # Update AppScriptVersion
    $scriptContent = $scriptContent -replace "(?<=AppScriptVersion\s*=\s*')[^']*(?=')", $ScriptVersion
    
    # Update AppScriptDate
    $scriptContent = $scriptContent -replace "(?<=AppScriptDate\s*=\s*')[^']*(?=')", $CreationDate.ToString('yyyy-MM-dd')
    
    # Update AppScriptAuthor
    $scriptContent = $scriptContent -replace "(?<=AppScriptAuthor\s*=\s*')[^']*(?=')", $Creator
    
    # Write the updated content back to the file
    try {
        $scriptContent | Out-File -FilePath $psadtScriptPath -Encoding UTF8 -Force -ErrorAction Stop
        Write-Verbose "Successfully updated PSADT script at: $psadtScriptPath"
        Write-Verbose "Updated values:"
        Write-Verbose "  AppVendor: $Vendor"
        Write-Verbose "  AppName: $Name"
        Write-Verbose "  AppVersion: $Version"
        Write-Verbose "  AppArch: $Architecture"
        Write-Verbose "  AppLang: $Language"
        Write-Verbose "  AppRevision: $Revision"
        Write-Verbose "  AppScriptVersion: $ScriptVersion"
        Write-Verbose "  AppScriptDate: $($CreationDate.ToString('yyyy-MM-dd'))"
        Write-Verbose "  AppScriptAuthor: $Creator"
    }
    catch {
        Write-Error "Failed to write updated PSADT script: $_"
        return
    }
    }
}
