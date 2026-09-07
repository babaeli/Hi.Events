# 🚀 Hi.Events - Complete Setup & Login Guide

## 📋 Table of Contents
1. [Project Location](#project-location)
2. [Docker Setup Instructions](#docker-setup-instructions)
3. [Login Credentials](#login-credentials)
4. [Starting & Stopping the Application](#starting--stopping-the-application)
5. [Troubleshooting](#troubleshooting)
6. [Backup & Maintenance](#backup--maintenance)

---

# 📍 Project Location

## Where is the code stored?

```
C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\
```

**Important folders:**
- `backend\` - PHP/Laravel backend code
- `frontend\` - React frontend code  
- `docker\all-in-one\` - Docker configuration (this is what we use)

---

# 🐳 Docker Setup Instructions

## Prerequisites

### 1. Install Docker Desktop (Already Done ✅)
- Version: Docker 29.7.2
- Docker Compose: v5.5.0
- Status: Installed and working

### 2. System Requirements
- Windows 10/11
- WSL 2 (Windows Subsystem for Linux) - Already installed ✅
- At least 4GB RAM
- At least 10GB free disk space

---

## Initial Setup (What We Did)

### Step 1: Navigate to Project Directory

Open PowerShell and run:

```powershell
cd C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\docker\all-in-one
```

### Step 2: Verify Configuration File

The `.env` file already exists with proper configuration:

```powershell
# Check if .env file exists
Test-Path .env

# Should return: True
```

**Key settings in `.env` file:**
```env
# Application Keys (Already configured ✅)
APP_KEY=base64:WRtDF3aysGcS7FLEd2Nsfp+e0W2OjwBKbVuTQYu/tlU=
JWT_SECRET=R3JTyOfaWRmT0imqhAdf/MTWpvjZ7PdSnlFjak0BqIU=

# Frontend URLs
VITE_FRONTEND_URL=http://localhost:8123
VITE_API_URL_CLIENT=http://localhost:8123/api

# SaaS Mode (Enabled ✅)
APP_SAAS_MODE_ENABLED=true
APP_SAAS_STRIPE_APPLICATION_FEE_PERCENT=10
APP_SAAS_STRIPE_APPLICATION_FEE_FIXED=50

# Database
POSTGRES_DB=hi-events
POSTGRES_USER=postgres
POSTGRES_PASSWORD=secret
```

### Step 3: Start Docker Desktop

1. Open **Docker Desktop** from Start Menu
2. Wait for Docker to start (look for whale icon 🐳 in system tray)
3. Status should say: "Docker Desktop is running"

### Step 4: Start the Application

```powershell
# Navigate to docker directory
cd C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\docker\all-in-one

# Start all containers
docker compose up -d
```

**What happens:**
- Downloads required Docker images (first time only - takes 5-10 minutes)
- Creates 3 containers:
  - `all-in-one-all-in-one-1` - The main application
  - `all-in-one-postgres-1` - Database
  - `all-in-one-redis-1` - Cache
- Runs database migrations
- Application ready at http://localhost:8123

### Step 5: Verify Installation

```powershell
# Check if containers are running
docker compose ps

# Expected output:
# NAME                      STATUS
# all-in-one-all-in-one-1   Up (healthy)
# all-in-one-postgres-1     Up (healthy)
# all-in-one-redis-1        Up (healthy)
```

### Step 6: Access the Application

Open your browser and go to:
```
http://localhost:8123
```

You should see the Hi.Events homepage! 🎉

---

## Docker Commands Reference

### Start the Application
```powershell
cd C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\docker\all-in-one
docker compose up -d
```

### Stop the Application
```powershell
cd C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\docker\all-in-one
docker compose down
```

### Restart the Application
```powershell
cd C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\docker\all-in-one
docker compose restart
```

### View Application Logs
```powershell
cd C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\docker\all-in-one

# View all logs
docker compose logs -f

# View specific container logs
docker compose logs -f all-in-one
```

### Check Container Status
```powershell
docker compose ps
```

### Stop and Remove Everything (Clean slate)
```powershell
cd C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\docker\all-in-one

# Stop and remove containers (data preserved)
docker compose down

# Stop, remove containers AND delete data (⚠️ WARNING: Deletes all events, orders, users!)
docker compose down -v
```

---

# 🔐 Login Credentials

## 👑 Super Admin Account (Platform Owner)

**Login URL:** http://localhost:8123/auth/login

```
📧 Email:    admin@hievents.com
🔑 Password: SuperAdmin2024
```

**After Login, Go To:**
```
Admin Dashboard: http://localhost:8123/admin
```

**What You Can Do:**
✅ View ALL organizers and accounts  
✅ View ALL events across the platform  
✅ View ALL orders and revenue  
✅ Platform-wide statistics  
✅ Impersonate any user  
✅ Manage platform settings  
✅ Monitor system health  
✅ Process refunds for any event  
✅ View platform fees earned  

**Your Role:**
- Platform Owner
- Complete system access
- Earn platform fees from all sales (10% + $0.50 per transaction)

---

## 👥 Event Organizer Account (Normal User)

**Login URL:** http://localhost:8123/auth/login

```
📧 Email:    organizer@test.com
🔑 Password: User123456
```

**After Login, Go To:**
```
Events Dashboard: http://localhost:8123/manage/events
```

**What You Can Do:**
✅ Create and manage YOUR events  
✅ Sell tickets online  
✅ Manage attendees  
✅ Process refunds (your events only)  
✅ View YOUR sales analytics  
✅ Send emails to YOUR attendees  
✅ QR code check-in  
✅ Create promo codes  

**What You CANNOT Do:**
❌ View other organizers' events  
❌ Access /admin dashboard  
❌ See platform-wide statistics  
❌ Impersonate other users  

**Your Account Details:**
- Company: Event Organizer Co
- Role: ADMIN (Account Owner)
- Status: ACTIVE
- Account ID: 4
- User ID: 5

---

## 🎯 Current Setup Summary

### Database Status
```
✅ Super Admin Account: admin@hievents.com
✅ Organizer Account: organizer@test.com
✅ Events Created: 3
   - Kenya Business & Innovation Summit 2026
   - East Africa Food & Hospitality Expo 2026
   - Kenya Green Energy & Sustainability Forum 2026
✅ Tickets Created: 12 ticket types total
✅ Orders Placed: 1 test order ($260)
```

### Platform Configuration
```
✅ SaaS Mode: ENABLED
✅ Platform Fee: 10% + $0.50 per transaction
✅ Email: Log driver (emails saved to logs)
✅ Stripe: Test mode
✅ Currency: USD
✅ Timezone: UTC
```

---

# ⚙️ Starting & Stopping the Application

## Daily Usage

### Morning - Start the App
```powershell
# Open PowerShell
cd C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\docker\all-in-one

# Start Docker Desktop (if not running)
# Then run:
docker compose up -d

# Wait 30 seconds, then access:
# http://localhost:8123
```

### Evening - Stop the App
```powershell
cd C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\docker\all-in-one
docker compose down
```

**Note:** Your data (events, users, orders) is preserved when you stop the app!

---

## 🔄 Common Operations

### Restart After Making Changes
```powershell
cd C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\docker\all-in-one
docker compose restart
```

### View Real-Time Logs
```powershell
cd C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\docker\all-in-one
docker compose logs -f all-in-one
```

### Check if App is Running
```powershell
docker compose ps
```

### Update Configuration (.env file)
1. Edit the `.env` file:
   ```
   C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\docker\all-in-one\.env
   ```
2. Save changes
3. Restart containers:
   ```powershell
   docker compose restart
   ```

---

# 🆘 Troubleshooting

## Problem: Docker not starting

**Error:** `failed to connect to docker API`

**Solution:**
1. Open Docker Desktop from Start Menu
2. Wait for it to fully start
3. Look for whale icon 🐳 in system tray
4. Try the command again

---

## Problem: Port 8123 already in use

**Error:** `port is already allocated`

**Solution:**
```powershell
# Find what's using port 8123
netstat -ano | findstr :8123

# Kill the process (replace PID with actual number)
taskkill /PID <PID> /F

# Or use a different port by editing docker-compose.yml
# Change "8123:80" to "8124:80"
```

---

## Problem: Cannot access http://localhost:8123

**Solution:**
1. Check containers are running:
   ```powershell
   docker compose ps
   ```

2. Check logs for errors:
   ```powershell
   docker compose logs all-in-one
   ```

3. Restart containers:
   ```powershell
   docker compose restart
   ```

4. Try accessing after 30 seconds

---

## Problem: Login not working

**Solution:**
1. Verify you're using correct credentials (see above)
2. Check if account is ACTIVE:
   ```powershell
   docker compose exec postgres psql -U postgres -d hi-events -c "SELECT email, au.status FROM users u JOIN account_users au ON u.id = au.user_id;"
   ```
3. If status is "INVITED", change to "ACTIVE":
   ```powershell
   docker compose exec postgres psql -U postgres -d hi-events -c "UPDATE account_users SET status = 'ACTIVE' WHERE user_id = YOUR_USER_ID;"
   ```

---

## Problem: Database errors

**Solution - Reset Database:**
```powershell
cd C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\docker\all-in-one

# ⚠️ WARNING: This deletes ALL data!
docker compose down -v
docker compose up -d

# Wait for migrations to complete (2-3 minutes)
# Then recreate super admin account (see SUPER_ADMIN_SETUP.md)
```

---

## Problem: Out of disk space

**Solution - Clean Docker:**
```powershell
# Remove unused images and containers
docker system prune -a

# Warning: This removes ALL unused Docker data
```

---

# 💾 Backup & Maintenance

## Backup Database

### Option 1: Export Database
```powershell
cd C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\docker\all-in-one

# Create backup
docker compose exec postgres pg_dump -U postgres hi-events > backup_$(Get-Date -Format 'yyyy-MM-dd').sql
```

### Option 2: Copy Docker Volume
```powershell
# Stop containers
docker compose down

# Copy volume data
docker run --rm -v all-in-one_pgdata:/data -v C:\Backups:/backup alpine tar czf /backup/db-backup.tar.gz -C /data .

# Start containers
docker compose up -d
```

---

## Restore Database

```powershell
cd C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop\docker\all-in-one

# Stop containers
docker compose down

# Restore from backup file
cat backup_2026-09-06.sql | docker compose exec -T postgres psql -U postgres -d hi-events

# Start containers
docker compose up -d
```

---

## Update Hi.Events

```powershell
cd C:\Users\flynn\Downloads\Hi.Events-develop\Hi.Events-develop

# Pull latest code
git pull origin develop

# Rebuild containers
cd docker\all-in-one
docker compose down
docker compose up -d --build
```

---

# 📊 System Requirements

## Minimum:
- Windows 10/11
- 4GB RAM
- 10GB free disk space
- Docker Desktop

## Recommended:
- Windows 11
- 8GB+ RAM
- 20GB+ free disk space
- SSD storage
- Docker Desktop latest version

---

# 🔗 Important URLs

```
Main Application:     http://localhost:8123
Login Page:          http://localhost:8123/auth/login
Registration:        http://localhost:8123/auth/register
Super Admin:         http://localhost:8123/admin
Organizer Dashboard: http://localhost:8123/manage/events
```

---

# 📞 Support & Documentation

- **Official Docs:** https://hi.events/docs
- **GitHub:** https://github.com/HiEventsDev/hi.events
- **Issues:** https://github.com/HiEventsDev/hi.events/issues

---

# 📝 Quick Reference Card

```
╔══════════════════════════════════════════════════════════════╗
║                    QUICK REFERENCE                           ║
╠══════════════════════════════════════════════════════════════╣
║ PROJECT LOCATION:                                            ║
║ C:\Users\flynn\Downloads\Hi.Events-develop\                  ║
║     Hi.Events-develop\docker\all-in-one                      ║
║                                                              ║
║ START APP:                                                   ║
║ docker compose up -d                                         ║
║                                                              ║
║ STOP APP:                                                    ║
║ docker compose down                                          ║
║                                                              ║
║ VIEW LOGS:                                                   ║
║ docker compose logs -f                                       ║
║                                                              ║
║ SUPER ADMIN LOGIN:                                           ║
║ Email: admin@hievents.com                                    ║
║ Pass:  SuperAdmin2024                                        ║
║ URL:   http://localhost:8123/admin                           ║
║                                                              ║
║ ORGANIZER LOGIN:                                             ║
║ Email: organizer@test.com                                    ║
║ Pass:  User123456                                            ║
║ URL:   http://localhost:8123/manage/events                   ║
╚══════════════════════════════════════════════════════════════╝
```

---

# ✅ Post-Setup Checklist

After setup, verify:

- [ ] Docker Desktop is running
- [ ] All 3 containers are healthy (`docker compose ps`)
- [ ] Can access http://localhost:8123
- [ ] Can login as Super Admin
- [ ] Can access /admin dashboard
- [ ] Can login as Organizer
- [ ] Can see the 3 test events
- [ ] Can view the test order ($260)

---

# 🎉 You're All Set!

Your Hi.Events platform is now fully configured and ready to use!

**Next Steps:**
1. Login as Super Admin
2. Explore the platform
3. Test impersonation
4. Create more test events
5. Test ticket purchases
6. Check analytics

**Remember:**
- Super Admin = Platform owner (YOU)
- Organizer = Your customer (Event creators)
- You earn 10% + $0.50 from every ticket sold!

---

**Last Updated:** September 6, 2026  
**Setup By:** Kiro AI Assistant  
**Status:** ✅ Fully Operational
