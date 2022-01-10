function Get-ComputerManufacturer {
    <#
        .SYNOPSIS
            Gets computer manufacturer name
        .DESCRIPTION
            Gets computer manufacturer name
        .EXAMPLE
            C:\PS> Get-ComputerManufacturer
        .NOTES
            NAME:       Get-ComputerManufacturer
            AUTHOR:     Fredrik Wall, fredrik.powershell@gmail.com
            VERSION:    1.0
            CREATED:    12/27/2021
    #>
    $ComputerManufacturer = (Get-CimInstance -ClassName Win32_ComputerSystem).Manufacturer
    Return $ComputerManufacturer
}