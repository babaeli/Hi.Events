# 🚀 Deploy Your Own Public Hi.Events Instance - QUICK START

## 🎯 Goal
Deploy Hi.Events to a public domain so you can test the username/links fix yourself!

---

## ⚡ FASTEST METHOD: Render.com (5 minutes)

### Why Render?
- ✅ **100% FREE** tier available
- ✅ Automatic HTTPS domain (no SSL setup needed)
- ✅ PostgreSQL database included free
- ✅ Redis included free
- ✅ Auto-deploys from GitHub
- ✅ Already configured in your `render.yaml`

---

## 📋 Step-by-Step Deployment

### Step 1: Create Render Account
1. Go to: https://render.com
2. Click **"Get Started"** or **"Sign Up"**
3. Sign up with GitHub (easiest - one click)
4. ✅ Authorize Render to access your repositories

### Step 2: Connect Your Repository
1. After login, you'll be at: https://dashboard.render.com
2. Click **"New +"** button (top right)
3. Select **"Blueprint"** (this uses your render.yaml file)
4. Connect your GitHub account if not already connected
5. Search for: `babaeli/Hi.Events`
6. Click **"Connect"**

### Step 3: Configure Blueprint
1. Render will detect your `render.yaml` file automatically
2. **Service Group Name:** `hi-events` (or whatever you prefer)
3. **Branch:** `feature/my-contribution` ⚠️ **IMPORTANT: Select YOUR branch!**
4. Click **"Apply"**

### Step 4: Wait for Deployment
Render will now create:
- ✅ Web service (hi-events)
- ✅ PostgreSQL database
- ✅ Redis cache

**Time:** 5-8 minutes for first deployment

You'll see:
```
Building Docker image...
Deploying...
Running migrations...
Service is live!
```

### Step 5: Get Your Public URL
1. Once deployed, you'll see: **"Service is live"**
2. Your URL will be: `https://hi-events-XXXXX.onrender.com`
3. **COPY THIS URL** - you'll need it!

### Step 6: Update Environment Variables (CRITICAL!)
⚠️ **This is the FIX we just made - you need to update these with YOUR URL!**

1. In Render dashboard, click your **"hi-events"** service
2. Go to **"Environment"** tab (left sidebar)
3. Find these variables and **UPDATE** them with your actual Render URL:

**UPDATE THESE 4 VARIABLES:**
```
VITE_FRONTEND_URL = https://hi-events-XXXXX.onrender.com
APP_URL = https://hi-events-XXXXX.onrender.com
APP_FRONTEND_URL = https://hi-events-XXXXX.onrender.com
APP_CDN_URL = https://hi-events-XXXXX.onrender.com/storage
```

(Replace `hi-events-XXXXX.onrender.com` with your actual URL from Step 5)

4. Click **"Save Changes"**
5. Render will automatically redeploy (2-3 minutes)

### Step 7: Create SUPERADMIN Account
Once deployed, you need to create your admin account:

**Option 1: Via Render Shell**
1. In Render dashboard, go to your service
2. Click **"Shell"** tab (left sidebar)
3. Wait for shell to connect
4. Run these commands:
```bash
# Check database is ready
php artisan migrate:status

# Create your SUPERADMIN account
php artisan db:seed --class=DatabaseSeeder

# Or create custom super admin
cd /app/backend
php artisan setup:create-super-admins
```

**Option 2: Direct Database Update (Faster)**
1. Go to your PostgreSQL database in Render
2. Click **"Connect"** → **"External Connection"**
3. Copy the connection details
4. Use a PostgreSQL client (like pgAdmin or DBeaver) to connect
5. Run this SQL:
```sql
-- First, create a test user
INSERT INTO users (email, password, first_name, last_name, email_verified_at, created_at, updated_at)
VALUES (
  'your-email@example.com',
  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: password
  'Your',
  'Name',
  NOW(),
  NOW(),
  NOW()
);

-- Get the user ID (should be 1 if this is first user)
-- Then create account and link to user
INSERT INTO accounts (name, email, created_at, updated_at)
VALUES ('Your Organization', 'your-email@example.com', NOW(), NOW());

-- Link user to account as SUPERADMIN
INSERT INTO account_users (account_id, user_id, role, created_at, updated_at)
VALUES (1, 1, 'SUPERADMIN', NOW(), NOW());
```

---

## 🧪 Test Your Deployment

### Test 1: Access the Site
1. Go to: `https://hi-events-XXXXX.onrender.com`
2. ✅ You should see the Hi.Events homepage
3. ✅ Should load with HTTPS (secure)

### Test 2: Login as SUPERADMIN
1. Go to: `https://hi-events-XXXXX.onrender.com/auth/login`
2. Email: `your-email@example.com`
3. Password: `password` (or whatever you set)
4. ✅ Should login successfully

### Test 3: Create an Event
1. After login, go to **"Manage"** → **"Events"**
2. Click **"Create Event"**
3. Fill in basic details:
   - Title: "Test Summer Festival"
   - Date: Tomorrow
   - Location: "Test Venue"
4. Click **"Save"**

### Test 4: Test the USERNAME/LINKS FIX 🎯
1. In admin panel, click **"View Event"** button
2. **CHECK THE URL** - This is what we fixed!
3. ✅ URL should be: `https://hi-events-XXXXX.onrender.com/event/1/test-summer-festival`
4. ❌ Should NOT be: `http://localhost/event/1/...`

### Test 5: Test Organizer Links
1. On the public event page, click your organizer name
2. ✅ URL should be: `https://hi-events-XXXXX.onrender.com/organizer/1/...`
3. ✅ Should load correctly with your public domain

