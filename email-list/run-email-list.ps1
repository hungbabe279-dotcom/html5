<#
.SYNOPSIS
  Build and run the email-list Docker image, test the root page, and optionally clean up.

.DESCRIPTION
  This script automates the common workflow for the servlet example in the `email-list` folder.
  It will:
    - check that Docker is available
    - build the Docker image (tag: email-list)
    - run the container (name: email-list, port 8080)
    - wait for the server to respond and print the first 2000 characters of the root page
    - optionally stop and remove the container when finished

.PARAMETER NoCleanup
  If provided, the container will be left running after the test. By default the script stops and removes the container.

.EXAMPLE
  # Build, run, test, and cleanup
  .\run-email-list.ps1

.EXAMPLE
  # Build, run, test, but keep the container running
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

Write-Info "Building Docker image 'email-list' from Dockerfile in current folder..."
$build = docker build -t email-list .
if ($LASTEXITCODE -ne 0){ Write-ErrorAndExit "Docker build failed. Check the output above." }

Write-Info "Stopping any existing container named 'email-list'..."
docker rm -f email-list 2>$null | Out-Null

Write-Info "Starting container 'email-list' mapping host:8080 -> container:8080..."
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

Write-Info "Server responded. Printing first 2000 chars of root page:"
$body = $resp.Content
if ($body.Length -gt 2000) { $body = $body.Substring(0,2000) + "`n... (truncated)" }
Write-Host $body

if ($NoCleanup) {
    Write-Info "Left container running (use 'docker stop email-list' and 'docker rm email-list' to clean up)."
    exit 0
}

Write-Info "Stopping and removing container..."
docker stop email-list | Out-Null
docker rm email-list | Out-Null
Write-Info "Done."
