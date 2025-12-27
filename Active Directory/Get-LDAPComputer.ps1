Function Get-LDAPComputer
{
<#
	.SYNOPSIS
		Looks up Active Directory information about a computer
	
	.DESCRIPTION
		Looks up Active Directory information about a computer object using LDAP
	
	.PARAMETER ComputerName
		The name of the computer that you want to get information about
	
	.EXAMPLE
		Get-LDAPComputer -ComputerName PC001
	
	.EXAMPLE
            "PC001","PC002" | Get-LDAPComputer
	 
    .EXAMPLE
            ("PC001" | Get-LDAPComputer).Path
            
	.EXAMPLE
            "PC001" | Get-LDAPComputer | gm
	
	.NOTES
		NAME:       Get-LDAPComputer
		AUTHOR:     Fredrik Wall, wall.fredrik@gmail.com
		TWITTER:    @walle75
		BLOG:       https://www.poweradmin.se
		CREATED:    2012-01-20
		UPDATED:   	2016-03-08
		VERSION:    2.2
					
					2.2 - Fixed issue when computer not found
					2.1 - Added pipeline support
					1.0 - Initial version
		
	.LINK
		https://github.com/FredrikWall
#>
	
	[CmdletBinding()]
	Param ([Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $true)]
		$ComputerName)
	
	Process
	{
		foreach ($myComputer in $ComputerName)
		{
			
			$myActiveDomain = new-object DirectoryServices.DirectoryEntry
			$myDomain = $myActiveDomain.distinguishedName
			$mySearcher = [System.DirectoryServices.DirectorySearcher]"[ADSI]LDAP://$myDomain"
			$mySearcher.filter = "(&(objectClass=computer)(name=$myComputer))"
			
			try
			{
				$mySearcher = $mySearcher.findone().getDirectoryEntry()
				$myDistName = $mySearcher.distinguishedName
				[ADSI]"LDAP://$myDistName"
			}
			catch
			{
				Write-Warning "$_"
			}
		}
	}
}