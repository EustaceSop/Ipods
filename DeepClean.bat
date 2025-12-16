@echo off

taskkill /f /im epicgameslauncher.exe > nul
taskkill /f /im EpicWebHelper.exe > nul
taskkill /f /im FortniteClient-Win64-Shipping_EAC.exe > nul
taskkill /f /im FortniteClient-Win64-Shipping_BE.exe > nul
taskkill /f /im FortniteLauncher.exe > nul
taskkill /f /im FortniteClient-Win64-Shipping.exe > nul
taskkill /f /im EpicGamesLauncher.exe > nul
taskkill /f /im EasyAntiCheat.exe > nul
taskkill /f /im BEService.exe > nul
taskkill /f /im BEServices.exe > nul
taskkill /f /im BattleEye.exe > nul

reg delete "HKLM\SYSTEM\ControlSet001\Services\EpicOnlineServices" /f
reg delete "HKCU\SOFTWARE\Epic Games" /f
reg delete "HKLM\SOFTWARE\Classes\com.epicgames.launcher" /f
reg delete "HKLM\SYSTEM\ControlSet001\Services\BEService" /f
reg delete "HKLM\SYSTEM\ControlSet001\Services\BEDaisy" /f
reg delete "HKLM\SYSTEM\ControlSet001\Services\EasyAntiCheat" /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\BEService" /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\BEDaisy" /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\EasyAntiCheat" /f
reg delete "HKLM\SOFTWARE\WOW6432Node\EasyAntiCheat" /f
reg delete "HKLM\SOFTWARE\WOW6432Node\Epic Games" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone\NonPackaged" /f
reg delete "HKLM\SOFTWARE\Microsoft\RADAR\HeapLeakDetection\DiagnosedApplications" /f
reg delete "HKCU\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\com.epicgames.launcher" /f
reg delete "HKCR\com.epicgames.eos" /f
reg delete "HKLM\SOFTWARE\Microsoft\RADAR\HeapLeakDetection\DiagnosedApplications" /f
reg delete "HKLM\SOFTWARE\EpicGames" /f
reg delete "HKEY_USERS\S-1-5-18\Software\Epic Games" /f

netsh advfirewall reset

RMDIR /S /Q "%systemdrive%\Users\%username%\AppData\Local\EpicGamesLauncher"
RMDIR /S /Q "%systemdrive%\Users\%username%\AppData\Local\FortniteGame"
RMDIR /S /Q "%systemdrive%\Users\%username%\AppData\Local\Epic Games"
RMDIR /S /Q "%systemdrive%\Users\%username%\AppData\Local\NVIDIA Corporation"
RMDIR /S /Q "%systemdrive%\Users\%username%\AppData\Roaming\EasyAntiCheat"
RMDIR /S /Q "%systemdrive%\Users\All Users\Epic\EpicGamesLauncher\Data\EMS\current"
RMDIR /S /Q "%systemdrive%\Users\%username%\AppData\Local\UnrealEngine"
RMDIR /S /Q "%systemdrive%\Users\%username%\AppData\Local\UnrealEngineLauncher"
RMDIR /S /Q "%systemdrive%\ProgramData\Epic\EpicOnlineServices"
RMDIR /S /Q "%systemdrive%\ProgramData\Epic\EpicGamesLauncher\Data\EMS\current"
RMDIR /S /Q "%systemdrive%\Program Files (x86)\Epic Games\Epic Online Services\service"
RMDIR /S /Q "%systemdrive%\Program Files\Epic Games\Fortnite\FortniteGame\Binaries\Win64\Shared Files"
RMDIR /S /Q "%systemdrive%\Program Files (x86)\Common Files\BattlEye"
RMDIR /S /Q "%systemdrive%\Program Files (x86)\EasyAntiCheat"
RMDIR /S /Q "%systemdrive%\$Recycle.bin"
del /q "C:\ProgramData\Microsoft\Windows\WER\Temp\"
for /d %%x in (C:\ProgramData\Microsoft\Windows\WER\Temp\*) do @rd /s /q "%%x"

del /q "C:\Users\%username%\AppData\Local\Temp\"
for /d %%x in (C:\Users\%username%\AppData\Local\Temp\*) do @rd /s /q "%%x"

del /q C:\Windows\Temp\*
for /d %%x in (C:\Windows\Temp\*) do @rd /s /q "%%x"

del /q "C:\Windows\TEMP\"
for /d %%x in (C:\Windows\TEMP\*) do @rd /s /q "%%x"

del /q "C:\Windows\temp\"
for /d %%x in (C:\Windows\temp\*) do @rd /s /q "%%x"

del /q "C:\Program Files (x86)\Temp\"
for /d %%x in (C:\Program Files (x86)\Temp\*) do @rd /s /q "%%x"

del /q "C:\Windows\Logs\"
for /d %%x in (C:\Windows\Logs\*) do @rd /s /q "%%x"

del /q "C:\Users\%username%\AppData\Local\D3DSCache\"
for /d %%x in (C:\Users\%username%\AppData\Local\D3DSCache\*) do @rd /s /q "%%x"

del /q "C:\Users\%username%\AppData\Local\CrashReportClient\"
for /d %%x in (C:\Users\%username%\AppData\Local\CrashReportClient\*) do @rd /s /q "%%x"

del /q "C:\Windows\Prefetch\"
for /d %%x in (C:\Windows\Prefetch\*) do @rd /s /q "%%x"

del /q "C:\Users\%username%\Recent\"
for /d %%x in (C:\Users\%username%\Recent\*) do @rd /s /q "%%x"

del /q "C:\Users\%username%\AppData\Local\AMD\"
for /d %%x in (C:\Users\%username%\AppData\Local\AMD\*) do @rd /s /q "%%x"

del /q "C:\Users\%username%\AppData\Local\AMD_Common\"
for /d %%x in (C:\Users\%username%\AppData\Local\AMD_Common\*) do @rd /s /q "%%x"

del /q C:\Users\%username%\AppData\Local\Microsoft\Feeds\"
for /d %%x in (C:\Users\%username%\AppData\Local\Microsoft\Feeds\*) do @rd /s /q "%%x"


exit