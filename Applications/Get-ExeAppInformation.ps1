function Get-ExeAppInformation {
    <#
	.SYNOPSIS
		Gets application information from an EXE file.

	.DESCRIPTION
		Retrieves one or more properties (ProductName, ProductVersion, CompanyName, Language) from the file version info of an EXE.
		Supports pipeline input for Path and multiple properties at once.

	.PARAMETER Path
		Path to the EXE file. Accepts pipeline input.

	.PARAMETER Property
		One or more properties to retrieve. Valid values: ProductName, ProductVersion, CompanyName, Language.
		If omitted, all four properties are returned.

	.PARAMETER All
		Returns all available FileVersionInfo properties.

	.EXAMPLE
		Get-ExeAppInformation -Path "C:\Setup\JavaSetup8u144.exe"
		Returns default properties (ProductName, ProductVersion, CompanyName, Language) for the specified EXE.

	.EXAMPLE
		Get-ExeAppInformation -Path "C:\Setup\JavaSetup8u144.exe" -Property ProductName
		Returns only the ProductName property.

	.EXAMPLE
		Get-ExeAppInformation -Path "C:\Setup\JavaSetup8u144.exe" -Property ProductName, FileVersion, CompanyName
		Returns multiple specific properties.

	.EXAMPLE
		"C:\Setup\JavaSetup8u144.exe" | Get-ExeAppInformation
		Uses pipeline input to get default properties for the EXE.

	.EXAMPLE
		Get-ChildItem "C:\Setup\*.exe" | Get-ExeAppInformation -Property ProductName, ProductVersion
		Gets product info for all EXE files in a folder.

	.EXAMPLE
		Get-ExeAppInformation -Path "C:\Setup\JavaSetup8u144.exe" -All
		Returns all available FileVersionInfo properties including FileVersion, FileDescription, LegalCopyright, etc.

	.EXAMPLE
		Get-ChildItem "C:\Setup\*.exe" | Get-ExeAppInformation -All | Export-Csv -Path "C:\Reports\ExeInventory.csv" -NoTypeInformation
		Creates a CSV report of all EXE files with complete version information.

	.NOTES
		Author:  Fredrik Wall
		Email:   wall.fredrik@gmail.com
		Created: 2016-01-23
		Updated: 2025-12-29
		Version: 1.4
		
		Changelog:
		1.4 (2025-12-29) - Added -All switch to retrieve all FileVersionInfo properties
		1.3 (2025-12-03) - Added error handling and improved output
		1.2              - Added support for pipeline input
		1.1              - Added support for multiple properties
		1.0 (2016-01-23) - Initial release
	
	.LINK
		https://github.com/FredrikWall/PowerShell/tree/master/Applications
    #>
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