<#
.SYNOPSIS
    Modern WPF-based MSI Application Information Tool

.DESCRIPTION
    A professional Windows Presentation Foundation (WPF) application for extracting 
    metadata from MSI (Windows Installer) files including ProductName, ProductVersion, 
    ProductCode, Manufacturer, and more.

.NOTES
    NAME:       MSI Application Information Tool (WPF)
    AUTHOR:     Fredrik Wall, wall.fredrik@gmail.com
    BLOG:       www.poweradmin.se
    TWITTER:    @walle75
    CREATED:    2020-12-05
    UPDATED:    2025-12-27
    VERSION:    2.0 (WPF Edition)

                2.0 - Complete WPF redesign with modern UI
                1.4 - Improved error handling and UI responsiveness
                1.3 - Added Copy to Clipboard functionality
                1.2 - Enhanced UI with styles and themes
                1.1 - Initial version with basic functionality
#>

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# XAML Definition for Modern UI
[xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="MSI Application Information Tool" 
        Height="830" Width="750"
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

        <!-- Browse Button Style -->
        <Style x:Key="BrowseButton" TargetType="Button" BasedOn="{StaticResource ModernButton}">
            <Setter Property="Background" Value="#28A745"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#218838"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <!-- Clear Button Style -->
        <Style x:Key="ClearButton" TargetType="Button" BasedOn="{StaticResource ModernButton}">
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
            <Style.Triggers>
                <Trigger Property="IsFocused" Value="True">
                    <Setter Property="BorderBrush" Value="#0078D4"/>
                    <Setter Property="BorderThickness" Value="2"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <!-- GroupBox Style -->
        <Style TargetType="GroupBox">
            <Setter Property="Margin" Value="0,0,0,15"/>
            <Setter Property="Padding" Value="10"/>
            <Setter Property="BorderBrush" Value="#CED4DA"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Background" Value="White"/>
        </Style>

        <!-- Label Style -->
        <Style TargetType="Label">
            <Setter Property="FontSize" Value="13"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Foreground" Value="#212529"/>
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
        <Border Grid.Row="0" Background="#0078D4" CornerRadius="6" Padding="15,10" Margin="0,0,0,20">
            <StackPanel>
                <TextBlock Text="MSI Application Information Tool" 
                          FontSize="20" 
                          FontWeight="Bold" 
                          Foreground="White"/>
                <TextBlock Text="Extract metadata from Windows Installer packages" 
                          FontSize="12" 
                          Foreground="#E3F2FD" 
                          Margin="0,5,0,0"/>
            </StackPanel>
        </Border>

        <!-- Main Content -->
        <StackPanel Grid.Row="1">
            <!-- File Selection -->
            <GroupBox Header="Select MSI File">
                <Grid>
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="*"/>
                        <ColumnDefinition Width="Auto"/>
                    </Grid.ColumnDefinitions>
                    
                    <TextBox x:Name="txtFilePath" 
                            Grid.Column="0"
                            Style="{StaticResource ModernTextBox}"
                            IsReadOnly="True"
                            ToolTip="Path to the MSI file"/>
                    
                    <Button x:Name="btnBrowse" 
                           Grid.Column="1"
                           Content="Browse..."
                           Style="{StaticResource BrowseButton}"
                           Margin="10,0,0,0"
                           Width="100"/>
                </Grid>
            </GroupBox>

            <!-- Results Section -->
            <GroupBox Header="MSI Package Information">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>
                    
                    <Label Grid.Row="0" Content="Product Name:" Margin="0,5"/>
                    <TextBox x:Name="txtProductName" 
                            Grid.Row="1"
                            Style="{StaticResource ModernTextBox}"
                            IsReadOnly="True"
                            Margin="0,0,0,10"/>

                    <Label Grid.Row="2" Content="Product Version:" Margin="0,5"/>
                    <TextBox x:Name="txtProductVersion" 
                            Grid.Row="3"
                            Style="{StaticResource ModernTextBox}"
                            IsReadOnly="True"
                            Margin="0,0,0,10"/>

                    <Label Grid.Row="4" Content="Manufacturer:" Margin="0,5"/>
                    <TextBox x:Name="txtManufacturer" 
                            Grid.Row="5"
                            Style="{StaticResource ModernTextBox}"
                            IsReadOnly="True"
                            Margin="0,0,0,10"/>

                    <Label Grid.Row="6" Content="Product Code:" Margin="0,5"/>
                    <TextBox x:Name="txtProductCode" 
                            Grid.Row="7"
                            Style="{StaticResource ModernTextBox}"
                            IsReadOnly="True"
                            Margin="0,0,0,10"/>

                    <Label Grid.Row="8" Content="Product Language:" Margin="0,5"/>
                    <TextBox x:Name="txtProductLanguage" 
                            Grid.Row="9"
                            Style="{StaticResource ModernTextBox}"
                            IsReadOnly="True"/>
                </Grid>
            </GroupBox>
        </StackPanel>

        <!-- Action Buttons -->
        <Grid Grid.Row="2" Margin="0,15,0,0">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="Auto"/>
            </Grid.ColumnDefinitions>

            <Button x:Name="btnGet" 
                   Grid.Column="1"
                   Content="Get Information"
                   Style="{StaticResource ModernButton}"
                   Width="150"
                   Margin="0,0,10,0"/>
            
            <Button x:Name="btnCopy" 
                   Grid.Column="2"
                   Content="Copy to Clipboard"
                   Style="{StaticResource ModernButton}"
                   Width="150"
                   Margin="0,0,10,0"/>

            <Button x:Name="btnClear" 
                   Grid.Column="3"
                   Content="Clear"
                   Style="{StaticResource ClearButton}"
                   Width="100"
                   Margin="0,0,10,0"/>
        </Grid>

        <!-- Status Bar -->
        <Border Grid.Row="3" 
                Background="#212529" 
                CornerRadius="4" 
                Padding="10,8" 
                Margin="0,15,0,0">
            <TextBlock x:Name="txtStatus" 
                      Text="Ready" 
                      Foreground="White"
                      FontSize="12"/>
        </Border>
    </Grid>
</Window>
"@

# Function to extract MSI information (from Applications folder)
function Get-MSIAppInformation {
	<#
	.SYNOPSIS
		Retrieve properties from an MSI file.

	.DESCRIPTION
		Opens an MSI database and reads properties from the Property table.
		Returns PSCustomObject(s) with `Property` and `Value`.

	.PARAMETER FilePath
		Path to the MSI file. Accepts pipeline input as a string or a
		FileInfo object.

	.PARAMETER Property
		Optional. One or more MSI property names to retrieve (e.g. ProductName,
		ProductVersion, ProductCode). When omitted all properties are streamed.

	.NOTES
		NAME:    Get-MSIAppInformation
        AUTHOR:  Fredrik Wall, wall.fredrik@gmail.com
        VERSION: 1.4
        CREATED: 2014-12-05
		UPDATED: 2025-12-03
	#>

	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('Path')]
		[ValidateNotNullOrEmpty()]
		[object]$FilePath,

		[Parameter(Mandatory = $false)]
		[string[]]
		$Property
	)

    process {
        $installer = $null
        $database = $null
        $view = $null
        $record = $null
        try {
            if ($FilePath -is [System.IO.FileInfo]) {
                $msi = $FilePath
            }
            else {
                $msi = Get-Item -LiteralPath $FilePath -ErrorAction Stop
            }

            $installer = New-Object -ComObject WindowsInstaller.Installer
            $database = $installer.OpenDatabase($msi.FullName, 0)

            $view = $database.OpenView('SELECT `Property`, `Value` FROM `Property`')
            $view.Execute()

            $map = @{}
            while ($null -ne ($record = $view.Fetch())) {
                $name = $record.StringData(1)
                $val  = $record.StringData(2)
                if ($null -ne $name) { $map[$name] = $val }
            }

            if ($Property -and $Property.Count -gt 1) {
                # Aggregated object
                $obj = [ordered]@{}
                foreach ($p in $Property) {
                    if ($map.ContainsKey($p)) { $obj[$p] = $map[$p] } else { $obj[$p] = $null; Write-Verbose "Property '$p' not found in '$($msi.FullName)'" }
                }
                [PSCustomObject]$obj
            }
            elseif ($Property -and $Property.Count -eq 1) {
                $p = $Property[0]
                if ($map.ContainsKey($p)) {
                    [PSCustomObject]@{ Property = $p; Value = $map[$p] }
                }
                else {
                    Write-Verbose "Property '$p' not found in '$($msi.FullName)'"
                    return $null
                }
            }
            else {
                # Stream all properties
                foreach ($k in $map.Keys) {
                    [PSCustomObject]@{ Property = $k; Value = $map[$k] }
                }
            }
        }
        catch {
            Write-Error "Failed to get MSI information for '$FilePath': $($_.Exception.Message)"
        }
        finally {
            foreach ($obj in @($record, $view, $database, $installer) | Where-Object { $_ -ne $null }) {
                try { [System.Runtime.InteropServices.Marshal]::ReleaseComObject($obj) | Out-Null } catch {}
            }
            [GC]::Collect(); [GC]::WaitForPendingFinalizers()
        }
    }
}

