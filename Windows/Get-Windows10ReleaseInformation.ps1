function Get-Windows10ReleaseInformation {
    <#
        .SYNOPSIS
            Will get Windows 10 release Information
        .DESCRIPTION
            Will get Windows 10 release Information from Microsoft.
            https://winreleaseinfoprod.blob.core.windows.net/winreleaseinfoprod/en-US.html
        .EXAMPLE
            C:\PS> Get-Windows10ReleaseInformation
            Will show all information in list format.
        .EXAMPLE
            C:\PS> Get-Windows10ReleaseInformation | ConvertTo-Json
            Will show all information in json format.
        .EXAMPLE
            C:\PS> Get-Windows10ReleaseInformation | ConvertTo-Json | Out-File .\Windows10BuildInformation.json
            Will save the json format to a file.
        .NOTES
            NAME:      	Get-Windows10ReleaseInformation
            AUTHOR:    	Fredrik Wall, fredrik.powershell@gmail.com
            VERSION:    1.0
            CREATED:	19/11/2020

            INFO:
            The extracting of Tables comes from Lee Holmes function Get-WebRequestTable.
            https://www.leeholmes.com/blog/2015/01/05/extracting-tables-from-powershells-invoke-webrequest/
    #>
    
    $Url = "https://winreleaseinfoprod.blob.core.windows.net/winreleaseinfoprod/en-US.html"
    $Webpage = Invoke-RestMethod $Url
    $HTML = New-Object -Com "HTMLFile"

    # Write HTML content according to DOM Level2 
    $HTML.IHTMLDocument2_write($Webpage)

    $Version = @($HTML.all.tags("h4"))
    $ReleaseVersions = ($Version.outerText).Substring(2)
    
    $TableNumber = 2
    $HTML.IHTMLDocument2_write($Webpage)

    foreach ($Version in $ReleaseVersions) {
   
        $Tables = @($HTML.all.tags("table"))
   
        $Table = $Tables[$TableNumber]

        $Titles = @()

        $Rows = @($Table.Rows)
    
        foreach ($Row in $Rows) {

            $Cells = @($Row.Cells)

            ## If we've found a table header, remember its titles

            if ($Cells[0].tagName -eq "TH") {

                $Titles = @($Cells | ForEach-Object { ("" + $_.InnerText).Trim() })

                continue

            }

            ## If we haven't found any table headers, make up names "P1", "P2", etc.

            if (-not $Titles) {

                $Titles = @(1..($Cells.Count + 2) | ForEach-Object { "P$_" })

            }

            ## Now go through the cells in the the row. For each, try to find the

            ## title that represents that column and create a hashtable mapping those

            ## titles to content

            $ResultObject = [Ordered] @{}

            for ($Counter = 0; $Counter -lt $Cells.Count; $Counter++) {
            
                $Title = "Version"
                $ResultObject[$Title] = $Version

            }

            for ($Counter = 0; $Counter -lt $Cells.Count; $Counter++) {
            
                $Title = $Titles[$Counter]

                if (-not $Title) { continue }

                $ResultObject[$Title] = ("" + $Cells[$Counter].InnerText).Trim()

            }

            ## And finally cast that hashtable to a PSCustomObject

            [PSCustomObject] $ResultObject 

        }
        $TableNumber++
    }
}

Get-Windows10ReleaseInformation | ConvertTo-Json | Out-File .\Windows10BuildInformation.json