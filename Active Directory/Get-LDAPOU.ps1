Function Get-LDAPOU
{
	<# 
	    .SYNOPSIS
            Get Active Directory OU information
            
	    .DESCRIPTION
            Get Active Directory OU information using LDAP
             
        .PARAMETER OUName
			The name of the OU that you want to get information about
        
	    .EXAMPLE
            Get-LDAPOU -OUName OU001
            
	    .EXAMPLE
            "OU001" | Get-LDAPOU
            
	    .EXAMPLE
            "OU001","OU002" | Get-LDAPOU
            
	    .EXAMPLE
            ("OU001" | Get-LDAPOU).distinguishedName
            
	    .EXAMPLE
            "OU001" | Get-LDAPOU | gm
            
        .NOTES
            NAME:       Get-LDAPOU
            AUTHOR:     Fredrik Wall, wall.fredrik@gmail.com
            TWITTER:    @walle75
            BLOG:       http://www.poweradmin.se
            CREATED:    2012-01-01
            UPDATED:    2016-03-09
			VERSION:    2.1

						2.1 - Added pipeline support
						1.0 - Initial version
	
        .LINK
            https://github.com/FredrikWall
            
	#>
	
	[CmdletBinding()]
	Param ([Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $true)]
		$OUName)
	Process
	{
		foreach ($myOU in $OUName)
		{
			
			$myActiveDomain = new-object DirectoryServices.DirectoryEntry
			$myDomain = $myActiveDomain.distinguishedName
			$mySearcher = [System.DirectoryServices.DirectorySearcher]"[ADSI]LDAP://$myDomain"
			$mySearcher.filter = "(&(objectClass=organizationalUnit)(name=$OUName))"
			
			
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