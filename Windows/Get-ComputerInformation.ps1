<#
.SYNOPSIS
    Modern WPF-based Computer Information Tool

.DESCRIPTION
    A professional Windows Presentation Foundation (WPF) application for displaying
    comprehensive local computer information including system details, hardware specs,
    and security status.
    
    Features:
    - Modern, responsive WPF user interface
    - Display computer name, IP address, and network details
    - Show OS name, version, and architecture
    - Display antivirus status and definitions
    - Show computer model and manufacturer
    - Display processor and RAM information
    - Copy to clipboard functionality (individual fields or complete report)
    - Refresh capability to update information
    - Real-time status updates

.PARAMETER None
    This script does not accept parameters. Run it directly to launch the GUI.

.EXAMPLE
    .\Get-ComputerInformation.ps1
    Launches the WPF-based Computer Information Tool.

.EXAMPLE
    powershell.exe -File ".\Get-ComputerInformation.ps1"
    Runs the tool from command line or shortcut.

.INPUTS
    None. This is a GUI application.

.OUTPUTS
    None. Information is displayed in the GUI and can be copied to clipboard.

.NOTES
    Author:  Fredrik Wall
    Email:   wall.fredrik@gmail.com
    Blog:    www.poweradmin.se
    Twitter: @walle75
    Created: 2025-12-30
    Updated: 2025-12-30
    Version: 1.1
    
    Requirements:
    - PowerShell 3.0 or higher
    - Windows operating system with .NET Framework
    - PresentationFramework assembly (included in Windows)
    
    Changelog:
    1.1 (2025-12-30) - Added multi-language support (English and Swedish)
    1.0 (2025-12-30) - Initial release
    

.LINK
    https://github.com/FredrikWall/PowerShell