# Load XAML
$reader = New-Object System.Xml.XmlNodeReader $XAML
$Window = [Windows.Markup.XamlReader]::Load($reader)

# Get controls
$txtFilePath = $Window.FindName('txtFilePath')
$txtProductName = $Window.FindName('txtProductName')
$txtProductVersion = $Window.FindName('txtProductVersion')
$txtManufacturer = $Window.FindName('txtManufacturer')
$txtProductCode = $Window.FindName('txtProductCode')
$txtProductLanguage = $Window.FindName('txtProductLanguage')
$btnBrowse = $Window.FindName('btnBrowse')
$btnGet = $Window.FindName('btnGet')
$btnCopy = $Window.FindName('btnCopy')
$btnClear = $Window.FindName('btnClear')
$txtStatus = $Window.FindName('txtStatus')

# Browse Button Click Event
$btnBrowse.Add_Click({
    $openFileDialog = New-Object Microsoft.Win32.OpenFileDialog
    $openFileDialog.Filter = "Windows Installer files (*.msi)|*.msi|All files (*.*)|*.*"
    $openFileDialog.Title = "Select MSI File"
    $openFileDialog.InitialDirectory = [Environment]::GetFolderPath('Desktop')
    
    if ($openFileDialog.ShowDialog()) {
        $txtFilePath.Text = $openFileDialog.FileName
        $txtStatus.Text = "File selected: $($openFileDialog.SafeFileName)"
        
        # Auto-populate information when file is selected
        $btnGet.RaiseEvent((New-Object System.Windows.RoutedEventArgs([System.Windows.Controls.Button]::ClickEvent)))
    }
})

