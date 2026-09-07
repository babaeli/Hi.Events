-- Hi.Events Super Admin Creation Script
-- This script creates a Super Admin user with access to the admin dashboard

-- Step 1: Create the user (if not exists)
INSERT INTO users (email, first_name, last_name, password, email_verified_at, created_at, updated_at)
VALUES (
    'admin@hievents.local',
    'Super',
    'Admin',
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: password
    NOW(),
    NOW(),
    NOW()
)
ON CONFLICT (email) DO NOTHING
RETURNING id;

-- Step 2: Create an account for the super admin
INSERT INTO accounts (name, email, timezone, currency_code, created_at, updated_at, account_verified_at)
VALUES (
    'Platform Administration',
    'admin@hievents.local',
    'UTC',
    'USD',
    NOW(),
    NOW(),
    NOW()
)
ON CONFLICT DO NOTHING
RETURNING id;

-- Step 3: Link user to account with SUPERADMIN role
-- Note: Replace user_id and account_id with actual values from steps 1 and 2
INSERT INTO account_users (account_id, user_id, role, is_account_owner, status, created_at, updated_at)
SELECT 
    a.id as account_id,
    u.id as user_id,
    'SUPERADMIN' as role,
    true as is_account_owner,
    'ACTIVE' as status,
    NOW() as created_at,
    NOW() as updated_at
FROM users u
CROSS JOIN accounts a
WHERE u.email = 'admin@hievents.local'
  AND a.email = 'admin@hievents.local'
ON CONFLICT DO NOTHING;

-- Verify the super admin was created
SELECT 
    u.id,
    u.email,
    u.first_name,
    u.last_name,
    au.role,
    a.name as account_name
FROM users u
JOIN account_users au ON au.user_id = u.id
JOIN accounts a ON a.id = au.account_id
WHERE u.email = 'admin@hievents.local';