#>

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# XAML Definition for Modern UI
[xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Computer Information Tool" 
        Height="850" Width="750"
        WindowStartupLocation="CenterScreen"
        ResizeMode="CanResize"
        Background="#F5F5F5">
    
    <Window.Resources>
        <!-- Modern Button Style -->
        <Style x:Key="ModernButton" TargetType="Button">
            <Setter Property="Background" Value="#0078D4"/>
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontSize" Value="14"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Padding" Value="15,8"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" 
                                CornerRadius="4"
                                Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" 
                                            VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#005A9E"/>
                </Trigger>
                <Trigger Property="IsPressed" Value="True">
                    <Setter Property="Background" Value="#004578"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <!-- Refresh Button Style -->
        <Style x:Key="RefreshButton" TargetType="Button" BasedOn="{StaticResource ModernButton}">
            <Setter Property="Background" Value="#28A745"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#218838"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <!-- Copy Button Style -->
        <Style x:Key="CopyButton" TargetType="Button" BasedOn="{StaticResource ModernButton}">
            <Setter Property="Background" Value="#FFC107"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#E0A800"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <!-- Modern TextBox Style -->
        <Style x:Key="ModernTextBox" TargetType="TextBox">
            <Setter Property="Background" Value="White"/>
            <Setter Property="BorderBrush" Value="#CED4DA"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="10,8"/>
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="VerticalContentAlignment" Value="Center"/>
            <Setter Property="IsReadOnly" Value="True"/>
            <Style.Triggers>
                <Trigger Property="IsFocused" Value="True">
                    <Setter Property="BorderBrush" Value="#0078D4"/>
                    <Setter Property="BorderThickness" Value="2"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <!-- Label Style -->
        <Style x:Key="InfoLabel" TargetType="Label">
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Foreground" Value="#495057"/>
            <Setter Property="Padding" Value="0,5,0,2"/>
        </Style>
    </Window.Resources>

    <Grid Margin="20">
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="Auto"/>
        </Grid.RowDefinitions>

        <!-- Header -->
        <Border Grid.Row="0" Background="#0078D4" CornerRadius="8,8,0,0" Padding="20,15" Margin="0,0,0,15">
            <StackPanel>
                <TextBlock x:Name="txtHeaderTitle" Text="Computer Information" FontSize="24" FontWeight="Bold" Foreground="White"/>
                <TextBlock x:Name="txtHeaderSubtitle" Text="System and Hardware Details" FontSize="12" Foreground="#E0E0E0" Margin="0,5,0,0"/>
            </StackPanel>
        </Border>

        <!-- Main Content Area -->
        <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto" Margin="0,0,0,15">
            <StackPanel>
                <!-- Computer Information Section -->
                <Border Background="White" CornerRadius="8" Padding="20" Margin="0,0,0,15" 
                        BorderBrush="#DEE2E6" BorderThickness="1">
                    <StackPanel>
                        <TextBlock x:Name="lblComputerInfoSection" Text="Computer Information" FontSize="16" FontWeight="Bold" 
                                   Foreground="#212529" Margin="0,0,0,15"/>
                        
                        <Label x:Name="lblComputerName" Content="Computer Name:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtComputerName" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblIPAddress" Content="IP Address:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtIPAddress" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblMACAddress" Content="MAC Address:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtMACAddress" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                    </StackPanel>
                </Border>

                <!-- Operating System Section -->
                <Border Background="White" CornerRadius="8" Padding="20" Margin="0,0,0,15" 
                        BorderBrush="#DEE2E6" BorderThickness="1">
                    <StackPanel>
                        <TextBlock x:Name="lblOSSection" Text="Operating System" FontSize="16" FontWeight="Bold" 
                                   Foreground="#212529" Margin="0,0,0,15"/>
                        
                        <Label x:Name="lblOSName" Content="OS Name:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtOSName" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblOSVersion" Content="OS Version:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtOSVersion" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblOSRelease" Content="OS Release:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtOSRelease" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblArchitecture" Content="Architecture:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtArchitecture" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblLastBootTime" Content="Last Boot Time:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtLastBootTime" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblUptime" Content="Uptime:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtUptime" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                    </StackPanel>
                </Border>

                <!-- Security Section -->
                <Border Background="White" CornerRadius="8" Padding="20" Margin="0,0,0,15" 
                        BorderBrush="#DEE2E6" BorderThickness="1">
                    <StackPanel>
                        <TextBlock x:Name="lblSecuritySection" Text="Security" FontSize="16" FontWeight="Bold" 
                                   Foreground="#212529" Margin="0,0,0,15"/>
                        
                        <Label x:Name="lblAntivirus" Content="Antivirus Product:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtAntivirus" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblAntivirusStatus" Content="Antivirus Status:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtAntivirusStatus" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblDefinitionStatus" Content="Definition Status:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtDefinitionStatus" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblSignatureVersion" Content="Signature Version:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtSignatureVersion" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblSignatureUpdateDate" Content="Signature Update Date:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtSignatureUpdateDate" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                    </StackPanel>
                </Border>

                <!-- Hardware Section -->
                <Border Background="White" CornerRadius="8" Padding="20" Margin="0,0,0,15" 
                        BorderBrush="#DEE2E6" BorderThickness="1">
                    <StackPanel>
                        <TextBlock x:Name="lblHardwareSection" Text="Hardware" FontSize="16" FontWeight="Bold" 
                                   Foreground="#212529" Margin="0,0,0,15"/>
                        
                        <Label x:Name="lblManufacturer" Content="Manufacturer:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtManufacturer" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblModel" Content="Model:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtModel" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblSerialNumber" Content="Serial Number:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtSerialNumber" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblBIOSVersion" Content="BIOS Version:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtBIOSVersion" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblProcessor" Content="Processor:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtProcessor" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblRAM" Content="RAM:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtRAM" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblVideoCard" Content="Video Card:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtVideoCard" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                        
                        <Label x:Name="lblStorage" Content="Storage:" Style="{StaticResource InfoLabel}"/>
                        <TextBox x:Name="txtStorage" Style="{StaticResource ModernTextBox}" Margin="0,0,0,10"/>
                    </StackPanel>
                </Border>
            </StackPanel>
        </ScrollViewer>

        <!-- Action Buttons -->
        <Grid Grid.Row="2" Margin="0,0,0,15">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="10"/>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="10"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <Button x:Name="btnRefresh" Grid.Column="0" Content="🔄 Refresh" 
                    Style="{StaticResource RefreshButton}" Height="40"/>
            <Button x:Name="btnCopy" Grid.Column="2" Content="📋 Copy All" 
                    Style="{StaticResource CopyButton}" Height="40"/>
            <Button x:Name="btnClose" Grid.Column="4" Content="✖ Close" 
                    Style="{StaticResource ModernButton}" Height="40"/>
        </Grid>

        <!-- Status Bar -->
        <Border Grid.Row="3" Background="#E9ECEF" CornerRadius="4" Padding="10,8">
            <TextBlock x:Name="txtStatus" Text="Ready" FontSize="12" Foreground="#6C757D"/>
        </Border>
    </Grid>
</Window>
"@

# Load XAML
$reader = [System.Xml.XmlNodeReader]::new($XAML)
$Window = [Windows.Markup.XamlReader]::Load($reader)

# Get UI Elements
$txtHeaderTitle = $Window.FindName("txtHeaderTitle")
$txtHeaderSubtitle = $Window.FindName("txtHeaderSubtitle")

# Section headers
$lblComputerInfoSection = $Window.FindName("lblComputerInfoSection")
$lblOSSection = $Window.FindName("lblOSSection")
$lblSecuritySection = $Window.FindName("lblSecuritySection")
$lblHardwareSection = $Window.FindName("lblHardwareSection")

# Computer Info labels
$lblComputerName = $Window.FindName("lblComputerName")
$lblIPAddress = $Window.FindName("lblIPAddress")
$lblMACAddress = $Window.FindName("lblMACAddress")

# OS labels
$lblOSName = $Window.FindName("lblOSName")
$lblOSVersion = $Window.FindName("lblOSVersion")
$lblOSRelease = $Window.FindName("lblOSRelease")
$lblArchitecture = $Window.FindName("lblArchitecture")
$lblLastBootTime = $Window.FindName("lblLastBootTime")
$lblUptime = $Window.FindName("lblUptime")

# Security labels
$lblAntivirus = $Window.FindName("lblAntivirus")
$lblAntivirusStatus = $Window.FindName("lblAntivirusStatus")
$lblDefinitionStatus = $Window.FindName("lblDefinitionStatus")
$lblSignatureVersion = $Window.FindName("lblSignatureVersion")
$lblSignatureUpdateDate = $Window.FindName("lblSignatureUpdateDate")

# Hardware labels
$lblManufacturer = $Window.FindName("lblManufacturer")
$lblModel = $Window.FindName("lblModel")
$lblSerialNumber = $Window.FindName("lblSerialNumber")
$lblBIOSVersion = $Window.FindName("lblBIOSVersion")
$lblProcessor = $Window.FindName("lblProcessor")
$lblRAM = $Window.FindName("lblRAM")
$lblVideoCard = $Window.FindName("lblVideoCard")
$lblStorage = $Window.FindName("lblStorage")

# Text boxes
$txtComputerName = $Window.FindName("txtComputerName")
$txtIPAddress = $Window.FindName("txtIPAddress")
$txtMACAddress = $Window.FindName("txtMACAddress")
$txtOSName = $Window.FindName("txtOSName")
$txtOSVersion = $Window.FindName("txtOSVersion")
$txtOSRelease = $Window.FindName("txtOSRelease")
$txtArchitecture = $Window.FindName("txtArchitecture")
$txtLastBootTime = $Window.FindName("txtLastBootTime")
$txtUptime = $Window.FindName("txtUptime")
$txtAntivirus = $Window.FindName("txtAntivirus")
$txtAntivirusStatus = $Window.FindName("txtAntivirusStatus")
$txtDefinitionStatus = $Window.FindName("txtDefinitionStatus")
$txtSignatureVersion = $Window.FindName("txtSignatureVersion")
$txtSignatureUpdateDate = $Window.FindName("txtSignatureUpdateDate")
$txtManufacturer = $Window.FindName("txtManufacturer")
$txtModel = $Window.FindName("txtModel")
$txtSerialNumber = $Window.FindName("txtSerialNumber")
$txtBIOSVersion = $Window.FindName("txtBIOSVersion")
$txtProcessor = $Window.FindName("txtProcessor")
$txtRAM = $Window.FindName("txtRAM")
$txtVideoCard = $Window.FindName("txtVideoCard")
$txtStorage = $Window.FindName("txtStorage")
$btnRefresh = $Window.FindName("btnRefresh")
$btnCopy = $Window.FindName("btnCopy")
$btnClose = $Window.FindName("btnClose")
$txtStatus = $Window.FindName("txtStatus")

# Translation dictionary
$translations = @{
    en = @{
        HeaderTitle = "Computer Information"
        HeaderSubtitle = "System and Hardware Details"
        ComputerInfoSection = "Computer Information"
        ComputerName = "Computer Name:"
        IPAddress = "IP Address:"
        MACAddress = "MAC Address:"
        OSSection = "Operating System"
        OSName = "OS Name:"
        OSVersion = "OS Version:"
        OSRelease = "OS Release:"
        Architecture = "Architecture:"
        LastBootTime = "Last Boot Time:"
        Uptime = "Uptime:"
        SecuritySection = "Security"
        Antivirus = "Antivirus Product:"
        AntivirusStatus = "Antivirus Status:"
        DefinitionStatus = "Definition Status:"
        SignatureVersion = "Signature Version:"
        SignatureUpdateDate = "Signature Update Date:"
        HardwareSection = "Hardware"
        Manufacturer = "Manufacturer:"
        Model = "Model:"
        SerialNumber = "Serial Number:"
        BIOSVersion = "BIOS Version:"
        Processor = "Processor:"
        RAM = "RAM:"
        VideoCard = "Video Card:"
        Storage = "Storage:"
        BtnRefresh = "🔄 Refresh"
        BtnCopy = "📋 Copy All"
        BtnClose = "✖ Close"
        StatusReady = "Ready"
        StatusGathering = "Gathering computer information..."
        StatusChecking = "Checking antivirus status..."
        StatusHardware = "Gathering hardware information..."
        StatusSuccess = "Information loaded successfully"
        StatusCopied = "All information copied to clipboard"
        NotAvailable = "Not available"
        NotDetected = "Not detected"
        UnableToDetect = "Unable to detect"
        UnableToRetrieve = "Unable to retrieve"
        Enabled = "Enabled"
        Disabled = "Disabled"
        Unknown = "Unknown"
        UpToDate = "Up to date"
        OutOfDate = "Out of date"
        Used = "Used"
        Free = "Free"
        Days = "days"
        Hours = "hours"
        Minutes = "minutes"
        Cores = "cores"
        LogicalProcessors = "logical processors"
    }
    sv = @{
        HeaderTitle = "Datorinformation"
        HeaderSubtitle = "System- och hårdvarudetaljer"
        ComputerInfoSection = "Datorinformation"
        ComputerName = "Datornamn:"
        IPAddress = "IP-adress:"
        MACAddress = "MAC-adress:"
        OSSection = "Operativsystem"
        OSName = "OS-namn:"
        OSVersion = "OS-version:"
        OSRelease = "OS-utgåva:"
        Architecture = "Arkitektur:"
        LastBootTime = "Senaste uppstart:"
        Uptime = "Drifttid:"
        SecuritySection = "Säkerhet"
        Antivirus = "Antivirusprodukt:"
        AntivirusStatus = "Antivirusstatus:"
        DefinitionStatus = "Definitionsstatus:"
        SignatureVersion = "Signaturversion:"
        SignatureUpdateDate = "Signatur uppdateringsdatum:"
        HardwareSection = "Hårdvara"
        Manufacturer = "Tillverkare:"
        Model = "Modell:"
        SerialNumber = "Serienummer:"
        BIOSVersion = "BIOS-version:"
        Processor = "Processor:"
        RAM = "RAM:"
        VideoCard = "Grafikkort:"
        Storage = "Lagring:"
        BtnRefresh = "🔄 Uppdatera"
        BtnCopy = "📋 Kopiera allt"
        BtnClose = "✖ Stäng"
        StatusReady = "Redo"
        StatusGathering = "Samlar in datorinformation..."
        StatusChecking = "Kontrollerar antivirusstatus..."
        StatusHardware = "Samlar in hårdvaruinformation..."
        StatusSuccess = "Information laddad"
        StatusCopied = "All information kopierad till urklipp"
        NotAvailable = "Inte tillgänglig"
        NotDetected = "Inte detekterad"
        UnableToDetect = "Kan inte detektera"
        UnableToRetrieve = "Kan inte hämta"
        Enabled = "Aktiverad"
        Disabled = "Inaktiverad"
        Unknown = "Okänd"
        UpToDate = "Uppdaterad"
        OutOfDate = "Föråldrad"
        Used = "Använd"
        Free = "Ledig"
        Days = "dagar"
        Hours = "timmar"
        Minutes = "minuter"
        Cores = "kärnor"
        LogicalProcessors = "logiska processorer"
    }
}

# Current language
$script:currentLanguage = "en"

# Function to update UI language
function Update-Language {
    param([string]$lang)
    
    $script:currentLanguage = $lang
    $t = $translations[$lang]
    
    # Header
    $txtHeaderTitle.Text = $t.HeaderTitle
    $txtHeaderSubtitle.Text = $t.HeaderSubtitle
    
    # Section headers
    $lblComputerInfoSection.Text = $t.ComputerInfoSection
    $lblOSSection.Text = $t.OSSection
    $lblSecuritySection.Text = $t.SecuritySection
    $lblHardwareSection.Text = $t.HardwareSection
    
    # Computer Info
    $lblComputerName.Content = $t.ComputerName
    $lblIPAddress.Content = $t.IPAddress
    $lblMACAddress.Content = $t.MACAddress
    
    # OS
    $lblOSName.Content = $t.OSName
    $lblOSVersion.Content = $t.OSVersion
    $lblOSRelease.Content = $t.OSRelease
    $lblArchitecture.Content = $t.Architecture
    $lblLastBootTime.Content = $t.LastBootTime
    $lblUptime.Content = $t.Uptime
    
    # Security
    $lblAntivirus.Content = $t.Antivirus
    $lblAntivirusStatus.Content = $t.AntivirusStatus
    $lblDefinitionStatus.Content = $t.DefinitionStatus
    $lblSignatureVersion.Content = $t.SignatureVersion
    $lblSignatureUpdateDate.Content = $t.SignatureUpdateDate
    
    # Hardware
    $lblManufacturer.Content = $t.Manufacturer
    $lblModel.Content = $t.Model
    $lblSerialNumber.Content = $t.SerialNumber
    $lblBIOSVersion.Content = $t.BIOSVersion
    $lblProcessor.Content = $t.Processor
    $lblRAM.Content = $t.RAM
    $lblVideoCard.Content = $t.VideoCard
    $lblStorage.Content = $t.Storage
    
    # Buttons
    $btnRefresh.Content = $t.BtnRefresh
    $btnCopy.Content = $t.BtnCopy
    $btnClose.Content = $t.BtnClose
    
    # Status
    if ($txtStatus.Text -match "Ready|Redo") {
        $txtStatus.Text = $t.StatusReady
    }
}

# Function to update status
function Update-Status {
    param([string]$MessageKey)
    $t = $translations[$script:currentLanguage]
    $message = switch ($MessageKey) {
        "Gathering" { $t.StatusGathering }
        "Checking" { $t.StatusChecking }
        "Hardware" { $t.StatusHardware }
        "Success" { $t.StatusSuccess }
        "Copied" { $t.StatusCopied }
        "Ready" { $t.StatusReady }
        default { $MessageKey }
    }
    $txtStatus.Text = $message
    $txtStatus.Dispatcher.Invoke([Action]{}, [Windows.Threading.DispatcherPriority]::Background)
}

# Function to get computer information
function Get-ComputerInfo {
    try {
        $t = $translations[$script:currentLanguage]
        Update-Status "Gathering"
        
        # Computer Name
        $txtComputerName.Text = $env:COMPUTERNAME
        
        # IP Address and MAC Address
        $networkAdapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and $_.Name -notlike "*Bluetooth*" -and $_.Name -notlike "*Virtual*" } | Select-Object -First 1
        if ($networkAdapter) {
            $ipAddress = (Get-NetIPAddress -InterfaceIndex $networkAdapter.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue).IPAddress
            $txtIPAddress.Text = if ($ipAddress) { $ipAddress } else { $t.NotAvailable }
            $txtMACAddress.Text = $networkAdapter.MacAddress
        } else {
            $txtIPAddress.Text = $t.NotAvailable
            $txtMACAddress.Text = $t.NotAvailable
        }
        
        # Operating System Information
        $os = Get-CimInstance -ClassName Win32_OperatingSystem
        $txtOSName.Text = $os.Caption
        $txtOSVersion.Text = $os.Version
        
        # Get OS Release (24H2, 25H2, etc.) from registry
        try {
            $osRelease = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name DisplayVersion -ErrorAction SilentlyContinue).DisplayVersion
            if (-not $osRelease) {
                $osRelease = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ReleaseId -ErrorAction SilentlyContinue).ReleaseId
            }
            $txtOSRelease.Text = if ($osRelease) { $osRelease } else { $t.NotAvailable }
        } catch {
            $txtOSRelease.Text = $t.NotAvailable
        }
        
        $txtArchitecture.Text = $os.OSArchitecture
        
        # Last Boot Time and Uptime
        $lastBootTime = $os.LastBootUpTime
        $txtLastBootTime.Text = $lastBootTime.ToString("yyyy-MM-dd HH:mm:ss")
        
        $uptime = (Get-Date) - $lastBootTime
        $uptimeString = ""
        if ($uptime.Days -gt 0) {
            $uptimeString += "$($uptime.Days) $($t.Days), "
        }
        $uptimeString += "$($uptime.Hours) $($t.Hours), $($uptime.Minutes) $($t.Minutes)"
        $txtUptime.Text = $uptimeString
        
        # Antivirus Information
        Update-Status "Checking"
        try {
            $antivirus = Get-CimInstance -Namespace "root\SecurityCenter2" -ClassName AntiVirusProduct -ErrorAction SilentlyContinue
            if ($antivirus) {
                $av = $antivirus | Select-Object -First 1
                $txtAntivirus.Text = $av.displayName
                
                # Decode the product state
                $hexString = [System.Convert]::ToString($av.productState, 16).PadLeft(6, '0')
                $provider = $hexString.Substring(0, 2)
                $realTimeProtection = $hexString.Substring(2, 2)
                $definition = $hexString.Substring(4, 2)
                
                # Real-time protection status
                $rtpStatus = switch ($realTimeProtection) {
                    "10" { $t.Enabled }
                    "00" { $t.Disabled }
                    "01" { $t.Disabled }
                    default { $t.Unknown }
                }
                $txtAntivirusStatus.Text = $rtpStatus
                
                # Definition status
                $defStatus = switch ($definition) {
                    "00" { $t.UpToDate }
                    "10" { $t.OutOfDate }
                    default { $t.Unknown }
                }
                $txtDefinitionStatus.Text = $defStatus
                
                # Check if it's Windows Defender and get signature information
                if ($av.displayName -match "Windows Defender|Microsoft Defender") {
                    try {
                        $defenderStatus = Get-MpComputerStatus -ErrorAction SilentlyContinue
                        if ($defenderStatus) {
                            $txtSignatureVersion.Text = $defenderStatus.AntivirusSignatureVersion
                            $txtSignatureUpdateDate.Text = $defenderStatus.AntivirusSignatureLastUpdated.ToString("yyyy-MM-dd HH:mm:ss")
                        } else {
                            $txtSignatureVersion.Text = $t.NotAvailable
                            $txtSignatureUpdateDate.Text = $t.NotAvailable
                        }
                    } catch {
                        $txtSignatureVersion.Text = $t.UnableToRetrieve
                        $txtSignatureUpdateDate.Text = $t.UnableToRetrieve
                    }
                } else {
                    $txtSignatureVersion.Text = "$($t.NotAvailable) (Not Windows Defender)"
                    $txtSignatureUpdateDate.Text = "$($t.NotAvailable) (Not Windows Defender)"
                }
            } else {
                $txtAntivirus.Text = $t.NotDetected
                $txtAntivirusStatus.Text = $t.NotAvailable
                $txtDefinitionStatus.Text = $t.NotAvailable
                $txtSignatureVersion.Text = $t.NotAvailable
                $txtSignatureUpdateDate.Text = $t.NotAvailable
            }
        } catch {
            $txtAntivirus.Text = $t.UnableToDetect
            $txtAntivirusStatus.Text = $t.NotAvailable
            $txtDefinitionStatus.Text = $t.NotAvailable
            $txtSignatureVersion.Text = $t.NotAvailable
            $txtSignatureUpdateDate.Text = $t.NotAvailable
        }
        
        # Hardware Information
        Update-Status "Hardware"
        $computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
        $txtManufacturer.Text = $computerSystem.Manufacturer
        $txtModel.Text = $computerSystem.Model
        
        # Serial Number and BIOS Version
        $bios = Get-CimInstance -ClassName Win32_BIOS
        $txtSerialNumber.Text = $bios.SerialNumber
        $txtBIOSVersion.Text = "$($bios.Manufacturer) $($bios.SMBIOSBIOSVersion)"
        
        # Processor
        $processor = Get-CimInstance -ClassName Win32_Processor
        $txtProcessor.Text = "$($processor.Name) ($($processor.NumberOfCores) $($t.Cores), $($processor.NumberOfLogicalProcessors) $($t.LogicalProcessors))"
        
        # RAM
        $totalRAM = [math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)
        $freeRAM = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
        $usedRAM = [math]::Round($totalRAM - $freeRAM, 2)
        $txtRAM.Text = "$totalRAM GB ($($t.Used): $usedRAM GB, $($t.Free): $freeRAM GB)"
        
        # Video Card
        $videoCard = Get-CimInstance -ClassName Win32_VideoController | Where-Object { $_.Name -notlike "*Remote*" -and $_.Name -notlike "*Basic*" } | Select-Object -First 1
        if ($videoCard) {
            $vramGB = [math]::Round($videoCard.AdapterRAM / 1GB, 2)
            if ($vramGB -gt 0) {
                $txtVideoCard.Text = "$($videoCard.Name) ($vramGB GB)"
            } else {
                $txtVideoCard.Text = $videoCard.Name
            }
        } else {
            $txtVideoCard.Text = $t.NotDetected
        }
        
        # Storage
        $drives = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"
        $storageInfo = foreach ($drive in $drives) {
            $size = [math]::Round($drive.Size / 1GB, 2)
            $free = [math]::Round($drive.FreeSpace / 1GB, 2)
            "$($drive.DeviceID) $size GB ($($t.Free): $free GB)"
        }
        $txtStorage.Text = $storageInfo -join " | "
        
        Update-Status "Success"
    } catch {
        Update-Status "Error: $($_.Exception.Message)"
        [System.Windows.MessageBox]::Show("Error gathering information: $($_.Exception.Message)", "Error", "OK", "Error")
    }
}

