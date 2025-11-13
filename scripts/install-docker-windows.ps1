<#
install-docker-windows.ps1

This helper attempts to install Docker Desktop on Windows using winget.
It also checks for WSL and offers to enable it. You MUST run this script as Administrator.

USAGE (run as Admin):
  powershell -ExecutionPolicy Bypass -File .\scripts\install-docker-windows.ps1

If winget is not available the script will print manual instructions and exit.
#>

function Write-Info($m){ Write-Host "[info] $m" -ForegroundColor Cyan }
function Write-Warn($m){ Write-Host "[warn] $m" -ForegroundColor Yellow }
function Write-Err($m){ Write-Host "[error] $m" -ForegroundColor Red }

# Require admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Err "This script must be run as Administrator. Right-click PowerShell and choose 'Run as administrator'."
    exit 1
}

Write-Info "Checking for winget..."
try { winget --version > $null 2>&1; $hasWinget = $true } catch { $hasWinget = $false }

if (-not $hasWinget) {
    Write-Warn "winget not found. You can install Docker Desktop manually:"
    Write-Host " - Download Docker Desktop: https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
    Write-Host " - Run the installer and follow the prompts."
    Write-Host "After install, start Docker Desktop and ensure it runs (tray icon). Then run the project's run-email-list.ps1 script." 
    exit 0
}

Write-Info "winget found. Checking for WSL..."
try { wsl --status > $null 2>&1; $hasWsl = $true } catch { $hasWsl = $false }

if (-not $hasWsl) {
    Write-Warn "WSL not detected. Docker Desktop uses WSL2 on modern Windows."
    Write-Host "I can attempt to enable WSL2 for you. This will download and install WSL components and may require a reboot."
    $resp = Read-Host "Enable WSL2 now? (Y/N)"
    if ($resp -match '^[Yy]') {
        Write-Info "Installing WSL (this may take a while)..."
        try {
            wsl --install -e Ubuntu
            Write-Info "WSL install completed. You may need to reboot."
        } catch {
            Write-Err "Automatic WSL install failed. Please follow manual instructions: https://aka.ms/wslinstall"
        }
    } else {
        Write-Warn "Continuing without WSL. Docker Desktop installer may still offer Hyper-V backend (Windows 10 Pro) but WSL2 is recommended."
    }
}

Write-Info "Installing Docker Desktop via winget..."
try {
    winget install --id Docker.DockerDesktop -e --source winget --accept-package-agreements --accept-source-agreements
    Write-Info "winget installation command completed. You may need to follow prompts in the installer UI." 
} catch {
    Write-Err "winget failed to start the Docker Desktop installer. You can download manually: https://www.docker.com/products/docker-desktop"
    exit 1
}

Write-Info "Done. After the installer finishes, start Docker Desktop from Start Menu and wait until Docker is running (tray icon)."
Write-Info "Then open a new Administrator PowerShell and run:"
Write-Host "  .\scripts\run-email-list.ps1" -ForegroundColor Green
