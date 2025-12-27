Function Get-LDAPGroup
{
	<# 
	    .SYNOPSIS
            Get Active Directory group information
            
	    .DESCRIPTION
            Get Active Directory group information using LDAP
             
        .PARAMETER GroupName
		The name of the group that you want to get information about
        
	    .EXAMPLE
            Get-LDAPGroup -GroupName GROUP01
            
	    .EXAMPLE
            "GROUP01" | Get-LDAPGroup
            
	    .EXAMPLE
            "GROUP01","GROUP02" | Get-LDAPGroup
            
	    .EXAMPLE
            ("GROUP01" | Get-LDAPGroup).Path
            
	    .EXAMPLE
            "GROUP01" | Get-LDAPGroup | gm
            
        .NOTES
            NAME:       Get-LDAPGroup
            AUTHOR:     Fredrik Wall, wall.fredrik@gmailcom
            TWITTER:    @walle75
            BLOG:       http://www.poweradmin.se
            CREATED:    2012-02-12
			UPDATED:    2016-03-07
			VERSION:    2.1
						
					    2.1 - Added pipeline support
						1.0 - Initial version
            
	
        .LINK
            https://github.com/FredrikWall
        
	#>	
	
	[CmdletBinding()]
	Param ([Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $true)]
		$GroupName)
	Process
	{
		foreach ($myGroup in $GroupName)
		{
			
			$myActiveDomain = new-object DirectoryServices.DirectoryEntry
			$myDomain = $myActiveDomain.distinguishedName
			$mySearcher = [System.DirectoryServices.DirectorySearcher]"[ADSI]LDAP://$myDomain"
			$mySearcher.filter = "(&(objectClass=group)(name=$myGroup))"
			
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