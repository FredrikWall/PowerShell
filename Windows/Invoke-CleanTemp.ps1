function Invoke-CleanTemp {
    <#
        .Synopsis
            Will clean local temp folders
        .Description
            Will clean local temp folders
        .Parameter Force
            Closes running programs from the application array in the function
        .Parameter AllUsers
            Will clean temp folders for All Users
        .Example
            PS C:\> Invoke-CleanTemp
            Will start the function and try to delete files and folder in the current users temp and
            in the C:\Windows\Temp folder.
        .Example
            PS C:\> Invoke-CleanTemp -Force
            Will start the function and closing the applications that are in the applications array
            and then tries to delete files and folder in the current users temp and
            in the C:\Windows\Temp folder.
        .Example
            PS C:\> Invoke-CleanTemp -AllUsers
            Will start the function and try to delete files and folder for all users temp folders and
            in the C:\Windows\Temp folder.
        .Notes
            NAME:      	Invoke-CleanTemp
            AUTHOR:    	Fredrik Wall, fredrik.powershell@gmail.com
            VERSION:    2.0
            CREATED:    04/07/2010
            LASTEDIT:  	26/11/2020
            CHANGES:   	04/07/2010  -   Added support for closing Chrome and Tweetdeck
                        30/09/2010  -   Added support for closing Skype, Spotify, iTunes and Safari
                        26/11/2020  -   Changed parameter name to Force for closing applications
                                        Added and removed applications to close
                                        Added support for WhatIf to show what the function will do if the parameter is used
                                        Added support for All Users

    #>
    #Requires -RunAsAdministrator
    [Cmdletbinding(SupportsShouldProcess)]
    param (
        [Parameter()]
        [Switch]
        $AllUsers,
        [Parameter()]
        [Switch]
        $Force
    )
    
    if ($Force) {
        $ApplicationsToStop = "iexplore", "outlook", "winword", "excel", "chrome", "skype", "lync", "spotify", "itunes", "safari", "firefox", "teams"
        $ApplicationsToStop | Foreach-Object {
            $Application = (Get-Process $_ -ErrorAction SilentlyContinue).Name
            if ($Application) {
                $Application = ($Application | Get-Unique).ToLower()
                
                if ($PSCmdlet.ShouldProcess($Application, 'Closing Application')) {
                    Stop-Process -Name $Application -Force 
                }
                else {
                }
            }
        }
    }
    
    if ($AllUsers) {
        $AllUsersTempFolderFilesAndFolders = Get-ChildItem -Path "C:\Users\*\AppData\Local\Temp" -Recurse
            
        $AllUsersTempFolderFilesAndFoldersCount = $AllUsersTempFolderFilesAndFolders.Count
        $AllUsersTempFolderFilesAndFoldersSize = "{0:N2} MB" -f (($AllUsersTempFolderFilesAndFolders | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1MB)

        if ($PSCmdlet.ShouldProcess("All Users Temp - C:\Users\*\AppData\Local\Temp ($AllUsersTempFolderFilesAndFoldersCount files and folders) ($AllUsersTempFolderFilesAndFoldersSize)", 'Remove')) {
            $AllUsersTempFolderFilesAndFolders | Remove-Item -Recurse -ErrorAction SilentlyContinue -Confirm:$false -Force
        }
        else {
        }
        
    }
    else {
        # Users temp folder
        $UsersTempFolderFilesAndFolders = Get-ChildItem $Env:temp -Recurse
        $UsersTempFolderFilesAndFoldersCount = $UsersTempFolderFilesAndFolders.Count
        $UsersTempFolderFilesAndFoldersSize = "{0:N2} MB" -f (($UsersTempFolderFilesAndFolders | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1MB)

        if ($PSCmdlet.ShouldProcess("$Env:Temp ($UsersTempFolderFilesAndFoldersCount files and folders) ($UsersTempFolderFilesAndFoldersSize)", 'Remove')) {
            $UsersTempFolderFilesAndFolders | Remove-Item -Recurse -ErrorAction SilentlyContinue -Confirm:$false -Force
        }
        else {
        }
    }

    # Windows temp folder
    $WindowsTempFolderFilesAndFolders = Get-ChildItem "C:\Windows\Temp" -Recurse -ErrorAction SilentlyContinue
    $WindowsTempFolderFilesAndFoldersCount = $WindowsTempFolderFilesAndFolders.Count
    $WindowsTempFolderFilesAndFoldersSize = "{0:N2} MB" -f (($WindowsTempFolderFilesAndFolders | Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1MB)
    
    if ($PSCmdlet.ShouldProcess("C:\Windows\Temp ($WindowsTempFolderFilesAndFoldersCount files and folders) ($WindowsTempFolderFilesAndFoldersSize)", 'Remove')) {
        $WindowsTempFolderFilesAndFolders | Remove-Item -Recurse -ErrorAction SilentlyContinue -Confirm:$false -Force
    }
    else {
    }
}