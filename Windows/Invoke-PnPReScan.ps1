<#
    .SYNOPSIS
        This script performs an Plug n Play Device ReScan
    .DESCRIPTION
        This script performs an Plug n Play Device ReScan
    .PARAMETER WaitTime
        The wait time in seconds for the devices to be ready after ReScan
    .EXAMPLE
        Invoke-PnPReScan.ps1 -WaitTime 30
    .NOTES
        NAME:      	Invoke-PnPReScan
        AUTHOR:    	Fredrik Wall, fredrik.powershell@gmail.com
        VERSION:    1.0
        CREATED:	11/19/2017
#>

[CmdletBinding()]
Param (
	[Parameter(Mandatory=$false)]
	[string]$WaitTime = '20'
)

# Run the script as Administrator
# Some code is from Ben Armstrongs blog post:
# https://blogs.msdn.microsoft.com/virtual_pc_guy/2010/09/23/a-self-elevating-powershell-script/

# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
 
# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

if (!($myWindowsPrincipal.IsInRole($adminRole))) {
   # We are not running "as Administrator" - so relaunch as administrator
   Write-Output "Starting PowerShell As Administrator"

   # Create a new process object that starts PowerShell
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   
   # Specify the current script path and name as a parameter
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   
   # Indicate that the process should be elevated
   $newProcess.Verb = "runas";
   
   # Start the new process
   [System.Diagnostics.Process]::Start($newProcess) | Out-Null
   
   # Exit from the current, unelevated, process
   exit
}


function InitDeviceClass

{
    # Function from Matt Bielman
    # https://blogs.msdn.microsoft.com/mattbie/2010/02/23/how-to-call-net-and-win32-methods-from-powershell-and-your-troubleshooting-packs/ 


    [string]$SourceCode =  @"

    using System.Runtime.InteropServices;

    using System;

   

    namespace mattbie.examples.devices

    {

        // These are the native win32 methods that we require

        internal static class NativeMethods

        {

            [DllImport("cfgmgr32.dll", SetLastError = true, EntryPoint = "CM_Locate_DevNode_Ex", CharSet = CharSet.Auto)]

            public static extern UInt32 CM_Locate_DevNode_Ex(ref UInt32 DevInst, IntPtr DeviceID, UInt64 Flags, IntPtr Machine);

 

            [DllImport("cfgmgr32.dll", SetLastError = true, EntryPoint = "CM_Reenumerate_DevNode_Ex", CharSet = CharSet.Auto)]

            public static extern UInt32 CM_Reenumerate_DevNode_Ex(UInt32 DevInst, UInt64 Flags, IntPtr Machine);

 

            [DllImport("cfgmgr32.dll", SetLastError = true, EntryPoint = "CMP_WaitNoPendingInstallEvents", CharSet = CharSet.Auto)]

            public static extern UInt32 CMP_WaitNoPendingInstallEvents(UInt32 TimeOut);

        }

       

        // This class houses the public methods that we'll use from powershell

        public static class StaticMethods

        {

       

            public const UInt32 CR_SUCCESS = 0;

            public const UInt64 CM_REENUMERATE_SYNCHRONOUS = 1;

            public const UInt64 CM_LOCATE_DEVNODE_NORMAL = 0;

           

            public static UInt32 RescanAllDevices()

            {

                //only connect to local device nodes

                UInt32 ResultCode = 0;

                IntPtr LocalMachineInstance = IntPtr.Zero;

                UInt32 DeviceInstance = 0;

                UInt32 PendingTime = 30000;

 

                ResultCode = NativeMethods.CM_Locate_DevNode_Ex(ref DeviceInstance, IntPtr.Zero, CM_LOCATE_DEVNODE_NORMAL, LocalMachineInstance);

                if (CR_SUCCESS == ResultCode)

                {

                    ResultCode = NativeMethods.CM_Reenumerate_DevNode_Ex(DeviceInstance, CM_REENUMERATE_SYNCHRONOUS, LocalMachineInstance);

                    ResultCode = NativeMethods.CMP_WaitNoPendingInstallEvents(PendingTime);

                }

                return ResultCode;

            }

        }

    }

"@

 

    # use the powershell 2.0 add-type cmdlet to compile the source and make it available to our powershell session
    add-type -TypeDefinition $SourceCode
}

Write-Output "Plug n Play Devices before ReScan: $((Get-PnpDevice *).count)"
Write-Output "Doing a Plug n Play Device ReScan"
# Load up our C# code
InitDeviceClass

# Call the RescanAllDevices method
[mattbie.examples.devices.staticmethods]::RescanAllDevices() | Out-Null

Write-Output "Waiting in $WaitTime seconds for the devices"
Start-Sleep -Seconds $WaitTime

Write-Output "Plug n Play Devices after ReScan: $((Get-PnpDevice *).count)"