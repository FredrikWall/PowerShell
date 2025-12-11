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

	.EXAMPLE
		Get-ExeAppInformation -Path "JavaSetup8u144.exe" -Property ProductName

	.EXAMPLE
		Get-ExeAppInformation -Path "JavaSetup8u144.exe" -Property ProductName,ProductVersion

	.EXAMPLE
		"JavaSetup8u144.exe" | Get-ExeAppInformation

	.NOTES
		NAME:    Get-ExeAppInformation
		AUTHOR:  Fredrik Wall, wall.fredrik@gmail.com
		VERSION: 1.3
        CREATED: 2016-01-23
		UPDATED: 2025-12-03
		CHANGES: Pipeline support, multi-property, returns PSCustomObject, improved error handling.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]$Path,

        [Parameter(Mandatory = $false)]
        [ValidateSet("ProductName", "ProductVersion", "CompanyName", "Language")]
        [string[]]$Property
    )

    process {
        try {
            $info = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($Path)
            $props = @('ProductName', 'ProductVersion', 'CompanyName', 'Language')
            $selected = if ($Property) { $Property } else { $props }
            $result = [ordered]@{ Path = $Path }
            foreach ($p in $selected) {
                $result[$p] = $info.$p
            }
            [PSCustomObject]$result
        }
        catch {
            Write-Error ("Failed to get EXE application information for '{0}': {1}" -f $Path, $_.Exception.Message)
        }
    }
}