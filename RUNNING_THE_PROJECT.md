# Running Hi.Events with Your SUPERADMIN Feature

## Your Git Setup

You're now working with just two repositories:
- **origin**: Damarice/Hi.Events (main repository)
- **myfork**: babaeli/Hi.Events (your fork)

### Current Branch
- `feature/my-contribution` (with your SUPERADMIN command)

### Workflow
1. Make changes on `feature/my-contribution`
2. Push to your fork: `git push myfork feature/my-contribution`
3. Create PR from `babaeli/Hi.Events` to `Damarice/Hi.Events`

---

## Running the Application

### Prerequisites
✅ Docker Desktop installed
✅ Docker Compose installed
✅ Keys generated in `.env` file

### Step 1: Start Docker Desktop

**Windows:**
1. Press Windows key
2. Search for "Docker Desktop"
3. Click to launch
4. Wait for Docker icon in system tray to show "Docker Desktop is running"

### Step 2: Start the Application

Open PowerShell in the project directory and run:

```powershell
cd C:\Hi.Events\docker\all-in-one
docker compose up -d
```

This will start:
- **PostgreSQL** database
- **Redis** cache
- **Hi.Events backend** (Laravel API)
- **Hi.Events frontend** (React)
- **Nginx** web server

### Step 3: Wait for Startup

Give it 30-60 seconds for all containers to be ready.

Check the status:
```powershell
docker compose ps
```

All services should show as "running" or "healthy".

### Step 4: Access the Application

Open your browser and go to:
```
http://localhost:8123
```

You should see the Hi.Events registration page!

---

## Testing Your SUPERADMIN Feature

### 1. Create a Regular Account

1. Go to `http://localhost:8123`
2. Click "Register" or "Create Account"
3. Fill in your details
4. This will create a regular account

### 2. Access the Backend Container

```powershell
cd C:\Hi.Events\docker\all-in-one
docker compose exec app bash
```

You're now inside the backend container!

### 3. Create Your First SUPERADMIN

Inside the container, run:

```bash
php artisan superadmin:create admin@yourdomain.com --first-name="Super" --last-name="Admin"
```

You'll be prompted for a password. Enter something secure.

### 4. Create Your Second SUPERADMIN

```bash
php artisan superadmin:create support@yourdomain.com --first-name="Support" --last-name="Team"
```

### 5. Exit the Container

```bash
exit
```

### 6. Test Login

1. Go to `http://localhost:8123`
2. Click "Login"
3. Use your SUPERADMIN credentials:
   - Email: `admin@yourdomain.com`
   - Password: (what you entered)

---

## What Your SUPERADMIN Can Do

Once logged in as SUPERADMIN, you'll have access to:

### Admin Dashboard
- View all accounts on the platform
- System-wide statistics
- Revenue and growth metrics

### Account Management
- Manually verify accounts
- Update account settings
- Control messaging tiers

### User Management
- Impersonate any user for support
- View user activity logs
- Manage user roles

### Content Moderation
- Review and approve spam events
- Manage platform announcements
- Review flagged messages

---

## Making Changes and Testing

### 1. Make Your Changes

Edit files in your favorite code editor (VS Code, PHPStorm, etc.):
- Backend code: `C:\Hi.Events\backend\`
- Frontend code: `C:\Hi.Events\frontend\`
- Your SUPERADMIN command: `C:\Hi.Events\backend\app\Console\Commands\CreateSuperAdminCommand.php`

### 2. Rebuild After Backend Changes

If you modify PHP code:

```powershell
cd C:\Hi.Events\docker\all-in-one
docker compose restart app
```

### 3. Test Your Changes

If you modified the SUPERADMIN command:

```powershell
# Access the container
docker compose exec app bash

# Test your command
php artisan superadmin:create test@example.com --first-name="Test" --last-name="User"

# Exit
exit
```

### 4. Commit Your Changes

```powershell
cd C:\Hi.Events
git status
git add .
git commit -m "Your commit message"
```

### 5. Push to Your Fork

```powershell
git push myfork feature/my-contribution
```

### 6. Create Pull Request

1. Go to: https://github.com/babaeli/Hi.Events
2. You'll see a prompt to create a PR
3. Create PR to Damarice/Hi.Events

---

## Useful Commands

### View Logs

```powershell
# All services
docker compose logs -f

