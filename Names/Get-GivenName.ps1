function Get-GivenName
{
<#
	.SYNOPSIS
		This function will get a random Given name from a list of peoples Given names

	.DESCRIPTION
		This function will get a random Given name from a list of peoples Given names in
		Denmark, England and Wales, Finland, Norway, Sweden and USA.
        To get the list/lists of Given names use the Import-GivenNames function.
         
	.PARAMETER Country
        Choose from wish country you want to get a surname or use ALL for all lists
    
	.EXAMPLE 
		Get-GivenName -Country DENMARK
	
	.EXAMPLE 
		Get-GivenName -Country ENGLANDWALES
		
	.EXAMPLE 
		Get-GivenName -Country FINLAND

	.EXAMPLE 
		Get-GivenName -Country NORWAY
		
	.EXAMPLE 
        Get-GivenName -Country SWEDEN
    
	.EXAMPLE 
        Get-GivenName -Country USA
        
    .EXAMPLE
        Get-GivenName -Country ALL
	
	.NOTES
		Author:  Fredrik Wall
		Email:   wall.fredrik@gmail.com
		Blog:    www.poweradmin.se
		Twitter: @walle75
		Created: 2009-12-24
		Updated: 2025-12-30
		Version: 4.0
		
		Changelog:
		4.0 (2025-12-28) - Changed to use names.json file instead of individual TXT files, added validation for Country parameter
		3.2              - Added support for Denmark, Finland, Norway
		2.1              - Changed UK to England and Wales
		1.0 (2009-12-24) - Initial version

#>	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[ValidateSet('Denmark', 'ENGLANDWALES', 'Finland', 'Norway', 'Sweden', 'USA', 'ALL')]
		[string]$Country
	)
	
	# Path to names.json file
	$jsonPath = Join-Path -Path $PSScriptRoot -ChildPath "names.json"
	
	# Check if names.json exists
	if (-not (Test-Path -Path $jsonPath))
	{
		Write-Warning "names.json file not found at: $jsonPath"
		return
	}
	
	# Load names from JSON
	try
	{
		$nameData = Get-Content -Path $jsonPath -Raw | ConvertFrom-Json
	}
	catch
	{
		Write-Warning "Failed to load names.json: $_"
		return
	}
	
	if ($Country -eq "ALL")
	{
		# Collect all given names from all countries
		$allNames = @()
		foreach ($countryName in $nameData.PSObject.Properties.Name)
		{
			if ($nameData.$countryName.GivenNames)
			{
				$allNames += $nameData.$countryName.GivenNames
			}
		}
		
		if ($allNames.Count -gt 0)
		{
			Get-Random -InputObject $allNames
		}
		else
		{
			Write-Warning "No given names found in names.json"
		}
	}
	else
	{
		# Get names for specific country
		if ($nameData.$Country -and $nameData.$Country.GivenNames)
		{
			Get-Random -InputObject $nameData.$Country.GivenNames
		}
		else
		{
			Write-Warning "No given names found for $Country in names.json"
		}
	}
	
}