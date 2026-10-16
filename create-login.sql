-- Create a new test user account
-- Password will be: password

-- Step 1: Create the user
INSERT INTO users (email, password, first_name, last_name, email_verified_at, created_at, updated_at)
VALUES (
  'mytest@example.com',
  '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
  'My',
  'Test',
  NOW(),
  NOW(),
  NOW()
)
ON CONFLICT (email) DO UPDATE SET 
  password = EXCLUDED.password,
  updated_at = NOW()
RETURNING id;

-- Step 2: Get the user ID (it will be displayed above)
-- Then create an account for them

-- Create account (run this after seeing the user ID above)
INSERT INTO accounts (name, email, created_at, updated_at)
VALUES ('My Test Organization', 'mytest@example.com', NOW(), NOW())
ON CONFLICT (email) DO NOTHING
RETURNING id;

-- Step 3: Link user to account with SUPERADMIN role
-- Replace USER_ID and ACCOUNT_ID with the IDs from above
-- Example: INSERT INTO account_users (account_id, user_id, role, created_at, updated_at)
-- VALUES (ACCOUNT_ID, USER_ID, 'SUPERADMIN', NOW(), NOW());
