<?php

declare(strict_types=1);

namespace HiEvents\Console\Commands;

use HiEvents\DomainObjects\Enums\Role;
use HiEvents\DomainObjects\Status\UserStatus;
use HiEvents\Helper\IdHelper;
use HiEvents\Repository\Interfaces\AccountConfigurationRepositoryInterface;
use HiEvents\Repository\Interfaces\AccountMessagingTierRepositoryInterface;
use HiEvents\Repository\Interfaces\AccountRepositoryInterface;
use HiEvents\Repository\Interfaces\AccountUserRepositoryInterface;
use HiEvents\Repository\Interfaces\UserRepositoryInterface;
use Illuminate\Console\Command;
use Illuminate\Hashing\HashManager;
use Illuminate\Database\DatabaseManager;
use Psr\Log\LoggerInterface;
use Throwable;

class CreateSuperAdminCommand extends Command
{
    protected $signature = 'superadmin:create
                            {email : The email address of the super admin}
                            {--first-name= : The first name of the super admin}
                            {--last-name= : The last name of the super admin}
                            {--password= : The password (will prompt if not provided)}
                            {--timezone=UTC : The timezone (default: UTC)}';

    protected $description = 'Create a SUPERADMIN user with a dedicated SaaS management account. WARNING: Grants complete system access.';

    public function __construct(
        private readonly UserRepositoryInterface $userRepository,
        private readonly AccountRepositoryInterface $accountRepository,
        private readonly AccountUserRepositoryInterface $accountUserRepository,
        private readonly AccountConfigurationRepositoryInterface $accountConfigurationRepository,
        private readonly AccountMessagingTierRepositoryInterface $accountMessagingTierRepository,
        private readonly HashManager $hashManager,
        private readonly DatabaseManager $databaseManager,
        private readonly LoggerInterface $logger,
    ) {
        parent::__construct();
    }

    public function handle(): int
    {
        $this->warn('⚠️  WARNING: This command will create a user with COMPLETE SYSTEM ACCESS.');
        $this->warn('⚠️  SUPERADMIN users have unrestricted access to all accounts and data.');
        $this->newLine();

        $email = strtolower($this->argument('email'));
        
        // Validate email format
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $this->error('Invalid email address format.');
            return Command::FAILURE;
        }

        // Check if user already exists
        $existingUser = $this->userRepository->findFirstWhere(['email' => $email]);
        
        if ($existingUser) {
            // Check if they're already a SUPERADMIN
            $existingSuperAdmin = $this->accountUserRepository->findFirstWhere([
                'user_id' => $existingUser->getId(),
                'role' => Role::SUPERADMIN->name,
            ]);

            if ($existingSuperAdmin) {
                $this->error("User {$email} is already a SUPERADMIN.");
                return Command::FAILURE;
            }

            // Ask if they want to upgrade existing user
            if (!$this->confirm("User {$email} already exists. Upgrade to SUPERADMIN?", true)) {
                $this->info('Operation cancelled.');
                return Command::FAILURE;
            }

            $user = $existingUser;
            $isNewUser = false;
        } else {
            $isNewUser = true;
        }

        // Get user details
        $firstName = $this->option('first-name');
        $lastName = $this->option('last-name');
        $password = $this->option('password');
        $timezone = $this->option('timezone');

        if ($isNewUser) {
            if (!$firstName) {
                $firstName = $this->ask('First name');
            }
            if (!$lastName) {
                $lastName = $this->ask('Last name (optional)', '');
            }
        }

        if (!$password) {
            $password = $this->secret('Password');
            $confirmPassword = $this->secret('Confirm password');

            if ($password !== $confirmPassword) {
                $this->error('Passwords do not match.');
                return Command::FAILURE;
            }
        }

        if (strlen($password) < 8) {
            $this->error('Password must be at least 8 characters.');
            return Command::FAILURE;
        }

