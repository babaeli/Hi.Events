# Hi.Events Startup Script
# This script starts your Hi.Events application

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "  Hi.Events Startup Script" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is running
Write-Host "Checking Docker status..." -ForegroundColor Yellow
$dockerRunning = $false
try {
    docker ps > $null 2>&1
    if ($LASTEXITCODE -eq 0) {
        $dockerRunning = $true
        Write-Host "✓ Docker is running" -ForegroundColor Green
    }
} catch {
    $dockerRunning = $false
}

if (-not $dockerRunning) {
    Write-Host "✗ Docker is not running!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please start Docker Desktop:" -ForegroundColor Yellow
    Write-Host "1. Press Windows key" -ForegroundColor White
    Write-Host "2. Search for 'Docker Desktop'" -ForegroundColor White
    Write-Host "3. Launch Docker Desktop" -ForegroundColor White
    Write-Host "4. Wait for Docker icon to show 'running' status" -ForegroundColor White
    Write-Host ""
    Write-Host "Then run this script again!" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if .env exists
$envPath = "docker/all-in-one/.env"
if (-not (Test-Path $envPath)) {
    Write-Host "✗ .env file not found!" -ForegroundColor Red
    Write-Host "Creating .env from .env.example..." -ForegroundColor Yellow
    Copy-Item "docker/all-in-one/.env.example" $envPath
    
    # Generate keys
    Write-Host "Generating APP_KEY and JWT_SECRET..." -ForegroundColor Yellow
    $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
    $bytes1 = New-Object byte[] 32
    $bytes2 = New-Object byte[] 32
    $rng.GetBytes($bytes1)
    $rng.GetBytes($bytes2)
    $appKey = "base64:$([Convert]::ToBase64String($bytes1))"
    $jwtSecret = [Convert]::ToBase64String($bytes2)
    
    # Update .env
    $envContent = Get-Content $envPath -Raw
    $envContent = $envContent -replace 'APP_KEY=', "APP_KEY=$appKey"
    $envContent = $envContent -replace 'JWT_SECRET=', "JWT_SECRET=$jwtSecret"
    $envContent = $envContent -replace 'APP_SAAS_MODE_ENABLED=false', 'APP_SAAS_MODE_ENABLED=true'
    Set-Content $envPath $envContent
    
    Write-Host "✓ .env file created with keys!" -ForegroundColor Green
}

# Start Docker containers
Write-Host ""
Write-Host "Starting Docker containers..." -ForegroundColor Yellow
Set-Location "docker/all-in-one"

try {
    docker compose up -d
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Containers started successfully!" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to start containers" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "✗ Error starting containers: $_" -ForegroundColor Red
    exit 1
}

# Wait a moment
Write-Host ""
Write-Host "Waiting for services to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# Check container status
Write-Host ""
Write-Host "Container Status:" -ForegroundColor Cyan
docker compose ps

Write-Host ""
Write-Host "==================================" -ForegroundColor Green
Write-Host "  🚀 Hi.Events is starting up!" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green
Write-Host ""
Write-Host "Access the application at:" -ForegroundColor Cyan
Write-Host "  → http://localhost:8123" -ForegroundColor White
Write-Host ""
Write-Host "Wait 30-60 seconds for everything to be ready," -ForegroundColor Yellow
Write-Host "then refresh your browser if it doesn't load immediately." -ForegroundColor Yellow
Write-Host ""
Write-Host "To create SUPERADMIN users:" -ForegroundColor Cyan
Write-Host "  docker compose exec app bash" -ForegroundColor White
Write-Host "  php artisan superadmin:create admin@example.com" -ForegroundColor White
Write-Host ""
Write-Host "To view logs:" -ForegroundColor Cyan
Write-Host "  docker compose logs -f" -ForegroundColor White
Write-Host ""
Write-Host "To stop the application:" -ForegroundColor Cyan
Write-Host "  docker compose down" -ForegroundColor White
Write-Host ""
Write-Host "See RUNNING_THE_PROJECT.md for full documentation!" -ForegroundColor Cyan
Write-Host ""
