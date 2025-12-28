<#
	.SYNOPSIS
		Generate random full names using real data from multiple countries

	.DESCRIPTION
		Creates realistic full names by combining given names and surnames from names.json.
		Supports Denmark, England/Wales, Finland, Norway, Sweden, and USA.
		
	.PARAMETER Country
		Country to generate names from. Use 'ALL' for random selection from all available names.
		Valid options: Denmark, ENGLANDWALES, Finland, Norway, Sweden, USA, ALL
		
	.PARAMETER Count
		Number of names to generate (default: 100)
		
	.EXAMPLE
		.\Create-RealFakeNames.ps1
		Generates 100 random names from all countries
		
	.EXAMPLE
		.\Create-RealFakeNames.ps1 -Country Sweden -Count 50
		Generates 50 Swedish names
		
	.EXAMPLE
		.\Create-RealFakeNames.ps1 -Country USA -Count 10
		Generates 10 American names
         
	.NOTES
		NAME:      	Create-RealFakeNames.ps1
		AUTHOR:    	Fredrik Wall, wall.fredrik@gmail.com
		BLOG:		https://www.poweradmin.se
		TWITTER:	walle75
		CREATED:	2009-12-24
		UPDATED:  	2025-12-28
        VERSION:    3.0
        
                    3.0 - Complete rewrite to use names.json
                    2.1 - Added Denmark, Finland, Norway support
                    1.0 - Initial version
#>

[CmdletBinding()]
param
(
	[Parameter(Mandatory = $false)]
	[ValidateSet('Denmark', 'ENGLANDWALES', 'Finland', 'Norway', 'Sweden', 'USA', 'ALL')]
	[string]$Country = 'ALL',
	
	[Parameter(Mandatory = $false)]
	[ValidateRange(1, 10000)]
	[int]$Count = 100
)

# Get script directory
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Path -Parent

# Path to names.json file (in Names folder)
$jsonPath = Join-Path -Path (Split-Path $ScriptDirectory -Parent) -ChildPath "Names\names.json"

# Check if names.json exists
if (-not (Test-Path -Path $jsonPath))
{
	Write-Error "names.json file not found at: $jsonPath"
	exit 1
}

function Get-GivenName
{
<#
	.SYNOPSIS
		This function will get a random Given name from a list of peoples Given names

	.DESCRIPTION
		This function will get a random Given name from a list of peoples Given names in
		Denmark, England and Wales, Finland, Norway, Sweden and USA.
         
	.PARAMETER Country
        Choose from which country you want to get a given name or use ALL for all lists
    
	.EXAMPLE 
		Get-GivenName -Country Denmark
	
	.EXAMPLE 
		Get-GivenName -Country ENGLANDWALES
		
	.EXAMPLE 
		Get-GivenName -Country Finland

	.EXAMPLE 
		Get-GivenName -Country Norway
		
	.EXAMPLE 
        Get-GivenName -Country Sweden
    
	.EXAMPLE 
        Get-GivenName -Country USA
        
    .EXAMPLE
        Get-GivenName -Country ALL
#>	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[ValidateSet('Denmark', 'ENGLANDWALES', 'Finland', 'Norway', 'Sweden', 'USA', 'ALL')]
		[string]$Country
	)
	
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

function Get-SurName
{
<#
	.SYNOPSIS
		This function will get a random surname from a list of surnames

	.DESCRIPTION
		This function will get a random surname from a list of surnames in
		England and Wales, Norway, Sweden and USA.
         
	.PARAMETER Country
        Choose from which country you want to get a surname or use ALL for all lists.
        Valid options: ENGLANDWALES, Norway, Sweden, USA, ALL
    
	.EXAMPLE 
		Get-Surname -Country ENGLANDWALES
		
	.EXAMPLE 
		Get-Surname -Country Norway
		
	.EXAMPLE 
        Get-Surname -Country Sweden
    
	.EXAMPLE 
        Get-Surname -Country USA
        
    .EXAMPLE
        Get-Surname -Country ALL
#>	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 1)]
		[ValidateSet('ENGLANDWALES', 'Norway', 'Sweden', 'USA', 'ALL')]
		[string]$Country
	)
	
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

# Generate names
Write-Host "Generating $Count names from $Country..." -ForegroundColor Cyan

1..$Count | ForEach-Object {
	$givenName = Get-GivenName -Country $Country
	
	# For countries without surnames, use ALL
	if ($Country -in @('Denmark', 'Finland'))
	{
		$surname = Get-Surname -Country ALL
	}
	else
	{
		$surname = Get-Surname -Country $Country
	}
	
	Write-Output "$givenName $surname"
}