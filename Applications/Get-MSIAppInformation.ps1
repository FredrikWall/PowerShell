function Get-MSIAppInformation {
	<#
	.SYNOPSIS
		Retrieve properties from an MSI file.

	.DESCRIPTION
		Opens an MSI database and reads properties from the Property table.
		Returns PSCustomObject(s) with `MSIPath`, `Property` and `Value`.

		If `-Property` is provided with a single name, a single object is
		returned for that property. If `-Property` is provided with multiple
		names, a single aggregated object is returned with each requested
		property as a field. Without `-Property`, the function streams all
		properties found in the MSI as individual objects.

	.PARAMETER FilePath
		Path to the MSI file. Accepts pipeline input as a string or a
		FileInfo object.

	.PARAMETER Property
		Optional. One or more MSI property names to retrieve (e.g. ProductName,
		ProductVersion, ProductCode). When omitted all properties are streamed.

	.EXAMPLE
		Get-MSIAppInformation -FilePath 'C:\temp\MyApp.msi' -Property ProductName

	.EXAMPLE
		Get-MSIAppInformation -FilePath 'C:\temp\MyApp.msi' -Property ProductName,ProductVersion

	.EXAMPLE
		'C:\temp\MyApp.msi' | Get-MSIAppInformation

	.NOTES
		NAME:    Get-MSIAppInformation
        AUTHOR:  Fredrik Wall, wall.fredrik@gmail.com
        VERSION: 1.4
        CREATED: 2014-12-05
		UPDATED: 2025-12-03
		CHANGES: Pipeline support, aggregated return for multiple properties, COM cleanup.
	#>

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

