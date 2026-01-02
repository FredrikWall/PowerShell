function Format-Name {
    <#
	.SYNOPSIS
		Formating Name and Names
	.DESCRIPTION
		Formating Name and Names with first upper case and rest to lower case
	.PARAMETER Name
		The name or names you want to format
	.EXAMPLE
        PS C:\> Format-Name -Name "fredrik"
    .EXAMPLE
        PS C:\> Format-Name -Name "fredrik wall"
    .EXAMPLE
        PS C:\> Format-Name -Name "fredrik nissE wall"
    .EXAMPLE
        PS C:\> "fredrik" | Format-Name
	.NOTES
        Author:  Fredrik Wall
        Email:   wall.fredrik@gmail.com
        Blog:    www.poweradmin.se
        Twitter: @walle75
        Created: 2017-03-11
        Updated: 2025-12-30
        Version: 1.4
        
        Changelog:
        1.4 (2025-12-27) - Optimized code: reduced redundant operations, used -split operator, removed unnecessary variables, used TextInfo for title case conversion
        1.3              - Some cleanup of the code
        1.0 (2017-03-11) - Initial version
    #>
	
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipeline, Mandatory = $true)]
        [string]$Name
    )
	
    process {
        # Use TextInfo for proper title casing
        $textInfo = (Get-Culture).TextInfo
        
        # Trim and convert to title case in one operation
        # This handles single and multiple names efficiently
        $textInfo.ToTitleCase($Name.Trim().ToLower())
    }
}