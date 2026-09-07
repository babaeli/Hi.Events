<?php

require '/app/backend/vendor/autoload.php';
require '/app/backend/bootstrap/app.php';

use HiEvents\Models\User;
use HiEvents\Models\Account;
use HiEvents\Models\AccountUser;
use HiEvents\DomainObjects\Enums\Role;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

// Create user
$user = User::create([
    'email' => 'admin@hievents.local',
    'password' => Hash::make('Admin@123456'),
    'first_name' => 'Super',
    'last_name' => 'Admin',
    'timezone' => 'UTC',
    'locale' => 'en'
]);

echo "✓ User created with ID: {$user->id}\n";
echo "  Email: {$user->email}\n";

// Create account
$account = Account::create([
    'name' => 'Platform Admin',
    'email' => 'admin@hievents.local',
    'currency_code' => 'USD',
    'timezone' => 'UTC',
    'short_id' => strtoupper(Str::random(8))
]);

echo "✓ Account created with ID: {$account->id}\n";

// Associate user with account as ADMIN first
$accountUser = AccountUser::create([
    'account_id' => $account->id,
    'user_id' => $user->id,
    'role' => Role::ADMIN->name,
    'is_account_owner' => true
]);

echo "✓ User associated with account\n";
echo "✓ User ID for super admin promotion: {$user->id}\n";
echo "\nNow run: docker compose exec all-in-one php /app/backend/artisan user:make-superadmin {$user->id}\n";
