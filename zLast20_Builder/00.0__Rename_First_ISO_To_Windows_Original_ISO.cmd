@echo off
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

rem *******
rem added in VirtualBox file check to ensure that 
rem VirtualBox exists before proceeding

setlocal enableextensions

rem if not defined VBM goto :eof
if not exist "%VBM%" goto :notexistvbm
rem *******   
rem check version of VirtualBox

set "vers="
FOR /F "tokens=2 delims==" %%a in ('
        wmic datafile where name^="%VBM:\=\\%" get Version /value 
    ') do set "vers=%%a"
    
set "light="
set "minver=7.0.0.0"
rem echo(%VBM%=%vers%
rem current version installed = 7.0.2.4219
  
rem echo(Version=%vers% 
rem ******* 
rem Version 7 of vbox is required for TPM 2.0 used by Win11 install
rem if Version is less then 7 (minver) then display error message
IF %vers% LSS %minver%  (echo Windows 11 secure guest support is available starting from version 7.0 release)  ELSE (echo Good to go)
rem IF %vers% LSS %minver% (set "light=red") ELSE (set "light=green")
rem echo %light% 

goto :projectstart

:notexistvbm
echo( ***** File not found: Virtual box is not installed use Virtual box version 7.0 or later release)
 exit /b
 
endlocal
rem pause
    
:projectstart 


echo *** Project %ProjectName% ***
echo All Folders Are Short Folder Names:
echo.
rem added script version
echo   Script version: v%scriptver%
echo     Current (CP): %CP%
echo VirtualBox (VBP): %VBP%
echo    Virtual Drive: %VirtDrive%
echo.

rem this checks if user wants to use the %MountISO% filename
:choice
set /P c=Are you sure you want to continue with using %MountISO% filename[Y/N]?
if /I "%c%" EQU "Y" goto :somewhere
if /I "%c%" EQU "N" goto :somewhere_else
goto :choice


:somewhere

rem echo "I am here because you typed Y"
echo you are now using %MountISO% filename
rem pause
goto :run
rem exit

:somewhere_else

rem echo "I am here because you typed N"
echo exiting program
rem pause
exit /B

:run
rem pause

rem Rename first found 00_Source\*.ISO to use as Windows Original source ISO
cd /D "%CP%\00_Source"
for /f "tokens=* delims=" %%x in ('dir "*.iso" /B /O:N') do ren "%CP%\00_Source\%%x" "%MountISO%" & goto DONE

:DONE