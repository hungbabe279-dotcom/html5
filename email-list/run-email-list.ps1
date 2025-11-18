<#
.SYNOPSIS
  Build and run the email-list Docker image with Exercise 6-1 & 6-2 examples.

.DESCRIPTION
  This script:
    - Builds the Docker image from Dockerfile
    - Runs the container mapping port 8080
    - Tests the root welcome page
    - Displays access instructions

.PARAMETER NoCleanup
  If provided, keeps container running. Otherwise stops and removes it.

.EXAMPLE
  .\run-email-list.ps1
  .\run-email-list.ps1 -NoCleanup
#>

param(
    [switch]$NoCleanup
)

function Write-Info($m){ Write-Host "[info] $m" -ForegroundColor Cyan }
function Write-ErrorAndExit($m){ Write-Host "[error] $m" -ForegroundColor Red; exit 1 }

Write-Info "Checking for Docker..."
try{
    $dv = docker --version 2>$null
} catch {
    Write-ErrorAndExit "Docker command not found. Install Docker Desktop and make sure 'docker' is on your PATH."
}

Write-Info "Building Docker image 'email-list'..."
$build = docker build -t email-list .
if ($LASTEXITCODE -ne 0){ Write-ErrorAndExit "Docker build failed. Check the output above." }

Write-Info "Stopping any existing container named 'email-list'..."
docker rm -f email-list 2>$null | Out-Null

Write-Info "Starting container 'email-list' on port 8080..."
docker run -d --name email-list -p 8080:8080 email-list | Out-Null
if ($LASTEXITCODE -ne 0){ Write-ErrorAndExit "Failed to start container." }

Write-Info "Waiting for server to boot (up to 30s)..."
$start = Get-Date
$resp = $null
while ((Get-Date) - $start -lt ([TimeSpan]::FromSeconds(30))) {
    try{
        $resp = Invoke-WebRequest -Uri 'http://localhost:8080/' -UseBasicParsing -TimeoutSec 5
        break
    } catch {
        Start-Sleep -Seconds 1
    }
}

if (-not $resp) { Write-ErrorAndExit "No response from http://localhost:8080/ after 30 seconds. Check container logs with 'docker logs email-list'." }

Write-Info "Server is running!"
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Application is ready to test:" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  Welcome Page:   http://localhost:8080/" -ForegroundColor Cyan
Write-Host "  Email List:     http://localhost:8080/index.jsp" -ForegroundColor Cyan
Write-Host "  Survey Form:    http://localhost:8080/survey-form.html" -ForegroundColor Cyan
Write-Host ""
Write-Host "Features to test:" -ForegroundColor Yellow
Write-Host "  - Email list form with validation and header/footer includes" -ForegroundColor Yellow
Write-Host "  - Survey form with conditional field visibility (Contact Via)" -ForegroundColor Yellow
Write-Host "  - EL expression to display current year in footer" -ForegroundColor Yellow
Write-Host ""

if ($NoCleanup) {
    Write-Info "Container is running. Use 'docker stop email-list' and 'docker rm email-list' to clean up."
    exit 0
}

Write-Info "Keeping container running for manual testing. Press Ctrl+C to stop."
Write-Host ""

# Wait for user to stop the script
try {
    while($true) {
        Start-Sleep -Seconds 5
        # Check if container is still running
        $running = docker ps --filter "name=email-list" --quiet
        if (-not $running) {
            Write-Info "Container stopped."
            break
        }
    }
} catch {
    # User pressed Ctrl+C
}

Write-Info "Stopping and removing container..."
docker stop email-list 2>$null | Out-Null
docker rm email-list 2>$null | Out-Null
Write-Info "Done."
