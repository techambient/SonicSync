@echo off
:: Ensure admin privileges
:check_Permissions
echo Checking admin permissions...
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :download_icons
) else (
    echo Error: This script must be run as an Administrator.
    echo Attempting to elevate...
    powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
    exit /b
)

:download_icons
cls
echo [System Check] Checking/Downloading GUI Assets...
set "ICO_START=%TEMP%\ico_start.png"
set "ICO_UPDATE=%TEMP%\ico_update.png"
set "ICO_INFO=%TEMP%\ico_info.png"
set "ICO_EXIT=%TEMP%\ico_exit.png"

powershell -NoProfile -Command ^
    "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;" ^
    "if (-not (Test-Path '%ICO_START%')) { Invoke-WebRequest -Uri 'https://img.icons8.com/material-sharp/24/1A73E8/play.png' -OutFile '%ICO_START%' -UseBasicParsing };" ^
    "if (-not (Test-Path '%ICO_UPDATE%')) { Invoke-WebRequest -Uri 'https://img.icons8.com/material-sharp/24/1A73E8/synchronize.png' -OutFile '%ICO_UPDATE%' -UseBasicParsing };" ^
    "if (-not (Test-Path '%ICO_INFO%')) { Invoke-WebRequest -Uri 'https://img.icons8.com/material-sharp/24/1A73E8/info.png' -OutFile '%ICO_INFO%' -UseBasicParsing };" ^
    "if (-not (Test-Path '%ICO_EXIT%')) { Invoke-WebRequest -Uri 'https://img.icons8.com/material-sharp/24/D93025/logout-rounded.png' -OutFile '%ICO_EXIT%' -UseBasicParsing };"

:init
cls
title SonicSync
chcp 437 >nul

:: Build the temporary UI script safely utilizing the downloaded images
set "TEMP_UI=%TEMP%\app_launcher_gui.ps1"

(
echo [void][System.Reflection.Assembly]::LoadWithPartialName^('System.Windows.Forms'^)
echo [void][System.Reflection.Assembly]::LoadWithPartialName^('System.Drawing'^)
echo $form = New-Object System.Windows.Forms.Form
echo $form.Text = 'SonicSync Dashboard'
echo $form.Size = New-Object System.Drawing.Size^(360, 340^)
echo $form.StartPosition = 'CenterScreen'
echo $form.FormBorderStyle = 'FixedDialog'
echo $form.MaximizeBox = $false
echo $form.MinimizeBox = $false
echo $form.BackColor = [System.Drawing.Color]::FromArgb^(245, 245, 245^)
echo $fontBtn = New-Object System.Drawing.Font^('Segoe UI', 11, [System.Drawing.FontStyle]::Bold^)
echo $btn1 = New-Object System.Windows.Forms.Button
echo $btn1.Text = '   Start SonicSync'
echo if ^(Test-Path '%ICO_START%'^) {
echo      $img1 = [System.Drawing.Image]::FromFile^('%ICO_START%'^)
echo      $btn1.Image = $img1
echo      $btn1.TextImageRelation = 'ImageBeforeText'
echo      $btn1.ImageAlign = 'MiddleLeft'
echo }
echo $btn1.Location = New-Object System.Drawing.Point^(45, 30^)
echo $btn1.Size = New-Object System.Drawing.Size^(250, 48^)
echo $btn1.Font = $fontBtn
echo $btn1.BackColor = [System.Drawing.Color]::White
echo $btn1.FlatStyle = 'Flat'
echo $btn1.Add_Click^({ $global:res='1'; $form.Close^(^) }^)
echo $form.Controls.Add^($btn1^)
echo $btn2 = New-Object System.Windows.Forms.Button
echo $btn2.Text = '   Check For Updates'
echo if ^(Test-Path '%ICO_UPDATE%'^) {
echo      $img2 = [System.Drawing.Image]::FromFile^('%ICO_UPDATE%'^)
echo      $btn2.Image = $img2
echo      $btn2.TextImageRelation = 'ImageBeforeText'
echo      $btn2.ImageAlign = 'MiddleLeft'
echo }
echo $btn2.Location = New-Object System.Drawing.Point^(45, 95^)
echo $btn2.Size = New-Object System.Drawing.Size^(250, 48^)
echo $btn2.Font = $fontBtn
echo $btn2.BackColor = [System.Drawing.Color]::White
echo $btn2.FlatStyle = 'Flat'
echo $btn2.Add_Click^({ $global:res='2'; $form.Close^(^) }^)
echo $form.Controls.Add^($btn2^)
echo $btn3 = New-Object System.Windows.Forms.Button
echo $btn3.Text = '   About Version'
echo if ^(Test-Path '%ICO_INFO%'^) {
echo      $img3 = [System.Drawing.Image]::FromFile^('%ICO_INFO%'^)
echo      $btn3.Image = $img3
echo      $btn3.TextImageRelation = 'ImageBeforeText'
echo      $btn3.ImageAlign = 'MiddleLeft'
echo }
echo $btn3.Location = New-Object System.Drawing.Point^(45, 160^)
echo $btn3.Size = New-Object System.Drawing.Size^(250, 48^)
echo $btn3.Font = $fontBtn
echo $btn3.BackColor = [System.Drawing.Color]::White
echo $btn3.FlatStyle = 'Flat'
echo $btn3.Add_Click^({ $global:res='3'; $form.Close^(^) }^)
echo $form.Controls.Add^($btn3^)
echo $btn4 = New-Object System.Windows.Forms.Button
echo $btn4.Text = '   Exit'
echo if ^(Test-Path '%ICO_EXIT%'^) {
echo      $img4 = [System.Drawing.Image]::FromFile^('%ICO_EXIT%'^)
echo      $btn4.Image = $img4
echo      $btn4.TextImageRelation = 'ImageBeforeText'
echo      $btn4.ImageAlign = 'MiddleLeft'
echo }
echo $btn4.Location = New-Object System.Drawing.Point^(45, 225^)
echo $btn4.Size = New-Object System.Drawing.Size^(250, 48^)
echo $btn4.Font = $fontBtn
echo $btn4.BackColor = [System.Drawing.Color]::White
echo $btn4.ForeColor = [System.Drawing.Color]::FromArgb^(217, 48, 37^)
echo $btn4.FlatStyle = 'Flat'
echo $btn4.Add_Click^({ $global:res='4'; $form.Close^(^) }^)
echo $form.Controls.Add^($btn4^)
echo $form.TopMost = $true
echo [void]$form.ShowDialog^(^)
echo Write-Output $global:res
) > "%TEMP_UI%"

