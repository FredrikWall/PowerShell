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
        NAME:      	Format-Name
        AUTHOR:    	Fredrik Wall, wall.fredrik@gmail.com
        CREATED:	2017-03-11
        UPDATED:    2025-12-27
        VERSION: 	1.4
                    1.4 - Optimized code: reduced redundant operations, used -split operator,
                        removed unnecessary variables, used TextInfo for title case conversion
                    1.3 - Some cleanup of the code
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