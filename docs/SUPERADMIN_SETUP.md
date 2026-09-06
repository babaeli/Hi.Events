# Super Admin SaaS Account Setup Guide

## Overview

This guide explains how to create and manage SUPERADMIN accounts for your Hi.Events SaaS platform. SUPERADMIN is the highest privilege level in the system, designed for platform administrators who need to manage all accounts and system-wide settings.

## What is a SUPERADMIN?

A SUPERADMIN user has platform-wide administrative privileges including:

- ✅ **Account Management**: View and manage ALL accounts on the platform
- ✅ **Manual Verification**: Approve or reject account verification requests
- ✅ **User Impersonation**: Impersonate any non-SUPERADMIN user for support purposes
- ✅ **System Statistics**: Access comprehensive system-wide analytics and reports
- ✅ **Announcement Management**: Create and manage platform-wide announcements
- ✅ **Spam Moderation**: Review and manage flagged events and messages
- ✅ **Messaging Tier Management**: Control account messaging capabilities
- ✅ **Account Deletion**: Process account deletion requests

### Security Notes

⚠️ **SUPERADMIN accounts are extremely powerful and should be:**
- Limited to 1-2 trusted platform administrators
- Protected with strong passwords (minimum 8 characters)
- Used only when necessary
- Never shared between people
- Monitored through audit logs

## Creating SUPERADMIN Users

### Method 1: Using the Console Command (Recommended)

The easiest and safest way to create SUPERADMIN users is via the Artisan command:

```bash
cd backend
php artisan superadmin:create admin@yourdomain.com --first-name="John" --last-name="Doe"
```

You'll be prompted to enter a password securely.

#### Full Command Options

```bash
php artisan superadmin:create {email}
    [--first-name=VALUE]      # First name of the admin
    [--last-name=VALUE]       # Last name of the admin (optional)
    [--password=VALUE]        # Password (will prompt if not provided)
    [--timezone=UTC]          # Timezone (default: UTC)
```

#### Examples

**Create first SUPERADMIN:**
```bash
php artisan superadmin:create admin@company.com --first-name="Admin" --last-name="User"
```

**Create second SUPERADMIN:**
```bash
php artisan superadmin:create support@company.com --first-name="Support" --last-name="Team"
```

**Upgrade existing user to SUPERADMIN:**
```bash
php artisan superadmin:create existing.user@company.com
# Will prompt: "User existing.user@company.com already exists. Upgrade to SUPERADMIN?"
```

**Specify password directly (not recommended for production):**
```bash
php artisan superadmin:create admin@company.com --first-name="Admin" --password="YourStrongPassword123"
```

### Method 2: Direct Database Creation (Advanced)

If you need to create a SUPERADMIN directly via SQL:

```sql
-- 1. Create the user
INSERT INTO users (email, password, first_name, last_name, timezone, email_verified_at, created_at, updated_at)
VALUES (
    'admin@yourdomain.com',
    '$2y$10$...',  -- Use bcrypt hash of your password
    'Admin',
    'User',
    'UTC',
    NOW(),
    NOW(),
    NOW()
);

-- 2. Get the user ID
-- Note the ID returned from the insert above or query: SELECT id FROM users WHERE email = 'admin@yourdomain.com';

-- 3. Find or create the admin account
-- First check if admin account exists:
SELECT id FROM accounts WHERE email = 'admin@hi.events';

-- If not exists, create it:
INSERT INTO accounts (name, email, currency_code, timezone, short_id, account_verified_at, is_manually_verified, account_configuration_id, account_messaging_tier_id, created_at, updated_at)
VALUES (
    'SaaS Platform Administration',
    'admin@hi.events',
    'USD',
    'UTC',
    'ACC_XXXXXXXXXXXX',  -- Generate unique ID
    NOW(),
    true,
    1,  -- Use appropriate config ID
    1,  -- Use appropriate messaging tier ID
    NOW(),
    NOW()
);

-- 4. Associate user with account as SUPERADMIN
INSERT INTO account_users (user_id, account_id, role, status, is_account_owner, created_at, updated_at)
VALUES (
    123,  -- User ID from step 2
    456,  -- Account ID from step 3
    'SUPERADMIN',
    'ACTIVE',
    true,
    NOW(),
    NOW()
);
```

## Logging In as SUPERADMIN

1. Navigate to your Hi.Events login page
2. Enter your SUPERADMIN email and password
3. You'll be logged into the "SaaS Platform Administration" account
4. Access admin features through the admin panel

## SUPERADMIN Account Structure

Each SUPERADMIN user is associated with a special account:

- **Account Name**: SaaS Platform Administration
- **Account Email**: admin@hi.events
- **Purpose**: Central administrative account for platform management
- **Verification**: Always verified and manually approved
- **Users**: Only SUPERADMIN role users should be in this account

## Managing Multiple SUPERADMIN Users

For a two-person SaaS admin team:

```bash
# Create first admin
php artisan superadmin:create admin1@company.com --first-name="Alice" --last-name="Admin"

# Create second admin
php artisan superadmin:create admin2@company.com --first-name="Bob" --last-name="Admin"
```

