# PowerShell script to create GitHub repo and push code
# Run this script and follow the prompts

Write-Host "================================" -ForegroundColor Cyan
Write-Host "  GitHub Repository Setup" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Check if gh CLI is installed
$ghInstalled = Get-Command gh -ErrorAction SilentlyContinue

if (-not $ghInstalled) {
    Write-Host "GitHub CLI not found. Installing..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Installing GitHub CLI (gh)..." -ForegroundColor Green
    winget install --id GitHub.cli --silent
    
    Write-Host ""
    Write-Host "Please close this window and run the script again!" -ForegroundColor Yellow
    pause
    exit
}

Write-Host "✓ GitHub CLI is installed" -ForegroundColor Green
Write-Host ""

# Check if authenticated
Write-Host "Checking GitHub authentication..." -ForegroundColor Cyan
$authStatus = gh auth status 2>&1

if ($authStatus -like "*not logged*" -or $authStatus -like "*failed*") {
    Write-Host "You need to login to GitHub..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Opening GitHub login in browser..." -ForegroundColor Green
    gh auth login
}

Write-Host ""
Write-Host "✓ Authenticated with GitHub" -ForegroundColor Green
Write-Host ""

# Create repository
Write-Host "Creating repository 'evently'..." -ForegroundColor Cyan
Write-Host ""

$createRepo = Read-Host "Make repository PRIVATE? (y/n) [y is recommended]"
$private = if ($createRepo -eq "y" -or $createRepo -eq "" -or $createRepo -eq "Y") { "--private" } else { "--public" }

$repoCommand = "gh repo create babaeli/evently $private --description `"Multi-tenant SaaS event ticketing platform - Hi.Events fork with custom setup`" --source=. --remote=origin"
Invoke-Expression $repoCommand

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✓ Repository created successfully!" -ForegroundColor Green
    Write-Host ""
    
    # Push code
    Write-Host "Pushing code to GitHub..." -ForegroundColor Cyan
    git push -u origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "================================" -ForegroundColor Green
        Write-Host "  SUCCESS!" -ForegroundColor Green
        Write-Host "================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Your repository is now live at:" -ForegroundColor Cyan
        Write-Host "https://github.com/babaeli/evently" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Files pushed:" -ForegroundColor Cyan
        Write-Host "  ✓ START_HERE.txt"
        Write-Host "  ✓ COMPLETE_SETUP_GUIDE.md"
        Write-Host "  ✓ TESTING_GUIDE.md"
        Write-Host "  ✓ FEATURES_LIST.md"
        Write-Host "  ✓ All documentation files"
        Write-Host ""
        Write-Host "Sensitive files (NOT pushed):" -ForegroundColor Yellow
        Write-Host "  ✗ ADMIN_CREDENTIALS.txt (kept private)"
        Write-Host "  ✗ .env file (kept private)"
        Write-Host ""
    }
    else {
        Write-Host ""
        Write-Host "Push failed. Please check the error above." -ForegroundColor Red
    }
}
else {
    Write-Host ""
    Write-Host "Repository creation failed. It might already exist." -ForegroundColor Yellow
    Write-Host "Trying to push to existing repository..." -ForegroundColor Cyan
    git push -u origin main
}

Write-Host ""
Write-Host "Press any key to close..." -ForegroundColor Gray
pause
