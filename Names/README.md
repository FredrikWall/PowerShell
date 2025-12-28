# Name Functions

A comprehensive PowerShell toolkit for name formatting and random name generation. Includes utilities for standardizing name capitalization and generating realistic test names from multiple countries.

## Overview

This module provides both name formatting functions for data cleaning and name generation functions for creating test data. All name data is stored in a consolidated `names.json` file for fast access and easy management.

## Features

- ✨ **Smart Title Casing** - Proper capitalization for first and last names
- 🌍 **Multi-Country Support** - Names from Denmark, England/Wales, Finland, Norway, Sweden, and USA
- 🎲 **Random Name Generation** - Generate realistic given names and surnames
- 📊 **Pipeline Support** - Process names efficiently through the pipeline
- 🚀 **Optimized Performance** - Uses native .NET TextInfo and JSON data storage
- 🔄 **Easy Data Management** - All names in single JSON file

## Functions

### Format-Name

Formats a name or full name with proper title casing (first letter uppercase, rest lowercase).

**Syntax:**
```powershell
Format-Name -Name <String>
```

**Parameters:**
- `Name` - The name or names to format (supports pipeline input)

**Examples:**
```powershell
# Format a single name
Format-Name -Name "fredrik"
# Output: Fredrik

# Format a full name
Format-Name -Name "fredrik wall"
# Output: Fredrik Wall

# Pipeline support
"john smith", "JANE DOE" | Format-Name
# Output:
# John Smith
# Jane Doe
```

### Get-GivenName

Returns a random given name from the specified country's name database.

**Syntax:**
```powershell
Get-GivenName -Country <String>
```

**Parameters:**
- `Country` - Country to get name from: Denmark, ENGLANDWALES, Finland, Norway, Sweden, USA, or ALL

**Examples:**
```powershell
# Get a random Swedish given name
Get-GivenName -Country Sweden
# Output: Erik

# Get a random given name from any country
Get-GivenName -Country ALL
# Output: Emma

# Generate multiple given names
1..5 | ForEach-Object { Get-GivenName -Country USA }
# Output:
# Michael
# Sarah
# David
# Jennifer
# Christopher
```

### Get-Surname

Returns a random surname from the specified country's name database.

**Syntax:**
```powershell
Get-Surname -Country <String>
```

**Parameters:**
- `Country` - Country to get surname from: ENGLANDWALES, Norway, Sweden, USA, or ALL
- Note: Denmark and Finland only have given names in the database

**Examples:**
```powershell
# Get a random Swedish surname
Get-Surname -Country Sweden
# Output: Andersson

# Get a random surname from any country
Get-Surname -Country ALL
# Output: Smith

# Generate full names
$firstName = Get-GivenName -Country Sweden
$lastName = Get-Surname -Country Sweden
Write-Output "$firstName $lastName"
# Output: Anna Johansson
```

### Convert-NamesToJson

Utility script to convert individual name text files into the consolidated `names.json` format.

**Usage:**
```powershell
.\Convert-NamesToJson.ps1
```

This script processes all `gNames*.txt` and `sNames*.txt` files in the `Imported` folder and creates a structured JSON file.

## Name Database

The `names.json` file contains names from six countries:

| Country | Given Names | Surnames |
|---------|-------------|----------|
| Denmark | 100 | 0 |
| England/Wales | 991 | 500 |
| Finland | 100 | 0 |
| Norway | 200 | 100 |
| Sweden | 200 | 100 |
| USA | 5,163 | 1,000 |
| **Total** | **6,754** | **1,700** |

**JSON Structure:**
```json
{
  "Sweden": {
    "GivenNames": ["Erik", "Anna", "Lars", ...],
    "Surnames": ["Andersson", "Johansson", "Karlsson", ...]
  },
  "USA": {
    "GivenNames": ["Michael", "Sarah", ...],
    "Surnames": ["Smith", "Johnson", ...]
  }
}
```

## Use Cases

### Name Formatting - Data Cleaning
```powershell
# Import CSV with inconsistent name formatting
$users = Import-Csv "users.csv"
$users | ForEach-Object {
    $_.FirstName = Format-Name $_.FirstName
    $_.LastName = Format-Name $_.LastName
}
$users | Export-Csv "users_cleaned.csv" -NoTypeInformation
```

