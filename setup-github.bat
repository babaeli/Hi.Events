@echo off
echo ============================================
echo  GitHub Setup and Push Script
echo ============================================
echo.
echo Step 1: Authenticating with GitHub...
echo.
echo FOLLOW THESE STEPS:
echo 1. Copy the code that appears
echo 2. Press Enter to open browser
echo 3. Paste the code in browser
echo 4. Click "Authorize GitHub CLI"
echo.
pause
echo.

"C:\Program Files\GitHub CLI\gh.exe" auth login

echo.
echo ============================================
echo Step 2: Creating repository...
echo ============================================
echo.

cd /d "C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop"

"C:\Program Files\GitHub CLI\gh.exe" repo create babaeli/evently --private --description "Multi-tenant SaaS event ticketing platform" --source=. --remote=origin

echo.
echo ============================================
echo Step 3: Pushing code to GitHub...
echo ============================================
echo.

git push -u origin main

echo.
echo ============================================
echo  SUCCESS!
echo ============================================
echo.
echo Your code is now at: https://github.com/babaeli/evently
echo.
pause
