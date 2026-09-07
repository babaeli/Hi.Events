# 🔐 Super Admin Setup Guide

## Overview
This guide will help you set up a **Super Admin account** to access the platform dashboard where you can see ALL users, events, orders, and revenue across your entire Hi.Events platform.

---

## 🚀 Quick Setup (3 Steps)

### **Step 1: Create Your Account**

1. Open your browser and go to: **http://localhost:8123/auth/register**
2. Fill in the registration form:
   - **Email**: Use your email (e.g., `admin@yourdomain.com`)
   - **Password**: Choose a strong password
   - **First Name**: Your first name
   - **Last Name**: Your last name
3. Click **Register**

After registration, **note down your User ID** (you'll see it in the URL or can check the database).

---

### **Step 2: Find Your User ID**

You need your User ID to promote yourself to Super Admin. Here are two ways to find it:

#### **Option A: Check the Database** (Easiest)
```powershell
# Run this command from the docker/all-in-one directory
docker compose exec postgres psql -U postgres -d hi-events -c "SELECT id, email, first_name, last_name FROM users ORDER BY id DESC LIMIT 5;"
```

This will show the most recent users. Find your email and note the `id` number.

#### **Option B: Check the Users Table**
```powershell
docker compose exec postgres psql -U postgres -d hi-events
```
Then run:
```sql
SELECT id, email, first_name, last_name FROM users;
\q
```

---

### **Step 3: Promote to Super Admin**

Once you have your User ID, run this command (replace `USER_ID` with your actual ID):

```powershell
# From the docker/all-in-one directory
docker compose exec all-in-one php artisan user:make-superadmin USER_ID
```

**Example:**
```powershell
docker compose exec all-in-one php artisan user:make-superadmin 1
```

You'll see warning messages - type `yes` twice to confirm.

✅ **Done!** You are now a Super Admin!

---

## 🎯 Accessing Super Admin Dashboard

### **Super Admin Dashboard URL**
**http://localhost:8123/admin**

### **What You Can See:**

1. **📊 Platform Statistics**
   - Total revenue across all organizers
   - Total number of accounts/organizers
   - Total events created
   - Total orders placed

2. **👥 All Accounts/Organizers**
   - See every event organizer who signs up
   - View their details and statistics
   - Impersonate users (login as them)
   - Manage their settings

3. **🎟️ All Events**
   - See all events across all organizers
   - Event details and statistics
   - Ticket sales information

4. **💰 All Orders**
   - Complete order history across platform
   - Revenue tracking
   - Payment details

5. **⚙️ System Management**
   - Failed jobs monitoring
   - System information
   - Platform configurations
   - Messaging tiers

6. **📧 Messages**
   - View all messages sent through platform
   - Approve/manage bulk messages

---

## 🔧 SaaS Mode Configuration

SaaS Mode is now **ENABLED** in your installation. This means:

✅ **Platform Fees**: When organizers receive payments, you can collect a platform fee
- **Percentage Fee**: 10% (configurable in `.env`)
- **Fixed Fee**: $0.50 per transaction (configurable in `.env`)

### **To Change Platform Fees:**

Edit the `.env` file in `docker/all-in-one/.env`:

```env
APP_SAAS_MODE_ENABLED=true
APP_SAAS_STRIPE_APPLICATION_FEE_PERCENT=10    # 10% platform fee
APP_SAAS_STRIPE_APPLICATION_FEE_FIXED=50      # $0.50 fixed fee (in cents)
```

Then restart:
```powershell
docker compose restart
```

---

## 🧪 Testing Multi-Tenant Features

### **Create Test Organizers:**

1. **Logout** from your super admin account
2. Go to **http://localhost:8123/auth/register**
3. Create a **new organizer account** with a different email
4. Create some events and tickets
5. **Logout** and **login** as your super admin
6. Go to **http://localhost:8123/admin** and see all organizers and their events!

### **Impersonate Users:**

As a Super Admin, you can "login as" any organizer:
1. Go to **Admin Dashboard** → **Accounts**
2. Click on any organizer
3. Click **"Impersonate"** button
4. You'll be logged in as that organizer
5. To stop impersonation, click **"Stop Impersonating"** button

---

## 📋 Useful Commands

### **Check Container Status**
```powershell
docker compose ps
```

### **View Application Logs**
```powershell
docker compose logs -f all-in-one
```

### **Access Database**
```powershell
docker compose exec postgres psql -U postgres -d hi-events
```

### **List All Users**
```sql
SELECT id, email, first_name, last_name, created_at FROM users;
```

### **Check User Roles**
```sql
SELECT u.id, u.email, au.role, a.name as account_name 
FROM users u 
JOIN account_users au ON u.id = au.user_id 
JOIN accounts a ON au.account_id = a.id;
```

### **Restart Application**
```powershell
docker compose restart
```

---

## ⚠️ Important Security Notes

1. **Super Admin Power**: Super Admin has COMPLETE access to:
   - All accounts and organizers
   - All events and attendee data
   - All financial information
   - System configurations

2. **Production Usage**: 
   - Use a **strong password** for super admin accounts
   - Limit the number of super admin accounts
   - Monitor super admin activities via logs
   - Consider 2FA for production (requires custom implementation)

3. **User Privacy**:
   - Be mindful when impersonating users
   - All impersonation activities are logged
   - Use impersonation only for support purposes

---

## 🔐 Current Configuration

### **Application Settings**
- **App URL**: http://localhost:8123
- **SaaS Mode**: ENABLED ✅
- **Registration**: ENABLED (anyone can sign up as organizer)
- **Platform Fee**: 10% + $0.50 per transaction

### **Email Settings**
- **Mail Driver**: log (emails saved to logs, not sent)
- For production, configure SMTP settings in `.env`

### **Payment Settings**
- **Stripe**: Test mode (test keys configured)
- Update with real Stripe keys for production

---

## 🎉 You're All Set!

Your platform is now running in **multi-tenant SaaS mode** with:
- ✅ Super Admin dashboard access
- ✅ Multi-organizer support
- ✅ Platform fee collection
- ✅ User impersonation
- ✅ Complete platform oversight

**Next Steps:**
1. Create your super admin account
2. Access the admin dashboard
3. Create test organizer accounts
4. Explore the features!

---

## 🆘 Need Help?

If you encounter any issues:

1. **Check logs**: `docker compose logs -f`
2. **Restart containers**: `docker compose restart`
3. **Verify database**: Access postgres and check tables
4. **Check GitHub**: [Hi.Events Documentation](https://hi.events/docs)

---

**Happy Event Managing! 🎟️**
