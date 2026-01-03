
function New-ApplicationInformationFile {
    <#
        .SYNOPSIS
            Creates an application information file with specified metadata and package details.

        .DESCRIPTION
            The New-ApplicationInformationFile function generates a formatted text file containing key information about an application package, such as name, version, vendor, architecture, packaging method, and installation details. The output file is intended to document the packaging and deployment configuration for the application.

        .PARAMETER Name
            Name of the application. Defaults to "[ApplicationName]" if not specified.

        .PARAMETER Version
            Version of the application.

        .PARAMETER Vendor
            Name of the vendor. Defaults to "[ApplicationVendor]" if not specified.

        .PARAMETER Language
            Language code for the package. Defaults to "EN" (English).
            Examples: EN, SV (Swedish), DA (Danish), NO (Norwegian), DE (German).

        .PARAMETER Architecture
            Architecture of the product. Defaults to "x64".
            Valid values: x86, x64, ARM64, Any.

        .PARAMETER Icon
            Path to the application icon. Defaults to "Default.png".

        .PARAMETER Creator
            Name of the package creator. Defaults to the current user's username.

        .PARAMETER CreationDate
            Date the package was created. Defaults to the current date and time.

        .PARAMETER UpgradePreviousVersion
            Indicates whether the package upgrades previous versions. Defaults to $false.

        .PARAMETER PackagingMethod
            Packaging method used (e.g., MSI, APP-V, ThinApp, Legacy, PSAppDeployToolkit). Defaults to "PSAppDeployToolkit".

        .PARAMETER AllowUserToInteract
            Indicates whether the user is allowed to interact during installation (SCCM/Intune). Defaults to $true.

        .PARAMETER DetectionMethod
            The detection method to use for the application package. Defaults to "RegistryKey".
            Valid values: MSIProductCode, FileSystem, RegistryKey.

        .PARAMETER DetectionMethodValue
            The value for the detection method. The format depends on the DetectionMethod selected:
            - MSIProductCode: The MSI product GUID (e.g., "{12345678-1234-1234-1234-123456789012}")
            - FileSystem: The file path to detect (e.g., "C:\Program Files\MyApp\MyApp.exe")
            - RegistryKey: The registry key path (defaults to "[HKLM:\SOFTWARE\Applications\$Name $Version] [Install]=\"01\"")        
        .PARAMETER ProductCode
            The MSI product code GUID for the application (e.g., "{12345678-1234-1234-1234-123456789012}").
            Optional parameter that can be used to document the MSI product code.
                .PARAMETER InstallCommand
            The installation command for the application. Defaults to "Invoke-AppDeployToolkit.exe -DeploymentType Install" with interactive flag if enabled.

        .PARAMETER UninstallCommand
            The uninstallation command for the application. Defaults to "Invoke-AppDeployToolkit.exe -DeploymentType Uninstall".

        .PARAMETER RepairCommand
            The repair command for the application. Defaults to "Invoke-AppDeployToolkit.exe -DeploymentType Repair".
        .PARAMETER Path
            Path where the application information file will be saved. This parameter is mandatory.

        .PARAMETER Force
            If specified, overwrites an existing Application_Information.txt file without prompting.
            If not specified and the file exists, a warning is displayed and the file is not overwritten.

        .EXAMPLE
            New-ApplicationInformationFile -Name "MyApp" -Version "1.0.0" -Vendor "MyVendor" -Path "C:\Output"

            Creates an application information file for "MyApp" version "1.0.0" by "MyVendor" at the specified path.

        .EXAMPLE
            New-ApplicationInformationFile -Name "7-Zip" -Version "23.01" -Vendor "Igor Pavlov" -Language "EN" -Architecture "x64" -Path "C:\Packages"

            Creates an application information file with all main parameters specified.

        .EXAMPLE
            New-ApplicationInformationFile -Name "MyApp" -Version "1.0.0" -Vendor "MyVendor" -Path "C:\Output" -Force

            Creates an application information file and overwrites any existing file without prompting.

        .EXAMPLE
            New-ApplicationInformationFile -Name "7-Zip" -Version "23.01" -Vendor "Igor Pavlov" -Path "C:\Packages" -DetectionMethod "FileSystem"

            Creates an application information file with FileSystem detection method.

        .EXAMPLE
            New-ApplicationInformationFile -Name "MyApp" -Version "1.0" -Vendor "Vendor" -Path "C:\Packages" -DetectionMethod "MSIProductCode" -DetectionMethodValue "{12345678-1234-1234-1234-123456789012}"

            Creates an application information file with MSI Product Code detection method and specific GUID.

        .NOTES
            Author:  Fredrik Wall
            Email:   wall.fredrik@gmail.com
            Blog:    www.poweradmin.se
            Twitter: @walle75
            Created: 2024-01-01
            Updated: 2026-01-03
            Version: 1.4
            
            Changelog:
            1.4 (2026-01-03) - Added InstallCommand, UninstallCommand, and RepairCommand parameters
            1.3 (2026-01-02) - Added DetectionMethodValue parameter for custom detection values
            1.2 (2026-01-01) - Added JSON import file creation for easy PowerShell import
            1.1 (2025-12-31) - Updated parameter names to match New-ApplicationPackage best practices
            1.0 (2024-01-01) - Initial version
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$Name = "[ApplicationName]",
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$Version,
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$Vendor = "[ApplicationVendor]",
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$Description = "[ApplicationDescription]",
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$Language = "EN",
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('x86', 'x64', 'ARM64', 'Any')]
        [string]$Architecture = "x64",
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$Icon = "Default.png",
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$Creator = $env:USERNAME,
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [datetime]$CreationDate = (Get-Date),
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [bool]$UpgradePreviousVersion = $false,
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('MSI', 'APP-V', 'ThinApp', 'Legacy', 'PSAppDeployToolkit')]
        [string]$PackagingMethod = "PSAppDeployToolkit",
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [bool]$AllowUserToInteract = $true,
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('MSIProductCode', 'FileSystem', 'RegistryKey')]
        [string]$DetectionMethod = "RegistryKey",
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$DetectionMethodValue,
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$ProductCode,
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$InstallCommand,
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$UninstallCommand,
        
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$RepairCommand,
        
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Path,
        
        [Parameter(Mandatory = $false)]
        [switch]$Force
    )
    Clear-Host

    if ($UpgradePreviousVersion) {
        $UpgradePreviousVersionContent = "Upgrades previous version(s)............: [*] Yes [ ] No"
    }
    else {
        $UpgradePreviousVersionContent = "Upgrades previous version(s)............: [ ] Yes [*] No"
    }

    switch ($PackagingMethod) {
        'MSI' {
            $PackagingMethodContent = @"
Packaging method........................: [*] MSI
                                          [ ] App-V 5.1
                                          [ ] ThinApp 5.2.3
                                          [ ] Legacy setup
                                          [ ] PSAppDeployToolkit
"@
        }

        'APP-V' {
            $PackagingMethodContent = @"
Packaging method........................: [ ] MSI
                                          [*] App-V 5.1
                                          [ ] ThinApp 5.2.3
                                          [ ] Legacy setup
                                          [ ] PSAppDeployToolkit
"@
        }

        'ThinApp' {
            $PackagingMethodContent = @"
Packaging method........................: [ ] MSI
                                          [ ] App-V 5.1
                                          [*] ThinApp 5.2.3
                                          [ ] Legacy setup
                                          [ ] PSAppDeployToolkit
"@
        }

        'Legacy' {
            $PackagingMethodContent = @"
Packaging method........................: [ ] MSI
                                          [ ] App-V 5.1
                                          [ ] ThinApp 5.2.3
                                          [*] Legacy setup
                                          [ ] PSAppDeployToolkit
"@
        }

        'PSAppDeployToolkit' {
            $PackagingMethodContent = @"
Packaging method........................: [ ] MSI
                                          [ ] App-V 5.1
                                          [ ] ThinApp 5.2.3
                                          [ ] Legacy setup
                                          [*] PSAppDeployToolkit
"@
        }

    }

    if ($AllowUserToInteract) {
        $AllowUserToInteractContent = "Allow User to Interact (SCCM/Intune)....: [*] Yes [ ] No"
        $InteractiveFlag = "-DeployMode Interactive"
    }
    else {
        $AllowUserToInteractContent = "Allow User to Interact (SCCM/Intune)....: [ ] Yes [*] No"
        $InteractiveFlag = ""
    }

    # Set default command values if not provided
    if (-not $InstallCommand) {
        $InstallCommand = "Invoke-AppDeployToolkit.exe -DeploymentType Install $InteractiveFlag".Trim()
    }
    if (-not $UninstallCommand) {
        $UninstallCommand = "Invoke-AppDeployToolkit.exe -DeploymentType Uninstall"
    }
    if (-not $RepairCommand) {
        $RepairCommand = "Invoke-AppDeployToolkit.exe -DeploymentType Repair"
    }

    # Set detection method content based on parameter
    switch ($DetectionMethod) {
        'MSIProductCode' {
            $detectionValue = if ($DetectionMethodValue) { $DetectionMethodValue } else { "" }
            $DetectionMethodContent = @"
Detection method (Clause)...............: [*] MSI Product Code: $detectionValue
                                          [ ] File system     : 
                                          [ ] Registry key    : 
"@
        }

        'FileSystem' {
            $detectionValue = if ($DetectionMethodValue) { $DetectionMethodValue } else { "" }
            $DetectionMethodContent = @"
Detection method (Clause)...............: [ ] MSI Product Code:
                                          [*] File system     : $detectionValue
                                          [ ] Registry key    : 
"@
        }

        'RegistryKey' {
            $detectionValue = if ($DetectionMethodValue) { $DetectionMethodValue } else { "[HKLM:\SOFTWARE\Applications\$Name $Version] [Install]=`"01`"]" }
            $DetectionMethodContent = @"
Detection method (Clause)...............: [ ] MSI Product Code:
                                          [ ] File system     : 
                                          [*] Registry key    : $detectionValue
"@
        }
    }

    $ApplicationInformationContent = @"
[Main data]
Application name........................: $Name
Application version.....................: $Version
Application language....................: $Language
Application vendor......................: $Vendor
Application architecture................: $Architecture
Application product code................: $ProductCode
Application icon........................: $Icon

Package creator.........................: $Creator
Package creation date...................: $($CreationDate.ToString('yyyy-MM-dd'))

[Package details]
$UpgradePreviousVersionContent

$PackagingMethodContent

MSI file................................: [Using PSADT]
MST file(s).............................: [Using PSADT]

[Installation details]
INSTALL command.........................: $InstallCommand
UNINSTALL command.......................: $UninstallCommand
REPAIR command..........................: $RepairCommand

$AllowUserToInteractContent
Kill process dialog.....................: [ ] Yes [*] No
RELOGON required........................: [ ] Yes [*] No
                                    	          [ ] SCCM
                                    	          [ ] AppDeploy
REBOOT required.........................: [ ] Yes [*] No
                                    	          [ ] SCCM
                                    	          [ ] AppDeploy
Verified platform(s):
Windows 11  x64.........................: [*] Yes [ ] No

$DetectionMethodContent

Dependencies............................: 

[Technical comments]


Active Setup in package.................: [ ] Yes [*] No
                                    	          [ ] MSI
                                    	          [ ] AppDeploy

[Additional comments]

$Description



"@

    # Build the full file path
    $filePath = Join-Path -Path $Path -ChildPath "Application_Information.txt"

    # Check if file exists and Force is not specified
    if ((Test-Path -Path $filePath) -and -not $Force) {
        Write-Warning "Application information file already exists at: $filePath"
        Write-Warning "Use -Force parameter to overwrite the existing file."
        return
    }

    # Write the application information file
    try {
        $ApplicationInformationContent | Out-File -FilePath $filePath -Encoding UTF8 -Force -ErrorAction Stop
        Write-Verbose "Application information file created successfully at: $filePath"
    }
    catch {
        Write-Error "Failed to create application information file: $_"
        return
    }

    # Create JSON import file for easy PowerShell import
    $jsonFilePath = Join-Path -Path $Path -ChildPath "Application_Information.json"
    
    # Build object with all application information
    $applicationInfo = [PSCustomObject]@{
        Name                    = $Name
        Version                 = $Version
        Vendor                  = $Vendor
        Description             = $Description
        Language                = $Language
        Architecture            = $Architecture
        ProductCode             = $ProductCode
        Icon                    = $Icon
        Creator                 = $Creator
        CreationDate            = $CreationDate.ToString('yyyy-MM-dd')
        UpgradePreviousVersion  = $UpgradePreviousVersion
        PackagingMethod         = $PackagingMethod
        AllowUserToInteract     = $AllowUserToInteract
        DetectionMethod         = $DetectionMethod
        DetectionMethodValue    = if ($DetectionMethodValue) { $DetectionMethodValue } else {
            if ($DetectionMethod -eq 'RegistryKey') {
                "[HKLM:\SOFTWARE\Applications\$Name $Version] [Install]=`"01`"]"
            } else {
                ""
            }
        }
        InstallCommand          = $InstallCommand
        UninstallCommand        = $UninstallCommand
        RepairCommand           = $RepairCommand
        Path                    = $Path
    }

    # Write JSON file
    try {
        $applicationInfo | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonFilePath -Encoding UTF8 -Force -ErrorAction Stop
        Write-Verbose "JSON import file created successfully at: $jsonFilePath"
    }
    catch {
        Write-Warning "Failed to create JSON import file: $_"
    }
}