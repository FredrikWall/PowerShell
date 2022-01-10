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
        AUTHOR:    	Fredrik Wall, fredrik.powershell@gmail.com
        VERSION: 	1.3
        CREATED:	11/03/2017
        CHANGED:    12/28/2021

        Changes:
        1.3
        Some cleanup of the code
    #>
	
    [CmdletBinding()]
    param
    (
        [Parameter(ValueFromPipeline, Mandatory = $true)]
        $Name
    )
	
    $Name = $Name.Trim()
	
    # If It's double name or more
    if ($Name.IndexOf(" ") -ne "-1") {
		
        $TheName = $Name.Split(" ")
        $TheNames = @()
		
        foreach ($MyName in $TheName) {
            $MyName = "$((($MyName).Trim()).ToUpper().Substring(0, 1))$((($MyName).Trim()).ToLower().Substring(1))"
            $TheNames += $MyName
        }
		
        [string]$FixedName = $TheNames
        Return $FixedName
    }
    else {
        $MyName = "$((($Name).Trim()).ToUpper().Substring(0, 1))$((($Name).Trim()).ToLower().Substring(1))"
        [string]$FixedName = $MyName
        Return $FixedName
    }
}