### Name Formatting - User Input Normalization
```powershell
# Normalize user input before saving to database
$firstName = Read-Host "Enter first name"
$lastName = Read-Host "Enter last name"

$firstName = Format-Name $firstName
$lastName = Format-Name $lastName

Write-Host "Welcome, $firstName $lastName!"
```

### Name Generation - Test Data Creation
```powershell
# Generate 100 random test users
$testUsers = 1..100 | ForEach-Object {
    [PSCustomObject]@{
        FirstName = Get-GivenName -Country ALL
        LastName = Get-Surname -Country ALL
        Email = $null
    }
}

# Add email addresses
$testUsers | ForEach-Object {
    $email = "$($_.FirstName).$($_.LastName)@contoso.com".ToLower()
    $_.Email = $email
}
```

### Name Generation - Country-Specific Test Data
```powershell
# Generate Swedish test users
$swedishUsers = 1..50 | ForEach-Object {
    [PSCustomObject]@{
        GivenName = Get-GivenName -Country Sweden
        Surname = Get-Surname -Country Sweden
        Country = "Sweden"
    }
}

# Generate American test users
$americanUsers = 1..50 | ForEach-Object {
    [PSCustomObject]@{
        GivenName = Get-GivenName -Country USA
        Surname = Get-Surname -Country USA
        Country = "USA"
    }
}
```

### Combined - Format Generated Names
```powershell
# Generate and format test names
$testNames = 1..20 | ForEach-Object {
    $first = Get-GivenName -Country ALL
    $last = Get-Surname -Country ALL
    Format-Name "$first $last"
}
```

### Active Directory Testing
```powershell
# Create test AD users
$testUsers = 1..10 | ForEach-Object {
    $firstName = Get-GivenName -Country USA
    $lastName = Get-Surname -Country USA
    $samAccountName = "$firstName.$lastName".ToLower()
    
    [PSCustomObject]@{
        GivenName = $firstName
        Surname = $lastName
        DisplayName = "$firstName $lastName"
        SamAccountName = $samAccountName
        UserPrincipalName = "$samAccountName@domain.com"
    }
}
```

## Technical Details

### Format-Name Implementation
Uses .NET's `TextInfo.ToTitleCase()` method from the current culture, which provides:
- Proper capitalization of the first letter of each word
- Lowercase conversion for all other letters
- Culture-specific casing rules
- Optimized performance for string operations

**Version 1.4** (Current):
- Uses `TextInfo.ToTitleCase()` for efficient processing
- Single code path for all scenarios
- Proper pipeline support with `process` block
- ~90% performance improvement over previous versions

### Name Generation Implementation
Uses JSON-based data storage for fast, efficient name lookups:
- Single `names.json` file loaded on demand
- Structured data by country with GivenNames and Surnames arrays
- `Get-Random -InputObject` for random selection
- ValidateSet parameter for tab completion and validation
- Handles countries without surname data gracefully

**Data Flow:**
1. Function loads `names.json` from `$PSScriptRoot`
2. Parses JSON to PowerShell object
3. Accesses country-specific arrays
4. Returns random name using `Get-Random`

### Performance Characteristics

**Format-Name:**
- Minimal string operations
- Native .NET optimization
- Better memory efficiency
- No array building or loops

**Get-GivenName / Get-Surname:**
- Fast JSON parsing (one-time per call)
- Efficient array access
- Quick random selection
- Scales well with large datasets

## Screenshot

