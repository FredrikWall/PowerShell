Function New-LDAPGroup
{
<#
	.SYNOPSIS
		Creates an Active Directory group object
	
	.DESCRIPTION
		Creates an Active Directory group object using LDAP.
        Created with just the basic stuff.
	
    .PARAMETER GroupName
		The name of the Group
        
    .PARAMETER OUPath
        The distinguishedName of the OU where the group should be created in.
        
    .EXAMPLE
        New-LDAPGroup -GroupName "GROUP01" -OUPath "OU=Test,OU=Groups,OU=LabOU,DC=poweradmin,DC=se"
        
    .EXAMPLE
        New-LDAPGroup "GROUP01" "OU=Test,OU=Groups,OU=LabOU,DC=poweradmin,DC=se"
        
	.NOTES
		NAME:       New-LDAPGroup
		AUTHOR:     Fredrik Wall, wall.fredrik@gmailcom
		TWITTER:    @walle75
		BLOG:       http://www.poweradmin.se
		CREATED:    2012-01-15
		UPDATED:   2016-03-09
		VERSION:    2.1
					
					2.1 - Added error handling
					1.0 - Initial version
	
	.LINK
		https://github.com/FredrikWall

#>
	
	[CmdletBinding()]
	Param (
		[Parameter(Position = 1, Mandatory = $true)]
		$GroupName,
		[Parameter(Position = 3, Mandatory = $true)]
		$OUPath
	)
	
	try
	{
		$myOU = new-Object DirectoryServices.DirectoryEntry "LDAP://$OUPath"
		$newGroup = $myOU.psbase.children.add("cn=" + $GroupName, "group")
		$newGroup.psbase.commitchanges()

        $newGroup.samaccountname = $GroupName
		$newGroup.psbase.commitchanges()
	}
	catch
	{
		Write-Warning "$GroupName `n$_"
	}
}