set "SelectedOption="
for /f "delims=" %%I in ('powershell -NoProfile -ExecutionPolicy Bypass -File "%TEMP_UI%"') do set "SelectedOption=%%I"

if exist "%TEMP_UI%" del "%TEMP_UI%"

if "%SelectedOption%"=="1" goto :StartApp
if "%SelectedOption%"=="2" goto :CheckUpdates
if "%SelectedOption%"=="3" goto :AboutVersion
if "%SelectedOption%"=="4" goto :ExitApp
goto :init

:: ==========================================
:: OPTION 1: START APP
:: ==========================================
:StartApp
cls
echo [1/4] Checking for Node.js...
:checkNode
where node >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo Error: Node.js is NOT installed!
    echo Please download and install Node.js from https://nodejs.org/
    echo Once installed, press ENTER to check again...
    pause >nul
    goto :checkNode
)
echo Node.js is installed.

echo.
echo [2/4] Checking for 'http-server' package...
call npm list -g http-server >nul 2>&1
if %errorLevel% neq 0 (
    echo 'http-server' not found. Installing globally...
    call npm install -g http-server
) else (
    echo 'http-server' is already installed.
)

echo.
echo [3/4] Launching http-server minimized...
start /min cmd /c "cd \p2p && http-server"

echo.
echo [4/4] Opening QR Code window...

:: Check if qr.jpg exists in execution scope to prevent powershell crashes
if not exist "qr.jpg" (
    if exist "\p2p\qr.jpg" (
        copy "\p2p\qr.jpg" "qr.jpg" >nul
    ) else (
        echo Warning: qr.jpg was not found in the current folder or \p2p.
        echo Please ensure qr.jpg is located in the script directory.
    )
)

