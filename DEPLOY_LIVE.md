# Deploy Hi.Events Live with SUPERADMIN Feature

## Overview

To deploy your Hi.Events with the SUPERADMIN feature live, you have several options. Here are the best ones:

---

## Option 1: Deploy to Render (Recommended - FREE)

Render offers a free tier that's perfect for testing and small deployments.

### Steps:

**1. Push Your Changes to GitHub**

```powershell
# Make sure you're on your feature branch
cd C:\Hi.Events
git checkout feature/my-contribution

# Add all files
git add .

# Commit
git commit -m "Add SUPERADMIN SaaS feature and deployment configs"

# Push to your fork
git push myfork feature/my-contribution
```

**2. Go to Render.com**

- Visit: https://render.com/
- Sign up with your GitHub account (babaeli)
- Click "New" → "Blueprint"

**3. Connect Your Repository**

- Select `babaeli/Hi.Events`
- Select branch: `feature/my-contribution`
- Render will detect the configuration

**4. Configure Environment Variables**

You'll need to set these in Render's dashboard:

```env
# Generate new keys for production!
APP_KEY=base64:YOUR_NEW_KEY_HERE
JWT_SECRET=YOUR_NEW_JWT_SECRET_HERE

# Frontend URLs (Render will give you these after deploy)
VITE_FRONTEND_URL=https://your-app-name.onrender.com
VITE_API_URL_CLIENT=https://your-app-name.onrender.com/api
VITE_API_URL_SERVER=http://localhost:80/api

# Enable SaaS mode for SUPERADMIN
APP_SAAS_MODE_ENABLED=true
APP_DISABLE_REGISTRATION=false

# Stripe (use test keys for now)
STRIPE_PUBLIC_KEY=pk_test_your_key
STRIPE_SECRET_KEY=sk_test_your_key

# Email (configure later or use a service like Mailgun)
MAIL_MAILER=log
```

**5. Deploy**

- Click "Apply"
- Wait 5-10 minutes for deployment
- Render will give you a URL like: `https://hievents-xxx.onrender.com`

**6. Create SUPERADMIN via Render Shell**

Once deployed:
- Go to your Render dashboard
- Click on your service
- Click "Shell" tab
- Run:
```bash
cd backend
php artisan superadmin:create admin@yourdomain.com --first-name=Admin --last-name=Super
```

**7. Access Live**

Go to your Render URL and login with your SUPERADMIN credentials!

---

## Option 2: Deploy to Railway (Easy - Paid after trial)

Railway is super easy and gives you $5 free credit.

### Steps:

**1. Push Your Changes (same as above)**

**2. Go to Railway**

- Visit: https://railway.app/
- Sign up with GitHub
- Click "New Project" → "Deploy from GitHub repo"

**3. Select Your Repo**

- Choose `babaeli/Hi.Events`
- Branch: `feature/my-contribution`

**4. Configure Services**

Railway will auto-detect:
- PostgreSQL database
- Redis
- Your application

**5. Add Environment Variables**

Same as Render (see Option 1)

**6. Deploy and Access**

Railway will give you a URL automatically.

**7. Create SUPERADMIN**

Use Railway's CLI or dashboard shell to run the artisan command.

---

## Option 3: Deploy to Your Own VPS (DigitalOcean, AWS, etc.)

If you have a VPS or want full control:

### Requirements:
- Ubuntu 22.04+ server
- Domain name (optional but recommended)
- SSL certificate (Let's Encrypt is free)

### Quick Setup on Ubuntu:

**1. SSH into your server**

```bash
ssh root@your-server-ip
```

**2. Install Docker and Docker Compose**

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
apt-get install docker-compose-plugin -y
```

**3. Clone Your Repository**

```bash
git clone https://github.com/babaeli/Hi.Events.git
cd Hi.Events
git checkout feature/my-contribution
```

**4. Configure Environment**

```bash
cd docker/all-in-one
cp .env.example .env

# Generate keys
APP_KEY=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 32)

# Edit .env with your domain
nano .env
```

Update these values:
```env
VITE_FRONTEND_URL=https://yourdomain.com
VITE_API_URL_CLIENT=https://yourdomain.com/api
APP_SAAS_MODE_ENABLED=true
```

**5. Start Services**

```bash
docker compose up -d
```

**6. Set Up Nginx Reverse Proxy**

```bash
apt install nginx certbot python3-certbot-nginx -y