# Refresh Button Click Event
$btnRefresh.Add_Click({
    Get-ComputerInfo
})

# Copy Button Click Event
$btnCopy.Add_Click({
    try {
        $report = @"
=== COMPUTER INFORMATION ===

Computer Name: $($txtComputerName.Text)
IP Address: $($txtIPAddress.Text)
MAC Address: $($txtMACAddress.Text)

=== OPERATING SYSTEM ===

OS Name: $($txtOSName.Text)
OS Version: $($txtOSVersion.Text)
OS Release: $($txtOSRelease.Text)
Architecture: $($txtArchitecture.Text)
Last Boot Time: $($txtLastBootTime.Text)
Uptime: $($txtUptime.Text)

=== SECURITY ===

Antivirus Product: $($txtAntivirus.Text)
Antivirus Status: $($txtAntivirusStatus.Text)
Definition Status: $($txtDefinitionStatus.Text)
Signature Version: $($txtSignatureVersion.Text)
Signature Update Date: $($txtSignatureUpdateDate.Text)

=== HARDWARE ===

Manufacturer: $($txtManufacturer.Text)
Model: $($txtModel.Text)
Serial Number: $($txtSerialNumber.Text)
BIOS Version: $($txtBIOSVersion.Text)
Processor: $($txtProcessor.Text)
RAM: $($txtRAM.Text)
Video Card: $($txtVideoCard.Text)
Storage: $($txtStorage.Text)

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@
        
        [System.Windows.Clipboard]::SetText($report)
        Update-Status "Copied"
    } catch {
        Update-Status "Error copying to clipboard"
        [System.Windows.MessageBox]::Show("Error copying to clipboard: $($_.Exception.Message)", "Error", "OK", "Error")
    }
})

# Close Button Click Event
$btnClose.Add_Click({
    $Window.Close()
})

# Initialize language (can be changed to 'sv' for Swedish)
Update-Language "sv"

# Load information on startup
Get-ComputerInfo

# Show Window
$Window.ShowDialog() | Out-Null
