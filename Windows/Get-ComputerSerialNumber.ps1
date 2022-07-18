function Get-ComputerSerialNumber {
    <#
        .SYNOPSIS
            Gets computer serial number
        .DESCRIPTION
            Gets computer serial number
        .EXAMPLE
            C:\PS> Get-ComputerSerialNumber
        .NOTES
            NAME:       Get-ComputerSerialNumber
            AUTHOR:     Fredrik Wall, fredrik.powershell@gmail.com
            VERSION:    1.0
            CREATED:    12/27/2021
    #>
    $ComputerSerialNumber = (Get-CimInstance -ClassName Win32_Bios).SerialNumber
    Return $ComputerSerialNumber
}