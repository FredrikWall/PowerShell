<#
.SYNOPSIS
    Convert name text files to consolidated JSON format

.DESCRIPTION
    Converts individual TXT files (gNames*.txt and sNames*.txt) into a single
    structured JSON file for easier management and faster loading.

.NOTES
    Author: Fredrik Wall
    Created: 2025-12-28
    Version: 1.0
#>

$importPath = "$PSScriptRoot\Imported"
$outputFile = "$PSScriptRoot\names.json"

Write-Host "Converting name files to JSON..." -ForegroundColor Cyan

# Initialize the data structure
$nameData = @{}

# Get all name files
$files = Get-ChildItem -Path $importPath -Filter "*.txt"

foreach ($file in $files) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Gray
    
    # Parse filename to get country and type
    if ($file.Name -match '^(g|s)Names(.+)\.txt$') {
        $type = if ($matches[1] -eq 'g') { 'GivenNames' } else { 'Surnames' }
        $country = $matches[2]
        
        # Read names from file (trim whitespace and filter empty lines)
        $names = Get-Content -Path $file.FullName | 
                 ForEach-Object { $_.Trim() } | 
                 Where-Object { $_ -ne '' }
        
        # Initialize country if not exists
        if (-not $nameData.ContainsKey($country)) {
            $nameData[$country] = @{
                GivenNames = @()
                Surnames = @()
            }
        }
        
        # Add names to the structure
        $nameData[$country][$type] = $names
        
        Write-Host "  Added $($names.Count) $type for $country" -ForegroundColor Green
    }
}

# Convert to JSON with proper formatting
$json = $nameData | ConvertTo-Json -Depth 10

# Save to file
$json | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "`nConversion complete!" -ForegroundColor Green
Write-Host "Output file: $outputFile" -ForegroundColor Cyan
Write-Host "`nSummary:" -ForegroundColor Yellow

# Display summary
foreach ($country in $nameData.Keys | Sort-Object) {
    $givenCount = $nameData[$country].GivenNames.Count
    $surnameCount = $nameData[$country].Surnames.Count
    Write-Host "  $country : $givenCount given names, $surnameCount surnames"
}

Write-Host "`nExample usage:" -ForegroundColor Yellow
Write-Host '  $names = Get-Content "names.json" | ConvertFrom-Json' -ForegroundColor White
Write-Host '  $names.Sweden.GivenNames | Get-Random' -ForegroundColor White
