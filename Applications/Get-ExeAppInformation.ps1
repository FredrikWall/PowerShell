function Get-ExeAppInformation {
    <#
	.SYNOPSIS
		Gets Exe Application Information from a EXE file
	.DESCRIPTION
		This function will check if the selected exe file have the application information that we wants.
	.PARAMETER Path
		Path to the EXE file
	.PARAMETER Property
		The Property that you want to get information from
	.EXAMPLE
		Get-EXEAppInformation -Path "JavaSetup8u144.exe" -Property "ProductName"
	
		Java Platform SE 8 U144
	.EXAMPLE
		Get-EXEAppInformation -Path "JavaSetup8u144.exe" -Property "ProductVersion"
	
		8.0.1440.1
	.NOTES
		NAME: 		Get-ExeApplication
		AUTHOR: 	Fredrik Wall, fredrik.powershell@gmail.com
		VERSION:	1.2
		CREATED:	23/01/2016
	#>
    [CmdletBinding()]
    Param ([Parameter(Mandatory = $true)]
        $Path,
        [Parameter(Mandatory = $false)]
        [ValidateSet("ProductName","ProductVersion","CompanyName","Language")]
        $Property
    )
    try {
		
        $ExeAppInformation = ((Get-Itemproperty -Path $Path).VersionInfo).$($Property)
        return $ExeAppInformation
		
    }
    catch {
        throw "Failed to get Exe application information. Error: {0}." -f $_
    }
}