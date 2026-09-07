# 🔐 Login Credentials Template

## ⚠️ For Security Reasons

Actual credentials are stored locally in `ADMIN_CREDENTIALS.txt` (not in git).

This template shows the structure of credentials you need to set up.

---

## 👑 Super Admin Account (Platform Owner)

```
📧 Email:    [Your admin email]
🔑 Password: [Your secure password]
```

**Login URL:** http://localhost:8123/auth/login  
**Admin Dashboard:** http://localhost:8123/admin

**Capabilities:**
- ✅ View ALL organizers and accounts
- ✅ View ALL events across platform
- ✅ Platform-wide analytics
- ✅ Impersonate any user
- ✅ Earn platform fees

---

## 👥 Event Organizer Account (Test User)

```
📧 Email:    [Organizer test email]
🔑 Password: [Organizer password]
```

**Login URL:** http://localhost:8123/auth/login  
**Dashboard:** http://localhost:8123/manage/events

**Capabilities:**
- ✅ Create and manage own events
- ✅ Sell tickets
- ✅ Manage attendees
- ✅ View own analytics

---

## 🔐 How to Create These Accounts

See `SUPER_ADMIN_SETUP.md` for detailed instructions on creating:
1. Super Admin account
2. Organizer accounts
3. Setting up proper roles and permissions

---

## 📝 Important Notes

- Keep actual credentials secure and private
- Don't commit real credentials to GitHub
- Use strong passwords for production
- Change default credentials after setup
- Store credentials in a password manager

---

## 🔑 Environment Variables

Your `.env` file should contain:
```env
APP_KEY=[Generate with: php artisan key:generate]
JWT_SECRET=[Generate with: openssl rand -base64 32]
POSTGRES_PASSWORD=[Your secure database password]
```

See `COMPLETE_SETUP_GUIDE.md` for full configuration details.