### Test 6: Test Image Upload
1. Go back to admin panel
2. Edit your test event
3. Upload an event image
4. Save and view public event
5. Right-click the image → "Open in new tab"
6. ✅ Image URL should be: `https://hi-events-XXXXX.onrender.com/storage/events/...`
7. ✅ Image should load (not 404)

---

## 🎉 SUCCESS CRITERIA

If all these work, your deployment is PERFECT:
- ✅ Site loads on public domain
- ✅ Can login as SUPERADMIN
- ✅ Can create events
- ✅ **Event URLs use your public domain (NOT localhost)**
- ✅ **Organizer URLs use your public domain**
- ✅ **Images load from your public domain**
- ✅ No "localhost" anywhere in the app

**This proves the USERNAME/LINKS fix works!** 🎉

---

## 🔄 Alternative: Koyeb (Also 100% Free)

If you want to try Koyeb instead (it's faster and has better free tier):

### Step 1: Create Koyeb Account
1. Go to: https://www.koyeb.com
2. Sign up (free)
3. Verify email

### Step 2: Deploy from GitHub
1. Click **"Create Service"**
2. Select **"GitHub"**
3. Connect your repository: `babaeli/Hi.Events`
4. Branch: `feature/my-contribution`
5. **Builder:** Docker
6. **Dockerfile:** `Dockerfile.koyeb`
7. Click **"Deploy"**

### Step 3: Update Environment Variables
Same as Render - update these 4 variables with your Koyeb URL:
```
VITE_FRONTEND_URL = https://hi-events-XXXXX.koyeb.app
APP_URL = https://hi-events-XXXXX.koyeb.app
APP_FRONTEND_URL = https://hi-events-XXXXX.koyeb.app
APP_CDN_URL = https://hi-events-XXXXX.koyeb.app/storage
```

---

## ⚠️ Important Notes

### 1. First Deployment Takes Time
- Render: 5-8 minutes
- Koyeb: 3-5 minutes
- Be patient, Docker image is large!

### 2. Free Tier Limitations
**Render Free Tier:**
- Sleeps after 15 min inactivity
- Wakes up in ~30 seconds on first request
- 750 hours/month (plenty for testing)

**Koyeb Free Tier:**
- No sleep! Stays active 24/7
- Faster performance
- 5GB egress/month

### 3. Environment Variables Are Critical
The fix we made **requires** those 4 environment variables to be set with your actual domain. Without them, you'll see the "localhost" problem again!

### 4. Database Persistence
Both Render and Koyeb free tiers have persistent databases. Your data won't disappear!

---

## 🐛 Troubleshooting

### Issue: Build fails with "Out of memory"
**Solution:** Koyeb has more memory in free tier, try that instead

### Issue: "Service Unavailable" after deployment
**Solution:** Wait 1-2 more minutes, migrations might still be running

### Issue: Can't login after deployment
**Solution:** Make sure you created the SUPERADMIN account (Step 7)

### Issue: Still seeing "localhost" in URLs
**Solution:** 
1. Verify environment variables are set correctly
2. Make sure you redeployed AFTER setting them
3. Clear browser cache
4. Check the variables are set during BUILD time (not just runtime)

### Issue: Images return 404
**Solution:** 
1. Verify `APP_CDN_URL` is set
2. Upload a new image after setting the variable
3. Old images might have wrong URLs cached

---

## 📊 Cost Comparison

| Platform | Free Tier | Database | Redis | Custom Domain | Sleep Policy |
|----------|-----------|----------|-------|---------------|--------------|
| **Render** | ✅ Yes | ✅ Free PostgreSQL | ✅ Free Redis | ✅ Yes | Sleeps after 15min |
| **Koyeb** | ✅ Yes | ✅ Free PostgreSQL | ✅ Free Redis | ✅ Yes | ❌ No sleep! |
| **Vercel** | ✅ Yes | ❌ Need external | ❌ Need external | ✅ Yes | ❌ No sleep |
| **Railway** | ⚠️ $5 credit | ✅ Free PostgreSQL | ✅ Free Redis | ✅ Yes | ❌ No sleep |

**Recommendation:** Start with **Koyeb** (fastest, no sleep) or **Render** (easiest setup)

---

## 🎯 Next Steps

After successful deployment:

1. ✅ Share your public URL with Damarice to show the fix works
2. ✅ Test all the features we fixed:
   - Event URLs
   - Organizer profile links
   - Image loading
   - Checkout URLs
3. ✅ Create a PR from your branch to Damarice's main branch
4. ✅ Help Damarice update her deployment with the same environment variables

---

## 📚 Resources

- **Render Docs:** https://render.com/docs
- **Koyeb Docs:** https://www.koyeb.com/docs
- **Your render.yaml:** Already configured in project root
- **Your koyeb.yml:** Already configured in project root
- **Troubleshooting:** Check `FIX_USERNAME_LINKS.md` for detailed info

---

## ✅ Quick Command Reference

**Check if deployment is healthy:**
```bash
# Via Render Shell or Koyeb SSH
php artisan migrate:status
php artisan config:cache
php artisan route:list | grep api
```

**Create SUPERADMIN:**
```bash
php artisan setup:create-super-admins
```

**Check logs:**
```bash
tail -f /var/log/nginx/error.log
tail -f storage/logs/laravel.log
```

---

**Ready to deploy? Pick Render or Koyeb and follow the steps above!** 🚀

**Questions? Check the docs or ask me!** 😊
