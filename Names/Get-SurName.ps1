function Get-SurName
{
<#
	.SYNOPSIS
		This function will get a random surname from a list of surnames

	.DESCRIPTION
		This function will get a random surname from a list of surnames in
		England and Wales, Finland, Norway, Sweden and USA.
        Uses the names.json file for data storage.
         
	.PARAMETER Country
        Choose from which country you want to get a surname or use ALL for all lists.
        Valid options: ENGLANDWALES, Finland, Norway, Sweden, USA, ALL
    
	.EXAMPLE 
		Get-Surname -Country ENGLANDWALES
		
	.EXAMPLE 
		Get-Surname -Country Finland
		
	.EXAMPLE 
		Get-Surname -Country Norway
		
	.EXAMPLE 
        Get-Surname -Country Sweden
    
	.EXAMPLE 
        Get-Surname -Country USA
        
    .EXAMPLE
        Get-Surname -Country ALL
	
	.NOTES
		Author:  Fredrik Wall
		Email:   wall.fredrik@gmail.com
		Blog:    www.poweradmin.se
		Twitter: @walle75
		Created: 2009-12-24
		Updated: 2025-12-30
		Version: 4.1
		
		Changelog:
		4.1 (2025-12-30) - Added Finland support
		4.0 (2025-12-28) - Changed to use names.json file instead of individual TXT files, added validation for Country parameter
		3.2              - Added support for Denmark and Norway
		2.1              - Changed UK to England and Wales
		1.0 (2009-12-24) - Initial version

#>	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[ValidateSet('ENGLANDWALES', 'Finland', 'Norway', 'Sweden', 'USA', 'ALL')]
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
		# Collect all surnames from all countries
		$allNames = @()
		foreach ($countryName in $nameData.PSObject.Properties.Name)
		{
			if ($nameData.$countryName.Surnames)
			{
				$allNames += $nameData.$countryName.Surnames
			}
		}
		
		if ($allNames.Count -gt 0)
		{
			Get-Random -InputObject $allNames
		}
		else
		{
			Write-Warning "No surnames found in names.json"
		}
	}
	else
	{
		# Get surnames for specific country
		if ($nameData.$Country -and $nameData.$Country.Surnames)
		{
			Get-Random -InputObject $nameData.$Country.Surnames
		}
		else
		{
			Write-Warning "No surnames found for $Country in names.json"
		}
	}
	
}
