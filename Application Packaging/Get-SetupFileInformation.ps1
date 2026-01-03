function Get-SetupFileInformation {
    <#
    .SYNOPSIS
        Extracts application information from setup files (MSI or EXE).
    
    .DESCRIPTION
        The Get-SetupFileInformation function analyzes setup files and extracts key application 
        metadata including Vendor, Name, Version, Architecture, Language, and Product Code.
        It automatically detects the file type (MSI or EXE) and uses the appropriate method 
        to retrieve the information.
        
        This function internally uses Get-MSIAppInformation for MSI files and Get-ExeAppInformation 
        for EXE files, then normalizes the output to a consistent format.
    
    .PARAMETER Path
        The path to the setup file (MSI or EXE). Accepts pipeline input.
    
    .EXAMPLE
        Get-SetupFileInformation -Path "C:\Setup\MyApp.msi"
        
        Extracts application information from an MSI file.
    
    .EXAMPLE
        Get-SetupFileInformation -Path "C:\Setup\JavaSetup8u144.exe"
        
        Extracts application information from an EXE file.
    
    .EXAMPLE
        Get-ChildItem "C:\Setup\*.msi" | Get-SetupFileInformation
        
        Processes multiple setup files via pipeline.
    
    .EXAMPLE
        Get-SetupFileInformation -Path "C:\Setup\App.msi" | Format-List
        
        Displays the output in a formatted list view.
    
    .INPUTS
        System.String. You can pipe file paths to this function.
    
    .OUTPUTS
        PSCustomObject with the following properties:
        - FilePath: Full path to the setup file
        - FileType: MSI or EXE
        - Vendor: Application vendor/publisher
        - Name: Application name
        - Version: Application version
        - Architecture: Target architecture (x86, x64, or Unknown)
        - Language: Language code or name
        - ProductCode: MSI product code GUID (MSI files only, empty for EXE)
    
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
        
        Requires:
        - Get-MSIAppInformation function for MSI files
        - Get-ExeAppInformation function for EXE files
    
    .LINK
        https://github.com/FredrikWall/PowerShell
    #>
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('FullName')]
        [ValidateScript({
            if (-not (Test-Path -Path $_ -PathType Leaf)) {
                throw "File does not exist: $_"
            }
            $extension = [System.IO.Path]::GetExtension($_).ToLower()
            if ($extension -notin @('.msi', '.exe')) {
                throw "File must be an MSI or EXE file. Got: $extension"
            }
            $true
        })]
        [string]$Path
    )
    
    begin {
        # Helper function: Convert LCID to ISO language code
        function ConvertFrom-LCID {
            param([string]$LanguageValue)
            
            if ([string]::IsNullOrWhiteSpace($LanguageValue)) {
                return $null
            }
            
            # If it's already a two-letter code, return as-is
            if ($LanguageValue -match '^[a-zA-Z]{2}$') {
                return $LanguageValue.ToUpper()
            }
            
            # Try to convert numeric LCID to culture
            try {
                $lcid = [int]$LanguageValue
                $culture = [System.Globalization.CultureInfo]::GetCultureInfo($lcid)
                return $culture.TwoLetterISOLanguageName.ToUpper()
            }
            catch {
                # If conversion fails, return original value
                Write-Verbose "Could not convert language value '$LanguageValue' to ISO code"
                return $LanguageValue
            }
        }
        
        # Helper function: Get-MSIAppInformation
        function Get-MSIAppInformation {
            [CmdletBinding()]
            param (
                [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
                [Alias('Path')]
                [ValidateNotNullOrEmpty()]
                [object]$FilePath,

                [Parameter(Mandatory = $false)]
                [string[]]
                $Property
            )

            process {
                $installer = $null
                $database = $null
                $view = $null
                $record = $null
                try {
                    if ($FilePath -is [System.IO.FileInfo]) {
                        $msi = $FilePath
                    }
                    else {
                        $msi = Get-Item -LiteralPath $FilePath -ErrorAction Stop
                    }

                    $installer = New-Object -ComObject WindowsInstaller.Installer
                    $database = $installer.OpenDatabase($msi.FullName, 0)

                    $view = $database.OpenView('SELECT `Property`, `Value` FROM `Property`')
                    $view.Execute()

                    $map = @{}
                    while ($null -ne ($record = $view.Fetch())) {
                        $name = $record.StringData(1)
                        $val  = $record.StringData(2)
                        if ($null -ne $name) { $map[$name] = $val }
                    }

                    if ($Property -and $Property.Count -gt 1) {
                        # Aggregated object without MSIPath
                        $obj = [ordered]@{}
                        foreach ($p in $Property) {
                            if ($map.ContainsKey($p)) { $obj[$p] = $map[$p] } else { $obj[$p] = $null; Write-Verbose "Property '$p' not found in '$($msi.FullName)'" }
                        }
                        [PSCustomObject]$obj
                    }
                    elseif ($Property -and $Property.Count -eq 1) {
                        $p = $Property[0]
                        if ($map.ContainsKey($p)) {
                            # Single-property object without MSIPath
                            [PSCustomObject]@{ Property = $p; Value = $map[$p] }
                        }
                        else {
                            Write-Verbose "Property '$p' not found in '$($msi.FullName)'"
                            return $null
                        }
                    }
                    else {
                        # Stream all properties as objects without MSIPath
                        foreach ($k in $map.Keys) {
                            [PSCustomObject]@{ Property = $k; Value = $map[$k] }
                        }
                    }
                }
                catch {
                    Write-Error "Failed to get MSI information for '$FilePath': $($_.Exception.Message)"
                }
                finally {
                    foreach ($obj in @($record, $view, $database, $installer) | Where-Object { $_ -ne $null }) {
                        try { [System.Runtime.InteropServices.Marshal]::ReleaseComObject($obj) | Out-Null } catch {}
                    }
                    [GC]::Collect(); [GC]::WaitForPendingFinalizers()
                }
            }
        }

        # Helper function: Get-ExeAppInformation
        function Get-ExeAppInformation {
            [CmdletBinding(DefaultParameterSetName = 'Default')]
            param (
                [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
                [string]$Path,

                [Parameter(Mandatory = $false, ParameterSetName = 'Default')]
                [ValidateSet("ProductName", "ProductVersion", "CompanyName", "Language")]
                [string[]]$Property,

                [Parameter(Mandatory = $false, ParameterSetName = 'All')]
                [switch]$All
            )

            process {
                try {
                    $info = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($Path)
                    
                    if ($All) {
                        # Return all FileVersionInfo properties
                        $info | Select-Object -Property *
                    }
                    else {
                        # Return specific properties
                        $props = @('ProductName', 'ProductVersion', 'CompanyName', 'Language')
                        $selected = if ($Property) { $Property } else { $props }
                        $result = [ordered]@{ Path = $Path }
                        foreach ($p in $selected) {
                            $result[$p] = $info.$p
                        }
                        [PSCustomObject]$result
                    }
                }
                catch {
                    Write-Error ("Failed to get EXE application information for '{0}': {1}" -f $Path, $_.Exception.Message)
                }
            }
        }
    }
    
    process {
        try {
            $file = Get-Item -LiteralPath $Path -ErrorAction Stop
            $extension = $file.Extension.ToLower()
            
            Write-Verbose "Processing $extension file: $($file.FullName)"
            
            # Initialize result object
            $result = [PSCustomObject]@{
                FilePath     = $file.FullName
                FileType     = $extension.TrimStart('.')
                Vendor       = $null
                Name         = $null
                Version      = $null
                Architecture = 'x64'
                Language     = $null
                ProductCode  = $null
            }
            
            if ($extension -eq '.msi') {
                # Process MSI file
                Write-Verbose "Extracting MSI properties..."
                
                $msiInfo = Get-MSIAppInformation -FilePath $file.FullName -Property @(
                    'Manufacturer',
                    'ProductName', 
                    'ProductVersion', 
                    'ProductCode',
                    'ProductLanguage'
                )
                
                if ($msiInfo) {
                    $result.Vendor = $msiInfo.Manufacturer
                    $result.Name = $msiInfo.ProductName
                    $result.Version = $msiInfo.ProductVersion
                    $result.ProductCode = $msiInfo.ProductCode
                    $result.Language = ConvertFrom-LCID -LanguageValue $msiInfo.ProductLanguage
                    
                    # Determine architecture from ProductName or other properties
                    if ($msiInfo.ProductName -match '\bx64\b|\b64-bit\b|\b64bit\b') {
                        $result.Architecture = 'x64'
                    }
                    elseif ($msiInfo.ProductName -match '\bx86\b|\b32-bit\b|\b32bit\b') {
                        $result.Architecture = 'x86'
                    }
                    else {
                        # Try to get Template property which contains architecture info
                        $template = Get-MSIAppInformation -FilePath $file.FullName -Property 'Template'
                        if ($template.Template -match 'x64|AMD64|Intel64') {
                            $result.Architecture = 'x64'
                        }
                        elseif ($template.Template -match 'Intel') {
                            $result.Architecture = 'x86'
                        }
                    }
                }
            }
            elseif ($extension -eq '.exe') {
                # Process EXE file
                Write-Verbose "Extracting EXE version information..."
                
                $exeInfo = Get-ExeAppInformation -Path $file.FullName -Property @(
                    'CompanyName',
                    'ProductName',
                    'ProductVersion',
                    'Language'
                )
                
                if ($exeInfo) {
                    $result.Vendor = $exeInfo.CompanyName
                    $result.Name = $exeInfo.ProductName
                    $result.Version = $exeInfo.ProductVersion
                    $result.Language = ConvertFrom-LCID -LanguageValue $exeInfo.Language
                    $result.ProductCode = '' # EXE files don't have product codes
                    
                    # Determine architecture from file name or product name
                    $fileName = $file.Name
                    if ($fileName -match '\bx64\b|\b64-bit\b|\b64bit\b|_x64|amd64' -or 
                        $exeInfo.ProductName -match '\bx64\b|\b64-bit\b|\b64bit\b') {
                        $result.Architecture = 'x64'
                    }
                    elseif ($fileName -match '\bx86\b|\b32-bit\b|\b32bit\b|_x86' -or 
                            $exeInfo.ProductName -match '\bx86\b|\b32-bit\b|\b32bit\b') {
                        $result.Architecture = 'x86'
                    }
                    else {
                        # Check PE header for actual architecture
                        try {
                            $fileStream = [System.IO.File]::OpenRead($file.FullName)
                            $reader = New-Object System.IO.BinaryReader($fileStream)
                            
                            # Read DOS header
                            $dosSignature = $reader.ReadUInt16()
                            if ($dosSignature -eq 0x5A4D) { # 'MZ'
                                $fileStream.Seek(0x3C, [System.IO.SeekOrigin]::Begin) | Out-Null
                                $peHeaderOffset = $reader.ReadUInt32()
                                
                                # Read PE header
                                $fileStream.Seek($peHeaderOffset, [System.IO.SeekOrigin]::Begin) | Out-Null
                                $peSignature = $reader.ReadUInt32()
                                if ($peSignature -eq 0x00004550) { # 'PE\0\0'
                                    $machine = $reader.ReadUInt16()
                                    switch ($machine) {
                                        0x014c { $result.Architecture = 'x86' }   # IMAGE_FILE_MACHINE_I386
                                        0x8664 { $result.Architecture = 'x64' }   # IMAGE_FILE_MACHINE_AMD64
                                        0xAA64 { $result.Architecture = 'ARM64' } # IMAGE_FILE_MACHINE_ARM64
                                    }
                                }
                            }
                            
                            $reader.Close()
                            $fileStream.Close()
                        }
                        catch {
                            Write-Verbose "Could not determine architecture from PE header: $_"
                        }
                    }
                }
            }
            
            # Output the result
            Write-Output $result
        }
        catch {
            Write-Error "Failed to process file '$Path': $_"
        }
    }
}

$SetupFileInfo = Get-SetupFileInformation -Path "C:\Users\wallf\Downloads\googlechromestandaloneenterprise64 (1).msi"
#$SetupFileInfo = Get-SetupFileInformation -Path "C:\Users\wallf\Downloads\FileZilla_3.69.1_win64_sponsored2-setup.exe"
$PackagePath = "C:\ApplicationPackaging\02_Dev\$($SetupFileInfo.Vendor)_$($SetupFileInfo.Name)_$($SetupFileInfo.Version)_$($SetupFileInfo.Architecture)_01"

$SetupFileInfo | New-ApplicationPackage -TemplatePath 'C:\ApplicationPackaging\01_Templates\PSAppDeployToolkit v4.1.7\App_Vendor_Application_Version_Architecture' -DestinationPath "C:\ApplicationPackaging\02_Dev"
$SetupFileInfo | New-ApplicationInformationFile -Path "$PackagePath\DOC" -Icon "ICON\Google-Chrome.png" -DetectionMethod MSIProductCode -DetectionMethodValue $SetupFileInfo.ProductCode -Force
$SetupFileInfo | Set-PSADTInformation -PSADTPath "$PackagePath\PSADT"

Copy-ApplicationIcon -SourceIconPath "C:\ApplicationPackaging\05_Icons\*\Google-Chrome.png" -DestinationPath "$PackagePath" -Force
Remove-PackageReadme -Path "$PackagePath"




