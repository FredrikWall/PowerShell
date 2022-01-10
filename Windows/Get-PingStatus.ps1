function Get-PingStatus {
	<#
	.SYNOPSIS
		This function will help you to test if a computer is pingable.

	.DESCRIPTION
		This function will help you to test if a computer is pingable.

	.PARAMETER  ComputerName
		The name or IP address of the computer
	.EXAMPLE
		Get-PingStatus -ComputerName Server01
	.EXAMPLE
		if (Get-PingStatus -ComputerName server01) { Write-Host "I'm up!" }
	.EXAMPLE
		if (-not(Get-PingStatus -ComputerName server01)) { Write-Host "I'm not up!" }
	.NOTES
		NAME:      	Get-PingStatus
		AUTHOR:    	Fredrik Wall, fredrik.powershell@gmail.com
        VERSION:    1.3
		CREATED:	21/07/2009
        LASTEDIT:  	12/27/2021
                    Changed parameter name for best practice
                    
                    09/02/2018
                    Added/Changed so the function will support PowerShell 6.0+

                    10/02/2011
					Some minor changes.
					Added Synopsis, Description, Parameter, Examples and Notes.
	#>

	param ($ComputerName)
	$myPingStatus = Get-CimInstance -Query "SELECT StatusCode FROM win32_PingStatus
	WHERE ADDRESS = '$ComputerName'"
	if ($myPingStatus.StatusCode -eq 0) {
		$true
	}
	else {
		$false
	}
}

if (Get-PingStatus -ComputerName $env:COMPUTERNAME) { Write-Host "I'm up!" }