@echo off
rem Win11 script
set "scriptver=1.0"
title %~nx0  v%scriptver%

rem This first for routine will give the current path without a trailing \
%~d0
cd "%~dp0"
cd %~dps0
for %%f in ("%CD%") do set CP=%%~sf

rem User Set Variables:
set /p ProjectName=<%CP%\Settings\ProjectName.txt
set /p Arch=<%CP%\Settings\Arch.txt
set /p WinVersion=<%CP%\Settings\WinVersion.txt
set /p VMName=<%CP%\Settings\VMName.txt
set /p VMPath=<%CP%\Settings\VMPath.txt
set /p MountISO=<%CP%\Settings\MountISO.txt
set /p VHDSize=<%CP%\Settings\VHDSize.txt
set /p VirtMem=<%CP%\Settings\VirtMem.txt
set /p VHDFile=<%CP%\Settings\VHDFile.txt
set /p VirtDrive=<%CP%\Settings\VirtDrive.txt
set /p WIMName=<%CP%\Settings\WIMName.txt
set /p ESDName=<%CP%\Settings\ESDName.txt
set /p WindowsOriginalPath=<%CP%\Settings\WindowsOriginalPath.txt
set /p SysPrepISOPath=<%CP%\Settings\SysPrepISOPath.txt
set /p NTLiteISOPath=<%CP%\Settings\NTLiteISOPath.txt


rem System Set Variables:
for %%f in ("C:\Program Files\Oracle\VirtualBox") do set VBP=%%~sf
set VBM=%VBP%\VBoxManage.exe
set VMP=%CP%\%VMPath%
set ToolsPath=%CP%\Tools
set WinBuilderPath=%CP%\03_WinBuilder

echo *** Project %ProjectName% ***
echo All Folders Are Short Folder Names:
echo.
echo   Script version: v%scriptver%
echo     Current (CP): %CP%
echo VirtualBox (VBP): %VBP%
echo    Virtual Drive: %VirtDrive%
echo.
rem pause

rem Delete Extracted ISO's and any Builder Processes you have done
echo rd /s "%CP%\%WindowsOriginalPath%"
rd /s /q "%CP%\%WindowsOriginalPath%"

echo rd /s "%CP%\%SysPrepISOPath%"
rd /s /q "%CP%\%SysPrepISOPath%"

echo rd /s "%CP%\%NTLiteISOPath%"
rd /s /q "%CP%\%NTLiteISOPath%"

rd /s /q "%CP%\Temp"

rem Cleanup SysPrep
del /q "%CP%\01_Syspreping\01Update_CleanVM.iso"


rem Cleanup Winbuilder
rd /q /s "%WinBuilderPath%\ISO"
rd /q /s "%WinBuilderPath%\Target"
rd /q /s "%WinBuilderPath%\ProgCache"
rd /q /s "%WinBuilderPath%\Temp"

del /q "%WinBuilderPath%\Win10XPE_x64.iso"
del /q "%WinBuilderPath%\%ProjectName%.iso"

del /q "%CP%\03_WinBuilder\Custom\x64\IsoRoot\sources\%WIMName%"
del /q "%CP%\03_WinBuilder\Custom\x64\IsoRoot\sources\%ESDName%"

pause