![Format-Name Example](https://github.com/PowerShellFredrik/PowerShellFunctions/blob/main/Names/Pictures/Format-Names01.png?raw=true)

*Example output showing name formatting in action*

## Requirements

- PowerShell 5.1 or higher
- Windows PowerShell or PowerShell 7+
- No external modules required

## Installation

### Using Individual Functions

```powershell
# Load Format-Name function
. .\Format-Names.ps1
Format-Name -Name "john smith"

# Load name generation functions (requires names.json in same folder)
. .\Get-GivenName.ps1
. .\Get-Surname.ps1

Get-GivenName -Country Sweden
Get-Surname -Country Sweden
```

### Setting Up Name Data

If you need to regenerate `names.json` from source text files:

```powershell
# Convert TXT files to JSON (requires gNames*.txt and sNames*.txt in Imported folder)
.\Convert-NamesToJson.ps1
```

This creates `names.json` in the Names folder, which is required by Get-GivenName and Get-Surname.

## Best Practices

### Format-Name - Input Validation
```powershell
# Handle null or empty input
$name = "  "
if ([string]::IsNullOrWhiteSpace($name)) {
    Write-Warning "Name cannot be empty"
} else {
    $formatted = Format-Name $name
}
```

### Format-Name - Batch Processing
```powershell
# Process large datasets efficiently
$names = Get-Content "large_name_list.txt"
$formatted = $names | Format-Name
$formatted | Set-Content "formatted_names.txt"
```

### Name Generation - Test User Creation
```powershell
# Generate realistic test users with unique emails
$testUsers = 1..100 | ForEach-Object {
    $first = Get-GivenName -Country USA
    $last = Get-Surname -Country USA
    
    [PSCustomObject]@{
        FirstName = $first
        LastName = $last
        FullName = "$first $last"
        Email = "$first.$last@testdomain.com".ToLower()
        Department = (Get-Random -InputObject @("IT", "HR", "Sales", "Marketing"))
        Country = "USA"
    }
}
```

### Name Generation - Multi-Country Datasets
```powershell
# Create diverse test population
$countries = @('Sweden', 'Norway', 'USA', 'ENGLANDWALES')
$testUsers = 1..200 | ForEach-Object {
    $country = Get-Random -InputObject $countries
    [PSCustomObject]@{
        GivenName = Get-GivenName -Country $country
        Surname = Get-Surname -Country ALL  # Use ALL for countries without surnames
        Country = $country
    }
}
```

## Edge Cases

The function handles various edge cases:
- **Extra whitespace**: Trimmed automatically
- **All uppercase**: Converted to title case
- **All lowercase**: Converted to title case
- **Mixed case**: Normalized to title case
- **Single word**: Formatted correctly
- **Multiple words**: Each word formatted independently

## Limitations

### Format-Name - Special Cases
The function uses standard title casing, which may not be appropriate for:
- **Prefixes**: "McDonald" → "Mcdonald" (should be "McDonald")
- **Roman numerals**: "henry VIII" → "Henry Viii" (should be "Henry VIII")
- **Compound names**: "Jean-Paul" → "Jean-paul" (hyphen treated as word separator)

For these special cases, additional processing may be needed.

### Get-GivenName / Get-Surname - Data Availability
- **Denmark and Finland**: Only given names available, no surnames in database
- **Name Accuracy**: Names are from historical data and may not reflect current naming trends
- **Cultural Naming**: Functions generate Western-style "FirstName LastName" combinations
- **Uniqueness**: Random selection means duplicates are possible in large datasets

## Common Patterns

### Generate Complete Test Users
```powershell
# Create comprehensive user objects
function New-TestUser {
    param([string]$Country = 'ALL')
    
    $firstName = Get-GivenName -Country $Country
    $lastName = Get-Surname -Country $Country
    
    [PSCustomObject]@{
        GivenName = $firstName
        Surname = $lastName
        DisplayName = "$firstName $lastName"
        SamAccountName = "$firstName.$lastName".ToLower()
        EmailAddress = "$firstName.$lastName@testdomain.com".ToLower()
        Country = $Country
    }
}

# Generate 50 test users
$users = 1..50 | ForEach-Object { New-TestUser -Country USA }
```

### Format and Export Names
```powershell
# Generate, format, and export to CSV
$names = 1..100 | ForEach-Object {
    $raw = "$(Get-GivenName -Country ALL) $(Get-Surname -Country ALL)"
    [PSCustomObject]@{
        OriginalName = $raw
        FormattedName = Format-Name $raw
    }
}
$names | Export-Csv "formatted_test_names.csv" -NoTypeInformation
```

### CSV Import with Formatting
```powershell
# Import CSV, format names, and re-export
Import-Csv "input.csv" | 
    Select-Object *, @{
        Name='FormattedName'
        Expression={Format-Name $_.Name}
    } |
    Export-Csv "output.csv" -NoTypeInformation
```

### Country-Specific Bulk Generation
```powershell
# Generate users by country
$usersByCountry = @{}
@('Sweden', 'Norway', 'USA', 'ENGLANDWALES') | ForEach-Object {
    $country = $_
    $usersByCountry[$country] = 1..25 | ForEach-Object {
        [PSCustomObject]@{
            Name = "$(Get-GivenName -Country $country) $(Get-Surname -Country ALL)"
            Country = $country
        }
    }
}
```

## Author

**Fredrik Wall**
- Email: wall.fredrik@gmail.com
- Blog: [www.poweradmin.se](http://www.poweradmin.se)
- Twitter: [@walle75](https://twitter.com/walle75)
- GitHub: [https://github.com/FredrikWall](https://github.com/FredrikWall)

## Version History

### Version 4.0 (2025-12-28)
- **New**: Added Get-GivenName function with JSON data storage
- **New**: Added Get-Surname function with JSON data storage
- **New**: Added Convert-NamesToJson utility script
- **New**: Consolidated name data into names.json (6,754 given names, 1,700 surnames)
- **New**: Multi-country support (Denmark, England/Wales, Finland, Norway, Sweden, USA)
- **Enhancement**: Added parameter validation with ValidateSet
- **Data**: Migrated from 10+ TXT files to single JSON file

### Version 1.4 (2025-12-27)
- **Format-Name**: Major optimization using TextInfo.ToTitleCase()
- Reduced code complexity by ~70%
- Improved performance significantly
- Better pipeline support with process block

### Version 1.3 (2021-12-28)
- Code cleanup and refactoring
- Improved readability

### Version 1.0 (2017-11-03)
- Initial release
- Basic name formatting functionality

## License

See the LICENSE file in the repository root for license information.

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page if you want to contribute.

## Related Functions

For related functionality, see also:
- **Real Fake Names** - Complete script for generating full test names (Create-RealFakeNames.ps1)
- **Active Directory** - LDAP user management functions for creating test AD users
- **Applications** - Application management and metadata extraction functions

## Files in This Module

- **Format-Names.ps1** - Name formatting function
- **Get-GivenName.ps1** - Random given name generation
- **Get-Surname.ps1** - Random surname generation  
- **Convert-NamesToJson.ps1** - Utility to convert TXT files to JSON
- **names.json** - Consolidated name database (6,754 given names, 1,700 surnames)
- **Imported/** - Source TXT files (for regenerating JSON if needed)

## Testing

### Test Format-Name
```powershell
# Test various name formats
$testCases = @(
    @{Input = "john"; Expected = "John"}
    @{Input = "JANE"; Expected = "Jane"}
    @{Input = "alice SMITH"; Expected = "Alice Smith"}
    @{Input = "  bob  jones  "; Expected = "Bob Jones"}
    @{Input = "mArY kAtE"; Expected = "Mary Kate"}
)

foreach ($test in $testCases) {
    $result = Format-Name $test.Input
    $pass = $result -eq $test.Expected
    Write-Host "$($test.Input) → $result [$($pass ? 'PASS' : 'FAIL')]"
}
```

### Test Name Generation
```powershell
# Test Get-GivenName for all countries
@('Denmark', 'ENGLANDWALES', 'Finland', 'Norway', 'Sweden', 'USA', 'ALL') | ForEach-Object {
    $name = Get-GivenName -Country $_
    Write-Host "$_ : $name"
}

# Test Get-Surname for countries with surname data
@('ENGLANDWALES', 'Norway', 'Sweden', 'USA', 'ALL') | ForEach-Object {
    $surname = Get-Surname -Country $_
    Write-Host "$_ : $surname"
}

# Verify names.json is accessible
if (Test-Path "names.json") {
    $data = Get-Content "names.json" | ConvertFrom-Json
    Write-Host "Countries available: $($data.PSObject.Properties.Name -join ', ')"
} else {
    Write-Warning "names.json not found!"
}
```