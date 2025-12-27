Function New-LDAPUser
{
<#
	.SYNOPSIS
		Creates an Active Directory user object
	
	.DESCRIPTION
		Creates an Active Directory user object using LDAP.
        The user will be disabled. Created with just the basic stuff.
	
    .PARAMETER UserName
		The name of the user
        
    .PARAMETER SAMAccountName
		The SAMAccount name
        
    .PARAMETER OUPath
        The distinguishedName of the OU where the computer should be created in.
        
    .EXAMPLE
        New-LDAPUser -UserName "USER01" -SAMAccountName "USER01" -OUPath "OU=Test,OU=Users,OU=LabOU,DC=poweradmin,DC=local"
        
    .EXAMPLE
        New-LDAPComputer "USER01" "USER01" "OU=Test,OU=Users,OU=LabOU,DC=poweradmin,DC=local"
        
	.NOTES
		NAME:       New-LDAPUser
		AUTHOR:     Fredrik Wall, wall.fredrik@gmailcom
		TWITTER:    @walle75
		BLOG:       http://www.poweradmin.se
		CREATED:    2012-01-10
		UPDATED:    2016-03-09
        VERSION:    2.1

					2.1 - Added error handling
					1.0 - Initial version
	
	.LINK
		https://github.com/FredrikWall
#>
	
	[CmdletBinding()]
	Param (
		[Parameter(Position = 1, Mandatory = $true)]
		$UserName,
		[Parameter(Position = 2, Mandatory = $true)]
		$SAMAccountName,
		[Parameter(Position = 3, Mandatory = $true)]
		$OUPath
	)
	
	
	try
	{
		$myOU = new-Object DirectoryServices.DirectoryEntry "LDAP://$OUPath"
		$newUser = $myOU.psbase.children.add("cn=" + $UserName, "User")
		$newUser.psbase.commitchanges()
		
		$newUser.samaccountname = $SAMAccountName
		$newUser.psbase.commitchanges()
	}
	catch
	{
		Write-Warning "$UserName `n$_"
	}
}   
