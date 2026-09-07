# Evently Rebranding Instructions

## Step 1: Save the Sloth Logo

Please save the sloth logo image you provided as:
- **File path**: `c:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\frontend\public\logos\evently-logo.png`
- **File name**: `evently-logo.png`

### How to save:
1. Right-click on the sloth logo image from your chat
2. Select "Save image as..."
3. Navigate to: `c:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\frontend\public\logos\`
4. Save it as: `evently-logo.png`

## Step 2: Restart Docker Containers

After saving the logo, restart the containers to apply all changes:

```bash
cd c:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\docker\all-in-one
docker compose down
docker compose up -d
```

## Changes Made

✅ Updated app name to "Evently" in .env file
✅ Updated email sender name to "Evently"
✅ Configured logo paths to use evently-logo.png
✅ All code references will use the new logo automatically

## What You'll See

After restarting:
- Login page will show your sloth logo
- Dashboard sidebar will show your sloth logo
- Welcome page will show your sloth logo
- All navigation areas will use the new branding
- Email notifications will be sent from "Evently"

## Optional: Create Favicon

If you want to also update the browser tab icon (favicon):
1. Create a smaller version of your sloth logo (48x48 pixels)
2. Save it as: `c:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\frontend\public\favicon.ico`