# Just the app
docker compose logs -f app

# Last 100 lines
docker compose logs --tail=100 app
```

### Stop the Application

```powershell
cd C:\Hi.Events\docker\all-in-one
docker compose down
```

### Restart Everything

```powershell
docker compose restart
```

### Reset Database (Clean Start)

```powershell
docker compose down -v
docker compose up -d
```

This will delete all data and start fresh!

### Access Database Directly

```powershell
docker compose exec postgres psql -U postgres -d hi-events
```

Then run SQL commands:
```sql
-- View all users
SELECT id, email, first_name, last_name FROM users;

-- View SUPERADMIN accounts
SELECT u.email, au.role, au.status
FROM users u
JOIN account_users au ON u.id = au.user_id
WHERE au.role = 'SUPERADMIN';

-- Exit
\q
```

---

## Environment Configuration

Your `.env` file is at: `C:\Hi.Events\docker\all-in-one\.env`

Key settings:
- **APP_SAAS_MODE_ENABLED=true** - Enables SaaS features (manual verification, SUPERADMIN controls)
- **APP_DISABLE_REGISTRATION=false** - Allows public registration
- **VITE_FRONTEND_URL** - Frontend URL (http://localhost:8123)

---

## Troubleshooting

### "Cannot connect to Docker API"
→ Start Docker Desktop and wait for it to fully launch

### "Port 8123 already in use"
→ Change the port in `docker-compose.yml`:
```yaml
ports:
  - "8124:80"  # Use 8124 instead
```
Then access: `http://localhost:8124`

### "Database connection failed"
→ Wait 30 seconds for PostgreSQL to fully start
→ Check logs: `docker compose logs postgres`

### "Command not found: php artisan"
→ Make sure you're inside the container:
```powershell
docker compose exec app bash
```

### Changes not reflecting
→ Clear browser cache (Ctrl+Shift+R)
→ Restart app: `docker compose restart app`

### See full error logs
```powershell
# Backend logs
docker compose logs app --tail=100 -f

# Frontend logs
docker compose logs frontend --tail=100 -f
```

---

## Development Workflow Summary

```
1. Start Docker Desktop
   ↓
2. Start containers: docker compose up -d
   ↓
3. Access application: http://localhost:8123
   ↓
4. Make changes to code
   ↓
5. Test changes (restart if needed)
   ↓
6. Commit: git add . && git commit -m "message"
   ↓
7. Push: git push myfork feature/my-contribution
   ↓
8. Create PR: babaeli → Damarice
```

---

## Quick Test of SUPERADMIN Feature

```powershell
# 1. Access container
cd C:\Hi.Events\docker\all-in-one
docker compose exec app bash

# 2. Create SUPERADMIN
php artisan superadmin:create admin@test.com --first-name="Admin"

# 3. Verify creation
php artisan tinker
>>> \App\Models\User::with('accounts')->whereHas('accounts', function($q) {
...     $q->where('role', 'SUPERADMIN');
... })->get();

# 4. Exit tinker
>>> exit

# 5. Exit container
exit
```

---

## Your Files Location

- **Project root**: `C:\Hi.Events\`
- **Backend code**: `C:\Hi.Events\backend\`
- **Frontend code**: `C:\Hi.Events\frontend\`
- **SUPERADMIN command**: `C:\Hi.Events\backend\app\Console\Commands\CreateSuperAdminCommand.php`
- **Docker config**: `C:\Hi.Events\docker\all-in-one\`
- **Environment**: `C:\Hi.Events\docker\all-in-one\.env`

---

## Need Help?

Check the logs:
```powershell
docker compose logs --tail=50
```

Check service status:
```powershell
docker compose ps
```

Restart everything:
```powershell
docker compose restart
```

Full reset (deletes all data):
```powershell
docker compose down -v
docker compose up -d
```

---

**You're all set! Start Docker Desktop and run `docker compose up -d` to get started! 🚀**