# Get Information Button Click Event
$btnGet.Add_Click({
    if ([string]::IsNullOrWhiteSpace($txtFilePath.Text)) {
        [System.Windows.MessageBox]::Show(
            'Please select an MSI file first.',
            'No File Selected',
            'OK',
            'Warning'
        )
        $txtStatus.Text = "Error: No file selected"
        return
    }
    
    if (-not (Test-Path $txtFilePath.Text)) {
        [System.Windows.MessageBox]::Show(
            'The selected file does not exist.',
            'File Not Found',
            'OK',
            'Error'
        )
        $txtStatus.Text = "Error: File not found"
        return
    }
    
    try {
        $txtStatus.Text = "Extracting information from MSI package..."
        $Window.Cursor = [System.Windows.Input.Cursors]::Wait
        
        # Get MSI information for common properties
        $properties = @('ProductName', 'ProductVersion', 'Manufacturer', 'ProductCode', 'ProductLanguage')
        $msiInfo = Get-MSIAppInformation -FilePath $txtFilePath.Text -Property $properties
        
        $txtProductName.Text = if ($msiInfo.ProductName) { $msiInfo.ProductName } else { "N/A" }
        $txtProductVersion.Text = if ($msiInfo.ProductVersion) { $msiInfo.ProductVersion } else { "N/A" }
        $txtManufacturer.Text = if ($msiInfo.Manufacturer) { $msiInfo.Manufacturer } else { "N/A" }
        $txtProductCode.Text = if ($msiInfo.ProductCode) { $msiInfo.ProductCode } else { "N/A" }
        $txtProductLanguage.Text = if ($msiInfo.ProductLanguage) { $msiInfo.ProductLanguage } else { "N/A" }
        
        $txtStatus.Text = "Information extracted successfully"
        $Window.Cursor = [System.Windows.Input.Cursors]::Arrow
    }
    catch {
        [System.Windows.MessageBox]::Show(
            "Failed to extract information from the MSI file.`n`nError: $_",
            'Error',
            'OK',
            'Error'
        )
        $txtStatus.Text = "Error: Failed to extract information"
        $Window.Cursor = [System.Windows.Input.Cursors]::Arrow
    }
})

