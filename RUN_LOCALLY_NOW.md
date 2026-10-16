# 🚀 Run Hi.Events Locally - QUICK START

## ⚡ Super Fast Setup (5 Minutes)

### Step 1: Start Docker Desktop
1. **Open Docker Desktop** (if installed)
   - Look for Docker icon in Windows taskbar
   - Or search "Docker Desktop" in Start menu
   - Wait for Docker to start (icon will be steady, not animated)

**Don't have Docker?**
- Download: https://www.docker.com/products/docker-desktop
- Install it (takes 5 minutes)
- Restart computer if prompted
- Start Docker Desktop

---

### Step 2: Start Hi.Events (One Command!)
Open PowerShell in this folder and run:

```powershell
cd docker/all-in-one
docker compose up -d
```

**What happens:**
```
Creating network...
Creating postgres container...    ✅
Creating redis container...       ✅
Creating all-in-one container...  ✅
Starting services...
Hi.Events is now running!
```

**Time:** 2-3 minutes first time, 30 seconds after that

---

### Step 3: Access Your Local Site
**Open browser and go to:** http://localhost:8123

✅ You should see the Hi.Events homepage!

---

### Step 4: Login as SUPERADMIN

**We already created this account for you before!**

**Go to:** http://localhost:8123/auth/login

**Credentials:**
- **Email:** `admin@hievents.com`
- **Password:** `SuperAdmin2026!`

✅ Click Login - you're in!

---

### Step 5: Test Everything Works

#### Create a Test Event
1. After login, click **"Manage"** → **"Events"**
2. Click **"Create Event"**
3. Fill in:
   - **Title:** "Local Test Event"
   - **Start Date:** Tomorrow
   - **Location:** "Test Venue"
4. Click **"Save"**

#### Test the URLs (THE FIX!)
1. In events list, click **"View Event"**
2. **Check the URL:**
   - ✅ Should be: `http://localhost:8123/event/1/local-test-event`
   - ✅ Should load correctly

#### Upload an Image
1. Edit your event
2. Upload an event image
3. Save and view the event
4. ✅ Image should display

---

## 🎯 You're Running Locally!

**Your Local URLs:**
- **Homepage:** http://localhost:8123
- **Login:** http://localhost:8123/auth/login
- **Admin Dashboard:** http://localhost:8123/manage
- **API:** http://localhost:8123/api

**Services Running:**
- ✅ **Nginx** - Web server (port 8123)
- ✅ **PHP-FPM** - Backend API (Laravel)
- ✅ **Node.js** - Frontend SSR (React)
- ✅ **PostgreSQL** - Database
- ✅ **Redis** - Cache
- ✅ **Queue Worker** - Background jobs

---

## 📋 Useful Commands

### Check if containers are running:
```powershell
cd docker/all-in-one
docker compose ps
```

Should show:
```
NAME                    STATUS
all-in-one              Up (healthy)
postgres                Up (healthy)
redis                   Up (healthy)
```

### Stop the app:
```powershell
docker compose down
```

### Start the app again:
```powershell
docker compose up -d
```

### View logs (if something's wrong):
```powershell
docker compose logs -f
```
(Press Ctrl+C to stop viewing)

### Restart the app:
```powershell
docker compose restart
```

### Check database has data:
```powershell
docker compose exec postgres psql -U postgres -d hi-events -c "SELECT * FROM users;"
```

---

## 🐛 Troubleshooting

### Issue: "Docker is not running"
**Solution:**
1. Start Docker Desktop
2. Wait for it to fully start (30-60 seconds)
3. Try the `docker compose up -d` command again

### Issue: "Port 8123 is already in use"
**Solution:**
1. Stop any other services using port 8123
2. Or change the port in `docker/all-in-one/docker-compose.yml`:
   ```yaml
   ports:
     - "8124:80"  # Changed to 8124
   ```
3. Then access at: http://localhost:8124

### Issue: "Cannot login"
**Solution:**
1. Check containers are running: `docker compose ps`
2. Create admin account again:
   ```powershell
   docker compose exec all-in-one sh -c "cd /app/backend && php artisan tinker"
   ```
   Then in tinker:
   ```php
   $user = User::where('email', 'admin@hievents.com')->first();
   $user->password = bcrypt('SuperAdmin2026!');
   $user->save();
   ```

### Issue: Page shows "Service Unavailable"
**Solution:**
1. Wait 30 seconds (services starting up)
2. Check logs: `docker compose logs -f`
3. Look for errors
4. Restart: `docker compose restart`

### Issue: Database connection error
**Solution:**
1. Check postgres is running: `docker compose ps postgres`
2. Should show "Up (healthy)"
3. If not, restart: `docker compose restart postgres`
4. Wait 10 seconds, try again

---

## 🎨 Local vs Public Deployment

**Local (what you're running now):**
- URL: `http://localhost:8123`
- Database: Local PostgreSQL container
- Fast development, instant changes
- Only accessible from your computer

**Public (Render/Koyeb):**
- URL: `https://your-app.onrender.com`
- Database: Hosted PostgreSQL
- Accessible from anywhere
- Share with others

**Both use the same code!** The fix we made works on both! 🎉

---

## 🔄 Making Changes

### Edit Backend Code
1. Make changes in `backend/` folder
2. Changes apply immediately (volume mounted)
3. If needed, restart: `docker compose restart`

### Edit Frontend Code
1. Make changes in `frontend/` folder
2. Frontend rebuilds automatically
3. Refresh browser to see changes

### Add Environment Variables
1. Edit: `docker/all-in-one/.env`
2. Restart: `docker compose down && docker compose up -d`

---

## 📊 System Requirements

**Minimum:**
- Windows 10/11 (64-bit)
- 4GB RAM
- 10GB free disk space
- Docker Desktop installed

**Recommended:**
- 8GB RAM
- 20GB free disk space
- SSD for faster performance

---

## ✅ Quick Test Checklist

After starting locally, verify:

- [ ] Docker containers running (3 total)
- [ ] Can access http://localhost:8123
- [ ] Can login with admin@hievents.com
- [ ] Can create events
- [ ] Can view events
- [ ] Images upload and display
- [ ] URLs work correctly

---

## 🎯 What's Next?

### Option 1: Develop Locally
- Make changes to code
- Test immediately
- See results at localhost:8123

### Option 2: Deploy to Public Domain
- Follow `DEPLOY_TO_RENDER_NOW.md`
- Get a public URL
- Share with others

### Option 3: Both!
- Develop locally (fast iteration)
- Deploy to test publicly (share with team)
- Best of both worlds! 🎉

---

## 📚 More Info

- **Docker compose file:** `docker/all-in-one/docker-compose.yml`
- **Environment variables:** `docker/all-in-one/.env`
- **Nginx config:** `docker/all-in-one/nginx/nginx.conf`
- **Full setup guide:** `RUNNING_THE_PROJECT.md`

---

## 💡 Pro Tips

1. **Keep Docker Desktop running** while developing
2. **Use logs** to debug issues: `docker compose logs -f`
3. **Restart services** if changes don't apply
4. **Check container health** regularly: `docker compose ps`
5. **Database persists** even when stopped (your data is safe!)

---

## 🎉 You're Ready!

Run these two commands:

```powershell
cd docker/all-in-one
docker compose up -d
```

Then open: http://localhost:8123

**That's it! You're running Hi.Events locally!** 🚀

---

**Questions? Issues? Check the troubleshooting section above!**
