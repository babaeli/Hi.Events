<?php

namespace HiEvents\Http\Middleware;

use Closure;
use HiEvents\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AutoLoginDevelopment
{
    /**
     * Auto-login as SUPERADMIN for development
     */
    public function handle(Request $request, Closure $next)
    {
        // If not already authenticated, auto-login as user ID 4 (admin@hievents.com)
        if (!Auth::check()) {
            $user = User::find(4); // The SUPERADMIN user
            if ($user) {
                Auth::login($user);
            }
        }

        return $next($request);
    }
}
