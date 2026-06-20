@echo off
:: Check for administrative privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Current permissions inadequate. Please run this script as an Administrator.
    pause
    exit /b
)

:: 1. Delete the C:\p2p folder
if exist "C:\p2p" (
    echo Deleting "C:\p2p"...
    rmdir /s /q "C:\p2p"
    echo Folder "C:\p2p" deleted successfully.
) else (
    echo Folder "C:\p2p" does not exist.
)

echo.

:: 2. Delete SonicSync shortcut from Current User Desktop
if exist "%USERPROFILE%\Desktop\SonicSync.lnk" (
    echo Deleting SonicSync shortcut from your desktop...
    del /f /q "%USERPROFILE%\Desktop\SonicSync.lnk"
    echo Shortcut deleted.
) else (
    echo SonicSync shortcut not found on your desktop.
)

:: 3. Delete SonicSync shortcut from Public Desktop (just in case it installed for All Users)
if exist "%PUBLIC%\Desktop\SonicSync.lnk" (
    echo Deleting SonicSync shortcut from Public desktop...
    del /f /q "%PUBLIC%\Desktop\SonicSync.lnk"
    echo Public shortcut deleted.
)

echo.
echo Uninstall complete.
pause