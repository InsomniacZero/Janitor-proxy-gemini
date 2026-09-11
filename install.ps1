# ==============================================================================
# Janitor-proxy-gemini - 1-Click Universal Windows Installer & Shortcut Setup
# ==============================================================================

$ErrorActionPreference = "Stop"

Write-Host "===================================================================" -ForegroundColor Cyan
Write-Host "  Janitor-proxy-gemini - Universal Windows Installer" -ForegroundColor Cyan
Write-Host "===================================================================" -ForegroundColor Cyan

# 1. Check Python
Write-Host "[1/4] Checking Python..." -ForegroundColor Yellow
$hasPython = Get-Command "python" -ErrorAction SilentlyContinue
if (-not $hasPython) {
    Write-Host "[!] Python is not installed or not in your PATH." -ForegroundColor Red
    Write-Host "Attempting automatic installation via winget..." -ForegroundColor Yellow
    try {
        winget install -e --id Python.Python.3.12 --accept-package-agreements --accept-source-agreements
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    } catch {
        Write-Host "[ERROR] Could not auto-install Python." -ForegroundColor Red
        Write-Host "Please install Python from https://www.python.org/downloads/ (check 'Add python.exe to PATH') and rerun this command." -ForegroundColor Red
        Read-Host "Press Enter to exit..."
        exit 1
    }
}

# 2. Download and extract repository
Write-Host "[2/4] Downloading latest files from GitHub..." -ForegroundColor Yellow
$dest = "$HOME\Janitor-proxy-gemini"
if (Test-Path $dest) {
    Remove-Item -Recurse -Force $dest -ErrorAction SilentlyContinue
}

$zip = "$env:TEMP\gemini_win.zip"
$extractTemp = "$env:TEMP\gemini_extract"
if (Test-Path $extractTemp) { Remove-Item -Recurse -Force $extractTemp -ErrorAction SilentlyContinue }

Invoke-WebRequest -Uri "https://github.com/InsomniacZero/Janitor-proxy-gemini/archive/refs/heads/main.zip" -OutFile $zip
Expand-Archive -Path $zip -DestinationPath $extractTemp -Force
Move-Item "$extractTemp\Janitor-proxy-gemini-main" $dest
Remove-Item -Recurse -Force $extractTemp, $zip -ErrorAction SilentlyContinue

# 3. Install Python dependencies
Write-Host "[3/4] Installing Python httpx library..." -ForegroundColor Yellow
python -m pip install httpx --quiet

# 4. Create 'insom' keyword shortcuts (PATH, PowerShell Profile, Desktop)
Write-Host "[4/4] Creating 'insom' shortcut command..." -ForegroundColor Yellow

# A. Create insom.bat inside the folder
$insomBat = "$dest\insom.bat"
"@echo off`r`ncall `"%~dp0start.bat`"" | Out-File -FilePath $insomBat -Encoding ascii

# B. Add folder to User PATH so CMD and PowerShell recognize 'insom'
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$dest*") {
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$dest", "User")
}
$env:Path += ";$dest"

# C. Add 'insom' function to PowerShell profile for instant terminal usage
try {
    if (!(Test-Path $PROFILE)) {
        New-Item -ItemType File -Path $PROFILE -Force | Out-Null
    }
    $profContent = Get-Content $PROFILE -ErrorAction SilentlyContinue | Out-String
    if ($profContent -notmatch "function insom") {
        Add-Content -Path $PROFILE -Value "`nfunction insom { & '$dest\start.bat' }"
    }
} catch {}

# D. Create Desktop shortcut icon
try {
    $ws = New-Object -ComObject WScript.Shell
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $sc = $ws.CreateShortcut("$desktopPath\Insom Gemini.lnk")
    $sc.TargetPath = "$dest\start.bat"
    $sc.WorkingDirectory = "$dest"
    $sc.IconLocation = "shell32.dll,220"
    $sc.Description = "JanitorAI Gemini Proxy Server"
    $sc.Save()
} catch {}

Write-Host ""
Write-Host "===================================================================" -ForegroundColor Green
Write-Host "   🎉 INSTALLATION COMPLETE! YOU'RE READY TO ROLEPLAY! 🎉       " -ForegroundColor Green
Write-Host "===================================================================" -ForegroundColor Green
Write-Host "From now on, whenever you want to start the server, just type:" -ForegroundColor White
Write-Host ""
Write-Host "      insom" -ForegroundColor Yellow
Write-Host ""
Write-Host "in any PowerShell or Command Prompt, or double-click the desktop icon!" -ForegroundColor White
Write-Host "===================================================================" -ForegroundColor Green
Write-Host ""

# Start the server immediately
& "$dest\start.bat"
