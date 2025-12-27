Function New-LDAPOU
{
<#
	.SYNOPSIS
		Creates an Active Directory OU object
	
	.DESCRIPTION
		Creates an Active Directory OU object using LDAP.
        Created with just the basic stuff.
	
    .PARAMETER GroupOU
		The name of the OU
        
    .PARAMETER OUPath
        The distinguishedName of the OU where the new OU should be created in.
        
    .EXAMPLE
        New-LDAPOU -OUName "OU01" -OUPath "OU=Test,OU=LabOU,DC=poweradmin,DC=se"
        
    .EXAMPLE
        New-LDAPOU "OU01" "OU=Test,OU=LabOU,DC=poweradmin,DC=se"
        
	.NOTES
		NAME:       New-LDAPOU
		AUTHOR:     Fredrik Wall, wall.fredrik@gmailcom
		TWITTER:    @walle75
		BLOG:       http://www.poweradmin.se
		CREATED:    2012-01-15
		UPDATED:    2016-03-13
		VERSION:    2.1
					
					2.1 - Added error handling
					1.0 - Initial version
	
	.LINK
		https://github.com/FredrikWall

#>
	
	[CmdletBinding()]
	Param (
		[Parameter(Position = 1, Mandatory = $true)]
		$OUName,
		[Parameter(Position = 2, Mandatory = $true)]
		$OUPath
	)
	
	try
	{
        $myOU = new-Object DirectoryServices.DirectoryEntry "LDAP://$OUPath"
		$newOU = $myOU.Create("organizationalUnit","ou=$OUName")
		$newOU.SetInfo()
	}
	catch
	{
		Write-Warning "$OUName `n$_"
	}
}