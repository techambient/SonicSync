@echo off
title Setup Script
echo Starting setup...

:: Define source and destination paths
set "DEST_DIR=C:\p2p"
set "DESKTOP_DIR=%USERPROFILE%\Desktop"

:: 1. Check if C:\p2p exists, if not, create it
if not exist "%DEST_DIR%" (
    echo Creating directory %DEST_DIR%...
    mkdir "%DEST_DIR%"
)

:: 2. Copy the specified files from the current folder to C:\p2p
echo Copying application files...
copy "%~dp0icon.ico" "%DEST_DIR%\" /Y
copy "%~dp0index.html" "%DEST_DIR%\" /Y
copy "%~dp0launch.bat" "%DEST_DIR%\" /Y
copy "%~dp0qr.jpg" "%DEST_DIR%\" /Y
copy "%~dp0uninstall.bat" "%DEST_DIR%\" /Y

:: 3. Copy the shortcut to the Desktop
echo Copying shortcut to Desktop...
if exist "%~dp0SonicSync.lnk" (
    copy "%~dp0SonicSync.lnk" "%DESKTOP_DIR%\" /Y
) else (
    echo Warning: SonicSync.lnk not found in the current folder.
)

:: 4. Completion message
echo.
echo ===================================
echo Setup completed!!
echo ===================================
echo.
pause