# Copy to Clipboard Button Click Event
$btnCopy.Add_Click({
    if ([string]::IsNullOrWhiteSpace($txtProductName.Text) -or $txtProductName.Text -eq "N/A") {
        [System.Windows.MessageBox]::Show(
            'No information available to copy. Please get information first.',
            'No Data',
            'OK',
            'Information'
        )
        return
    }
    
    try {
        $clipboardText = @"
MSI Application Information
============================
File Path:         $($txtFilePath.Text)
Product Name:      $($txtProductName.Text)
Product Version:   $($txtProductVersion.Text)
Manufacturer:      $($txtManufacturer.Text)
Product Code:      $($txtProductCode.Text)
Product Language:  $($txtProductLanguage.Text)
============================
Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
"@
        
        [System.Windows.Clipboard]::SetText($clipboardText)
        $txtStatus.Text = "Information copied to clipboard"
        
        [System.Windows.MessageBox]::Show(
            'MSI information has been copied to the clipboard.',
            'Copied',
            'OK',
            'Information'
        )
    }
    catch {
        [System.Windows.MessageBox]::Show(
            "Failed to copy to clipboard.`n`nError: $_",
            'Error',
            'OK',
            'Error'
        )
        $txtStatus.Text = "Error: Failed to copy to clipboard"
    }
})

# Clear Button Click Event
$btnClear.Add_Click({
    $txtFilePath.Clear()
    $txtProductName.Clear()
    $txtProductVersion.Clear()
    $txtManufacturer.Clear()
    $txtProductCode.Clear()
    $txtProductLanguage.Clear()
    $txtStatus.Text = "Ready"
})

# Keyboard shortcuts
$Window.Add_KeyDown({
    param($sender, $e)
    
    # Ctrl+O to browse
    if ($e.Key -eq 'O' -and $e.KeyboardDevice.Modifiers -eq 'Control') {
        $btnBrowse.RaiseEvent((New-Object System.Windows.RoutedEventArgs([System.Windows.Controls.Button]::ClickEvent)))
        $e.Handled = $true
    }
    
    # Ctrl+G to get information
    if ($e.Key -eq 'G' -and $e.KeyboardDevice.Modifiers -eq 'Control') {
        $btnGet.RaiseEvent((New-Object System.Windows.RoutedEventArgs([System.Windows.Controls.Button]::ClickEvent)))
        $e.Handled = $true
    }
    
    # Ctrl+C to copy (when not in a textbox)
    if ($e.Key -eq 'C' -and $e.KeyboardDevice.Modifiers -eq 'Control' -and 
        $Window.FocusManager.FocusedElement -isnot [System.Windows.Controls.TextBox]) {
        $btnCopy.RaiseEvent((New-Object System.Windows.RoutedEventArgs([System.Windows.Controls.Button]::ClickEvent)))
        $e.Handled = $true
    }
    
    # Escape to clear
    if ($e.Key -eq 'Escape') {
        $btnClear.RaiseEvent((New-Object System.Windows.RoutedEventArgs([System.Windows.Controls.Button]::ClickEvent)))
        $e.Handled = $true
    }
})

# Set initial status
$txtStatus.Text = "v2.0 WPF Edition - By Fredrik Wall (www.poweradmin.se) | Shortcuts: Ctrl+O=Browse, Ctrl+G=Get Info, Esc=Clear"

# Show the window
$Window.ShowDialog() | Out-Null