# Create Nginx config
nano /etc/nginx/sites-available/hievents
```

Add:
```nginx
server {
    listen 80;
    server_name yourdomain.com;

    location / {
        proxy_pass http://localhost:8123;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Enable and test:
```bash
ln -s /etc/nginx/sites-available/hievents /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx
```

**7. Get SSL Certificate**

```bash
certbot --nginx -d yourdomain.com
```

**8. Create SUPERADMIN**

```bash
docker compose exec all-in-one sh -c "cd /app/backend && php artisan superadmin:create admin@yourdomain.com"
```

**9. Access Live**

Visit `https://yourdomain.com`

---

## Option 4: Use Existing Deployment with Custom Build

Since the Docker image doesn't have your code yet, you need to build a custom image.

### Create Custom Dockerfile

**1. Create `Dockerfile.custom` in project root:**

```dockerfile
# Use the official Hi.Events base image
FROM daveearley/hi.events-all-in-one:latest

# Copy your custom command
COPY backend/app/Console/Commands/CreateSuperAdminCommand.php /app/backend/app/Console/Commands/

# Copy documentation
COPY docs/SUPERADMIN_*.md /app/docs/

# Set working directory
WORKDIR /app
```

**2. Build and Push Your Image**

```powershell
# Build
docker build -f Dockerfile.custom -t babaeli/hi.events-superadmin:latest .

# Login to Docker Hub (create account at hub.docker.com)
docker login

# Push
docker push babaeli/hi.events-superadmin:latest
```

**3. Update docker-compose.yml**

Change the image line:
```yaml
services:
  all-in-one:
    image: babaeli/hi.events-superadmin:latest  # Your custom image
```

**4. Deploy anywhere using this custom image**

---

## Quick Start: Test Deployment on Render (5 minutes)

**1. Push your changes:**
```powershell
cd C:\Hi.Events
git add .
git commit -m "Add SUPERADMIN feature for deployment"
git push myfork feature/my-contribution
```

**2. Go to Render:**
- https://render.com/
- Sign up with GitHub
- New → Blueprint
- Select `babaeli/Hi.Events`
- Branch: `feature/my-contribution`

**3. Wait for deployment (5-10 min)**

**4. Access Render Shell and create SUPERADMIN:**
```bash
cd backend
php artisan superadmin:create admin@test.com --first-name=Admin
```

**5. Login at your Render URL!**

---

## After Deployment: Creating SUPERADMIN Users

Regardless of where you deploy, you'll need to access the server's shell:

### On Render:
Dashboard → Your Service → Shell tab

### On Railway:
Use Railway CLI: `railway run php artisan superadmin:create email@domain.com`

### On VPS:
SSH into server, then: `docker compose exec all-in-one sh -c "cd /app/backend && php artisan superadmin:create email@domain.com"`

### The Command:
```bash
php artisan superadmin:create admin@yourdomain.com --first-name=Admin --last-name=Super
```

---

## Environment Variables for Production

Always use these for production:

```env
# App
APP_ENV=production
APP_DEBUG=false
APP_KEY=base64:YOUR_PRODUCTION_KEY  # MUST be different from dev!
JWT_SECRET=YOUR_PRODUCTION_JWT_SECRET  # MUST be different from dev!

# URLs - Update with your domain
VITE_FRONTEND_URL=https://yourdomain.com
VITE_API_URL_CLIENT=https://yourdomain.com/api
APP_FRONTEND_URL=https://yourdomain.com

# SaaS Mode
APP_SAAS_MODE_ENABLED=true
APP_DISABLE_REGISTRATION=false  # or true if you want invite-only

# Database - Use production credentials
DATABASE_URL=postgresql://user:password@host:5432/dbname

# Redis - Use production credentials
REDIS_HOST=your-redis-host
REDIS_PASSWORD=your-redis-password

# Stripe - Use LIVE keys for real payments
STRIPE_PUBLIC_KEY=pk_live_your_key
STRIPE_SECRET_KEY=sk_live_your_key

# Email - Use real email service
MAIL_MAILER=smtp
MAIL_HOST=smtp.yourprovider.com
MAIL_PORT=587
MAIL_USERNAME=your-email
MAIL_PASSWORD=your-password
MAIL_FROM_ADDRESS=noreply@yourdomain.com
```

---

## Generate Production Keys

**On Windows PowerShell:**
```powershell
$rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
$bytes1 = New-Object byte[] 32
$bytes2 = New-Object byte[] 32
$rng.GetBytes($bytes1)
$rng.GetBytes($bytes2)
Write-Output "APP_KEY=base64:$([Convert]::ToBase64String($bytes1))"
Write-Output "JWT_SECRET=$([Convert]::ToBase64String($bytes2))"
```

**On Linux/Mac:**
```bash
echo "APP_KEY=base64:$(openssl rand -base64 32)"
echo "JWT_SECRET=$(openssl rand -base64 32)"
```

---

## Recommended: Render Free Tier

**Pros:**
- ✅ Free tier available
- ✅ Auto-deploy from GitHub
- ✅ Built-in PostgreSQL
- ✅ SSL included
- ✅ Easy shell access for SUPERADMIN creation
- ✅ Good for testing/demo

**Cons:**
- ⚠️ Spins down after inactivity (takes 30s to wake up)
- ⚠️ Limited resources on free tier

**Perfect for:**
- Testing your SUPERADMIN feature
- Demo to stakeholders
- Development/staging environment

---

## Next Steps

1. **Choose your deployment platform** (I recommend Render for quick start)
2. **Push your code to GitHub**
3. **Deploy to chosen platform**
4. **Create SUPERADMIN users via platform shell**
5. **Access your live application!**

**Need help with any specific platform? Let me know!**