Both users will be associated with the same "SaaS Platform Administration" account and have full platform access.

## What SUPERADMIN Users Can Do

### 1. View All Accounts
```
GET /api/admin/accounts
```
Access comprehensive list of all platform accounts with statistics.

### 2. Update Account Verification
```
PUT /api/admin/accounts/{accountId}/verification
```
Manually verify or unverify accounts (required in SaaS mode).

### 3. View Dashboard Statistics
```
GET /api/admin/dashboard
```
Access system-wide metrics including:
- Total accounts, events, orders
- Revenue statistics
- Growth metrics
- Account statuses

### 4. Impersonate Users
```
POST /api/admin/impersonate/{userId}
```
Log in as any non-SUPERADMIN user for support purposes.
All impersonation actions are logged for audit purposes.

### 5. Manage Announcements
```
POST /api/admin/announcements
GET /api/admin/announcements
PUT /api/admin/announcements/{id}
DELETE /api/admin/announcements/{id}
```
Create platform-wide announcements visible to all users.

### 6. Review Spam Events
```
GET /api/admin/spam-events
PUT /api/admin/spam-events/{eventId}/approve
PUT /api/admin/spam-events/{eventId}/reject
```
Review and moderate flagged events.

### 7. Manage Messaging Tiers
```
PUT /api/admin/accounts/{accountId}/messaging-tier
```
Control account messaging capabilities and limits.

## Security Best Practices

### Password Requirements
- Minimum 8 characters (enforced by command)
- Recommended: 16+ characters with mix of uppercase, lowercase, numbers, and symbols
- Use a password manager to generate and store passwords

### Access Control
- Create separate SUPERADMIN accounts for each administrator (no sharing)
- Use 2FA if available
- Regularly rotate passwords
- Monitor audit logs for unusual activity

### Audit Logging
All SUPERADMIN actions are logged in the `event_logs` table:
- User impersonation
- Account verification changes
- Sensitive operations

Query logs:
```sql
SELECT * FROM event_logs 
WHERE user_id IN (
    SELECT user_id FROM account_users WHERE role = 'SUPERADMIN'
)
ORDER BY created_at DESC;
```

## Revoking SUPERADMIN Access

To remove SUPERADMIN privileges from a user:

```sql
-- Delete the SUPERADMIN association
DELETE FROM account_users 
WHERE user_id = (SELECT id FROM users WHERE email = 'user@example.com')
AND role = 'SUPERADMIN';
```

Or set status to INACTIVE:
```sql
UPDATE account_users 
SET status = 'INACTIVE'
WHERE user_id = (SELECT id FROM users WHERE email = 'user@example.com')
AND role = 'SUPERADMIN';
```

## Troubleshooting

### "User already exists" Error
If you're trying to create a SUPERADMIN but the user already exists in the system:
- The command will ask if you want to upgrade the existing user to SUPERADMIN
- Confirm with 'yes' to proceed
- The user's password will be updated to the new one

### "No account configuration found" Error
Run database migrations first:
```bash
php artisan migrate
```

### "Unauthorized" When Accessing Admin Routes
Verify the user is properly set up:
```sql
SELECT u.email, au.role, au.status, au.is_account_owner
FROM users u
JOIN account_users au ON u.id = au.user_id
WHERE u.email = 'your@email.com' AND au.role = 'SUPERADMIN';
```

Should return one row with:
- role: SUPERADMIN
- status: ACTIVE
- is_account_owner: true

### Can't Impersonate Users
Check the User model's `canImpersonate()` method returns true. Only SUPERADMIN users in their current account context can impersonate.

## Environment Configuration

### SaaS Mode
Ensure your `.env` file has:
```env
APP_SAAS_MODE_ENABLED=true
```

This enables:
- Manual account verification (SUPERADMIN approval required)
- Spam event checking
- Stripe Connect for multi-tenant payments
- Platform fees

### Self-Hosted Mode
```env
APP_SAAS_MODE_ENABLED=false
```

In self-hosted mode:
- Accounts are auto-verified
- No manual approval needed
- SUPERADMIN still has full access but less moderation features

## Related Files

### Backend Files
- `backend/app/Console/Commands/CreateSuperAdminCommand.php` - Command implementation
- `backend/app/DomainObjects/Enums/Role.php` - Role definitions
- `backend/app/Models/User.php` - User model with impersonation
- `backend/app/Services/Infrastructure/Authorization/IsAuthorizedService.php` - Authorization logic
- `backend/app/Http/Actions/Admin/` - All SUPERADMIN-only endpoints

### Database Tables
- `users` - User accounts
- `accounts` - Tenant accounts
- `account_users` - User-account associations with roles
- `event_logs` - Audit trail

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review Laravel logs: `backend/storage/logs/laravel.log`
3. Check database integrity
4. Review authorization middleware and policies

---

**Created for Hi.Events SaaS Platform**
Version 1.0 - 2026