        try {
            $this->databaseManager->beginTransaction();

            // Create account for SUPERADMIN management
            $accountName = 'SaaS Platform Administration';
            
            // Get default configuration
            $defaultConfig = $this->accountConfigurationRepository->findFirstWhere([
                'is_system_default' => true,
            ]);

            if (!$defaultConfig) {
                // Get first configuration if no default
                $defaultConfig = $this->accountConfigurationRepository->all()->first();
            }

            if (!$defaultConfig) {
                $this->error('No account configuration found. Please run migrations first.');
                $this->databaseManager->rollBack();
                return Command::FAILURE;
            }

            // Get default messaging tier
            $defaultMessagingTier = $this->accountMessagingTierRepository->findFirstWhere([
                'is_default' => true,
            ]);

            if (!$defaultMessagingTier) {
                $defaultMessagingTier = $this->accountMessagingTierRepository->all()->first();
            }

            if (!$defaultMessagingTier) {
                $this->error('No messaging tier found. Please run migrations first.');
                $this->databaseManager->rollBack();
                return Command::FAILURE;
            }

            // Create or find admin account
            $adminAccount = $this->accountRepository->findFirstWhere([
                'email' => 'admin@hi.events',
            ]);

            if (!$adminAccount) {
                $this->info('Creating SaaS admin account...');
                $adminAccount = $this->accountRepository->create([
                    'name' => $accountName,
                    'email' => 'admin@hi.events',
                    'currency_code' => 'USD',
                    'timezone' => 'UTC',
                    'short_id' => IdHelper::shortId(IdHelper::ACCOUNT_PREFIX),
                    'account_verified_at' => now()->toDateTimeString(),
                    'is_manually_verified' => true,
                    'account_configuration_id' => $defaultConfig->getId(),
                    'account_messaging_tier_id' => $defaultMessagingTier->getId(),
                ]);
            }

            // Create or update user
            if ($isNewUser) {
                $this->info('Creating new SUPERADMIN user...');
                $user = $this->userRepository->create([
                    'email' => $email,
                    'password' => $this->hashManager->make($password),
                    'first_name' => $firstName,
                    'last_name' => $lastName ?? '',
                    'timezone' => $timezone,
                    'email_verified_at' => now()->toDateTimeString(),
                    'locale' => 'en',
                ]);
            } else {
                $this->info('Upgrading existing user to SUPERADMIN...');
                // Optionally update password for existing user
                $this->userRepository->updateById(
                    $user->getId(),
                    ['password' => $this->hashManager->make($password)]
                );
            }

            // Check if user already associated with admin account
            $existingAssociation = $this->accountUserRepository->findFirstWhere([
                'user_id' => $user->getId(),
                'account_id' => $adminAccount->getId(),
            ]);

            if ($existingAssociation) {
                // Update existing association to SUPERADMIN
                $this->accountUserRepository->updateById(
                    $existingAssociation->getId(),
                    [
                        'role' => Role::SUPERADMIN->name,
                        'status' => UserStatus::ACTIVE->name,
                        'is_account_owner' => true,
                    ]
                );
            } else {
                // Create new association with SUPERADMIN role
                $this->accountUserRepository->create([
                    'user_id' => $user->getId(),
                    'account_id' => $adminAccount->getId(),
                    'role' => Role::SUPERADMIN->name,
                    'status' => UserStatus::ACTIVE->name,
                    'is_account_owner' => true,
                ]);
            }

            $this->databaseManager->commit();

            // Log the creation
            $this->logger->critical('SUPERADMIN user created via console command', [
                'user_id' => $user->getId(),
                'user_email' => $email,
                'account_id' => $adminAccount->getId(),
                'is_new_user' => $isNewUser,
                'command' => $this->signature,
            ]);

            $this->newLine();
            $this->info('✅ SUPERADMIN user created successfully!');
            $this->newLine();
            $this->table(
                ['Field', 'Value'],
                [
                    ['Email', $email],
                    ['First Name', $firstName ?? $user->getFirstName()],
                    ['Last Name', $lastName ?? $user->getLastName()],
                    ['Role', 'SUPERADMIN'],
                    ['Account', $adminAccount->getName()],
                    ['Account ID', $adminAccount->getId()],
                    ['Status', 'ACTIVE'],
                ]
            );
            $this->newLine();
            $this->warn('⚠️  This user now has COMPLETE SYSTEM ACCESS to all platform data.');
            $this->newLine();
            $this->info('This user can now:');
            $this->info('  • Access all system administration features');
            $this->info('  • View and manage all accounts');
            $this->info('  • Manually verify accounts');
            $this->info('  • Impersonate any non-SUPERADMIN user');
            $this->info('  • Access system-wide statistics');
            $this->info('  • Manage announcements and spam events');
            $this->newLine();

            return Command::SUCCESS;

        } catch (Throwable $e) {
            $this->databaseManager->rollBack();
            
            $this->logger->error('Failed to create SUPERADMIN user', [
                'email' => $email,
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);
            
            $this->error('Failed to create SUPERADMIN user: ' . $e->getMessage());
            return Command::FAILURE;
        }
    }
}
