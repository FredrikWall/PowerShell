Function Get-LDAPUser
{
	<# 
	    .SYNOPSIS
            Get Active Directory user information
            
	    .DESCRIPTION
            Get Active Directory user information using LDAP
             
        .PARAMETER UserName
		The name of the user that you want to get information about
        
	    .EXAMPLE
            Get-LDAPUser -UserName User01
            
	    .EXAMPLE
            "USER01" | Get-LDAPUser
            
	    .EXAMPLE
            "USER01","USER02" | Get-LDAPUser
            
	    .EXAMPLE
            ("USER01" | Get-LDAPUser).Path
            
	    .EXAMPLE
            "USER01" | Get-LDAPUser | gm
            
        .NOTES
            NAME:       Get-LDAPUser
            AUTHOR:     Fredrik Wall, wall.fredrik@gmail.com
            TWITTER:    @walle75
            BLOG:       http://www.poweradmin.se
            CREATED:    2012-02-01
            UPDATED:   2016-03-07
            VERSION:    2.1
						
					    2.1 - Added pipeline support
						1.0 - Initial version
		.LINK
            https://github.com/FredrikWall             
            
	#>
    
    [CmdletBinding()]
	Param ([Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $true)]
		$UserName)
	Process
	{
		foreach ($myUser in $UserName)
		{
			
			$myActiveDomain = new-object DirectoryServices.DirectoryEntry
			$myDomain = $myActiveDomain.distinguishedName
			$mySearcher = [System.DirectoryServices.DirectorySearcher]"[ADSI]LDAP://$myDomain"
			$mySearcher.filter = "(&(objectClass=user)(sAMAccountName=$UserName))"
			
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
