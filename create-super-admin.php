<?php

// Simple script to create super admin - run inside container
$email = 'admin@hievents.com';
$password = 'SuperAdmin2024';
$hash = password_hash($password, PASSWORD_BCRYPT);

echo "Email: $email\n";
echo "Password: $password\n";
echo "Hash: $hash\n";