:: Run inline UI popup module positioned in the right-hand corner of the screen
set "QR_POPUP=%TEMP%\qr_popup.ps1"
(
echo [void][System.Reflection.Assembly]::LoadWithPartialName^('System.Windows.Forms'^)
echo [void][System.Reflection.Assembly]::LoadWithPartialName^('System.Drawing'^)
echo $win32 = Add-Type -MemberDefinition '[DllImport^("user32.dll"^)] public static extern bool ShowWindow^(IntPtr hWnd, int nCmdShow^); [DllImport^("user32.dll"^)] public static extern bool SetForegroundWindow^(IntPtr hWnd^);' -Name 'Win32Util' -Namespace 'Win32' -PassThru
echo $myProcess = Get-Process -Id $PID
echo $hwnd = $myProcess.MainWindowHandle
echo if ^($hwnd -ne [IntPtr]::Zero^) { [Win32.Win32Util]::ShowWindow^($hwnd, 0^) }
echo $qrForm = New-Object System.Windows.Forms.Form
echo $qrForm.Text = 'Scan QR Code'
echo $qrForm.Size = New-Object System.Drawing.Size^(300, 310^)
echo $qrForm.FormBorderStyle = 'FixedDialog'
echo $qrForm.MaximizeBox = $false
echo $qrForm.MinimizeBox = $false
echo $qrForm.BackColor = [System.Drawing.Color]::White
echo $screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
echo $x = $screen.Width - $qrForm.Width - 20
echo $y = $screen.Height - $qrForm.Height - 20
echo $qrForm.Location = New-Object System.Drawing.Point^($x, $y^)
echo $qrForm.StartPosition = 'Manual'
echo $pb = New-Object System.Windows.Forms.PictureBox
echo $pb.Location = New-Object System.Drawing.Point^(15, 10^)
echo $pb.Size = New-Object System.Drawing.Size^(250, 250^)
echo $pb.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom
echo if ^(Test-Path 'qr.jpg'^) {
echo     $pb.Image = [System.Drawing.Image]::FromFile^('qr.jpg'^)
echo } else {
echo     $qrForm.Text = 'QR Error - Image Missing'
echo }
echo $qrForm.Controls.Add^($pb^)
echo $qrForm.TopMost = $true
echo $qrForm.Add_Shown^({
echo     Start-Sleep -Milliseconds 150
echo     $parentPid = ^(Get-CimInstance Win32_Process -Filter "ProcessId = $PID"^).ParentProcessId
echo     $cmdProcess = Get-Process -Id $parentPid -ErrorAction SilentlyContinue
echo     if ^($cmdProcess^) {
echo         $cmdHwnd = $cmdProcess.MainWindowHandle
echo         if ^($cmdHwnd -ne [IntPtr]::Zero^) { [void][Win32.Win32Util]::SetForegroundWindow^($cmdHwnd^) }
echo     }
echo }^)
echo [void]$qrForm.ShowDialog^(^)
) > "%QR_POPUP%"

:: Launch without masking Form generation elements
for /f "tokens=1" %%P in ('powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%QR_POPUP%""' -PassThru | Select-Object -ExpandProperty Id"') do set "QR_PID=%%P"

echo.
echo ========================================================
echo Switch to another cmd window and go to: http://10.X.X.X as shown in the cmd OR Scan the QR Code for guide.
echo ========================================================
echo CLICK THIS WINDOW and press ENTER once you have navigated to http://10.X.X.X on other device...
pause >nul

:: Integrated CMD Cleanup: Close the target window immediately via captured process identification
if defined QR_PID taskkill /pid %QR_PID% /f >nul 2>&1

:: Clean up temporary script asset
if exist "%QR_POPUP%" del "%QR_POPUP%"

:: Open localhost in default browser
start http://127.0.0.1:8080

echo.
echo --------------------------------------------------------
echo Switch to another cmd window and press Ctrl + C to end app.
echo --------------------------------------------------------
echo Press Enter to return to main menu...
pause >nul
goto :init

:: ==========================================
:: OPTION 2: CHECK FOR UPDATES
:: ==========================================
:CheckUpdates
cls
echo Checking for updates in the background...

for /f "delims=" %%V in ('powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; try { (Invoke-WebRequest -Uri 'https://techambient.github.io/SonicSync/version.txt' -UseBasicParsing -TimeoutSec 5).Content.Trim() } catch { echo 0 }"') do set "OnlineVersion=%%V"

if "%OnlineVersion%"=="" set "OnlineVersion=0"

powershell -NoProfile -Command "if ([double]%OnlineVersion% -gt 1.0) { exit 10 } else { exit 20 }"
if %errorLevel%==10 (
    echo.
    echo New Version is available! Press enter to view.
    pause >nul
    start https://techambient.github.io/SonicSync/
) else (
    echo.
    echo No updates available, press enter to back.
    pause >nul
)
goto :init

:: ==========================================
:: OPTION 3: ABOUT VERSION
:: ==========================================
:AboutVersion
cls
echo Current Version: v1.0; press enter to back.
pause >nul
goto :init

:: ==========================================
:: OPTION 4: EXIT
:: ==========================================
:ExitApp
cls
echo Exiting SonicSync...
timeout /t 1 >nul
exit