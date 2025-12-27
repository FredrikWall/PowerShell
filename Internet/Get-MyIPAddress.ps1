function Get-MyIPAddress {
<#
    .SYNOPSIS
        Get you Internet IP Address

    .DESCRIPTION
        Get you Internet IP Address from IPify API.
        
    .EXAMPLE
        Get-MyIPAddress
        
    .NOTES
        AUTHOR:     Fredrik Wall, wall.fredrik@gmail.com
        CREATED:    2020-02-21
        VERSION:    1.0
        UPDATED:    2025-12-27
        VERSION:    1.1 - Updated API endpoint to support IPv6 addresses.
#>

    $MyIPAddress = Invoke-RestMethod "https://api64.ipify.org?format=json" | Select-Object -ExpandProperty ip

    Return $MyIPAddress
}

Get-MyIPAddress
