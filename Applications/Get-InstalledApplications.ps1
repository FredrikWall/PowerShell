function Get-InstalledApplications {
    <#
    .SYNOPSIS
        Retrieve installed applications from the local computer's uninstall registry keys
    
    .DESCRIPTION
        Enumerates the standard uninstall registry locations (both 64-bit and
        32-bit WOW6432Node) and returns structured PSCustomObjects describing
        installed software entries. The function is pipeline-friendly and
        de-duplicates entries that appear in multiple registry hives.
    
    .PARAMETER ApplicationName
        Optional. A regex or substring to match against DisplayName. Accepts
        pipeline input. If not specified, returns all installed applications.
    
    .PARAMETER ExactMatch
        When specified, matches DisplayName using exact (case-insensitive)
        equality instead of regex matching.
    
    .EXAMPLE
        Get-InstalledApplications
        Returns all installed applications
    
    .EXAMPLE
        Get-InstalledApplications -ApplicationName Chrome
        Returns installed applications whose DisplayName matches 'Chrome'
    
    .EXAMPLE
        Get-InstalledApplications -ApplicationName "Google Chrome" -ExactMatch
        Returns only applications with the exact name "Google Chrome"
    
    .EXAMPLE
        'Adobe' | Get-InstalledApplications
        Pipeline example where the input is treated as ApplicationName
    
    .INPUTS
        System.String. You can pipe application names to Get-InstalledApplications.
    
    .OUTPUTS
        PSCustomObject with DisplayName, DisplayVersion, Publisher, and InstallDate properties
    
    .NOTES
        Author:  Fredrik Wall
        Email:   wall.fredrik@gmail.com
        Blog:    www.poweradmin.se
        Twitter: @walle75
        Created: 2015-03-08
        Updated: 2025-12-31
        Version: 1.6
        
        Changelog:
        1.6 (2025-12-31) - Updated comment-based help to modern format
        1.5 (2025-12-03) - Performance improvements and de-duplication
        1.0 (2015-03-08) - Initial version
    #>

    [CmdletBinding()]
    param (
        [Parameter(Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [string]
        $ApplicationName,

        [switch]
        $ExactMatch
    )

    begin {
        $uninstallPaths = @(
            'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall',
            'HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
        )

        # Hashtable to de-duplicate by DisplayName (case-insensitive)
        $emitted = @{ }
    }

    process {
        foreach ($path in $uninstallPaths) {
            try {
                $keys = Get-ChildItem -Path $path -ErrorAction Stop
            }
            catch {
                # Skip missing registry path
                continue
            }

            foreach ($key in $keys) {
                try {
                    $props = Get-ItemProperty -Path $key.PSPath -ErrorAction Stop
                }
                catch {
                    continue
                }

                if (-not $props.DisplayName) { continue }

                # Filtering
                $match = $true
                if ($ApplicationName) {
                    if ($ExactMatch) {
                        $match = ($props.DisplayName -ieq $ApplicationName)
                    }
                    else {
                        $match = ($props.DisplayName -match $ApplicationName)
                    }
                }

                if ($match) {
                    $keyName = $props.DisplayName.ToLower()
                    if (-not $emitted.ContainsKey($keyName)) {
                        $emitted[$keyName] = $true
                        [PSCustomObject]@{
                            DisplayName     = $props.DisplayName
                            DisplayVersion  = $props.DisplayVersion
                            Publisher       = $props.Publisher
                            InstallDate     = $props.InstallDate
                        }
                    }
                }
            }
        }
    }

    end {
        # Nothing to do; objects already streamed during processing.
    }
}