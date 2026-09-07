# 💳 Payment Integration Guide for Hi.Events

Hi.Events uses **Stripe** for secure payment processing. This guide covers both testing and production setup.

---

## 📋 Table of Contents

1. [Payment Models](#payment-models)
2. [Quick Setup (Test Mode)](#quick-setup-test-mode)
3. [Production Setup](#production-setup)
4. [SaaS Mode (Platform Fees)](#saas-mode-platform-fees)
5. [Stripe Connect Setup](#stripe-connect-setup)
6. [Webhooks Configuration](#webhooks-configuration)
7. [Testing Payments](#testing-payments)
8. [Troubleshooting](#troubleshooting)

---

## 🎯 Payment Models

### **Model 1: Direct Payments (Default)**
- Each organizer connects **their own** Stripe account
- Payments go **directly** to the organizer
- You (platform owner) don't handle money
- Best for: Multi-tenant platforms where organizers manage their own payments

### **Model 2: Platform Payments (SaaS Mode)**
- You (platform owner) have **one Stripe account**
- All payments go through **your** account via Stripe Connect
- You automatically take **platform fees** (percentage or fixed)
- Money is distributed to organizers
- Best for: Managed platforms where you charge commission

---

## 🚀 Quick Setup (Test Mode)

### Step 1: Create Stripe Account

1. Go to [https://dashboard.stripe.com/register](https://dashboard.stripe.com/register)
2. Sign up for a **free** Stripe account
3. Complete basic profile setup

### Step 2: Get Test API Keys

1. In Stripe Dashboard, toggle to **Test mode** (top right)
2. Go to **Developers** → **API keys**
3. Copy these keys:
   - **Publishable key**: `pk_test_...`
   - **Secret key**: `sk_test_...` (click "Reveal test key")

### Step 3: Update Environment Variables

Edit `Hi.Events-develop/docker/all-in-one/.env`:

```env
# Frontend Stripe key
VITE_STRIPE_PUBLISHABLE_KEY=pk_test_YOUR_ACTUAL_KEY_HERE

# Backend Stripe keys
STRIPE_PUBLIC_KEY=pk_test_YOUR_ACTUAL_KEY_HERE
STRIPE_SECRET_KEY=sk_test_YOUR_ACTUAL_SECRET_KEY_HERE
```

### Step 4: Restart Docker Containers

```bash
cd Hi.Events-develop/docker/all-in-one
docker compose down
docker compose up -d
```

### Step 5: Connect Stripe in the App

1. Login to Hi.Events at http://localhost:8123
2. Go to **Settings** → **Payment Settings**
3. Click **"Connect with Stripe"**
4. You'll be redirected to Stripe to authorize
5. Complete the connection flow

---

## 🏭 Production Setup

### Step 1: Activate Stripe Account

1. In Stripe Dashboard, complete **Account Activation**:
   - Business details
   - Bank account information
   - Identity verification
   - Tax information

### Step 2: Get Live API Keys

1. Toggle Stripe Dashboard to **Live mode**
2. Go to **Developers** → **API keys**
3. Copy **Live** keys:
   - **Publishable key**: `pk_live_...`
   - **Secret key**: `sk_live_...`

### Step 3: Update Production Environment

```env
# Use LIVE keys for production
VITE_STRIPE_PUBLISHABLE_KEY=pk_live_YOUR_LIVE_KEY
STRIPE_PUBLIC_KEY=pk_live_YOUR_LIVE_KEY
STRIPE_SECRET_KEY=sk_live_YOUR_LIVE_SECRET_KEY
```

### Step 4: Configure Stripe Connect (Required for Production)

In your `.env` file:

```env
# Stripe Connect account type: 'express' or 'standard'
# Express = Easier onboarding, Stripe handles compliance
# Standard = More control, organizers manage their own Stripe dashboard
APP_STRIPE_CONNECT_ACCOUNT_TYPE=express

# Platform support email (shown in Stripe Connect flow)
APP_PLATFORM_SUPPORT_EMAIL=support@yourdomain.com
```

---

## 💰 SaaS Mode (Platform Fees)

If you want to charge fees on every ticket sale, enable SaaS mode.

### Enable SaaS Mode

Edit `.env`:

```env
# Enable SaaS mode
APP_SAAS_MODE_ENABLED=true

# Platform fees (you can use one or both)
APP_SAAS_STRIPE_APPLICATION_FEE_PERCENT=2.5    # 2.5% of ticket price
APP_SAAS_STRIPE_APPLICATION_FEE_FIXED=50       # $0.50 fixed fee per ticket (in cents)

# Example: $100 ticket with above settings
# Your fee = ($100 × 2.5%) + $0.50 = $3.00
# Organizer receives = $100 - $3.00 = $97.00
```

### Requirements for SaaS Mode

1. **Stripe Connect Platform** must be activated:
   - Go to Stripe Dashboard → **Connect** → **Get Started**
   - Complete platform profile

2. **Currency Conversion** (if supporting multiple currencies):
   ```env
   # Get free API key from https://openexchangerates.org/
   OPEN_EXCHANGE_RATES_APP_ID=your_api_key
   ```

---

## 🔌 Stripe Connect Setup

Stripe Connect allows organizers to receive payments.

### For Platform Owners

1. **Activate Stripe Connect**:
   - Stripe Dashboard → **Connect** → **Get Started**
   - Choose **Platform or Marketplace**
   - Complete profile setup

2. **Set Branding**:
   - Upload your platform logo
   - Set brand colors
   - These appear when organizers connect

### For Organizers (Your Clients)

When organizers connect Stripe:

1. They click **"Connect Stripe"** in their Hi.Events dashboard
2. Redirected to Stripe Connect flow
3. Depending on `APP_STRIPE_CONNECT_ACCOUNT_TYPE`:
   - **Express**: Quick 5-minute setup, Stripe handles compliance
   - **Standard**: Full Stripe account, more control

4. After connection, they can:
   - Receive payments
   - View payouts in Stripe Dashboard
   - Manage refunds

---

## 🔔 Webhooks Configuration

Webhooks notify Hi.Events about payment events (successful charges, refunds, etc.).

### Step 1: Create Webhook Endpoint

1. Stripe Dashboard → **Developers** → **Webhooks**
2. Click **"Add endpoint"**
3. **Endpoint URL**: 
   ```
   https://yourdomain.com/webhooks/stripe
   ```
   (For testing: `http://localhost:8123/webhooks/stripe`)

4. **Select events to listen to**:
   - `charge.succeeded`
   - `charge.failed`
   - `payment_intent.succeeded`
   - `payment_intent.payment_failed`
   - `checkout.session.completed`
   - `customer.subscription.created`
   - `customer.subscription.deleted`
   - Or select **"Send all event types"** for testing

### Step 2: Get Webhook Secret

1. After creating webhook, copy the **Signing secret** (starts with `whsec_`)
2. Add to `.env`:
   ```env
   STRIPE_WEBHOOK_SECRET=whsec_YOUR_WEBHOOK_SECRET
   ```

### Step 3: Test Webhooks Locally (Optional)

Use Stripe CLI for local testing:

```bash
# Install Stripe CLI
# https://stripe.com/docs/stripe-cli

# Login
stripe login

# Forward webhooks to local app
stripe listen --forward-to localhost:8123/webhooks/stripe

# This will output a webhook secret - use it in your .env
```

---

## 🧪 Testing Payments

### Test Card Numbers

Use these in **Test Mode**:

| Card Number         | Scenario              |
|--------------------|-----------------------|
| 4242 4242 4242 4242 | ✅ Success            |
| 4000 0025 0000 3155 | ✅ 3D Secure Required |
| 4000 0000 0000 9995 | ❌ Insufficient Funds |
| 4000 0000 0000 0002 | ❌ Card Declined      |

- **Expiry**: Any future date (e.g., 12/25)
- **CVC**: Any 3 digits (e.g., 123)
- **ZIP**: Any 5 digits (e.g., 12345)

### Test Workflow

1. Create a test event with paid tickets
2. Go to event public page
3. Add ticket to cart
4. Proceed to checkout
5. Use test card: `4242 4242 4242 4242`
6. Complete purchase
7. Check Stripe Dashboard → **Payments** to see test transaction

---

## 🔧 Troubleshooting

### Issue: "Stripe keys invalid"

**Solution:**
- Verify keys match the mode (test keys for test mode, live keys for production)
- Check for extra spaces or quotes in `.env` file
- Restart Docker containers after changing `.env`

### Issue: "Connect with Stripe" button doesn't work

**Solution:**
- Ensure `APP_FRONTEND_URL` is set correctly in `.env`
- Check browser console for CORS errors
- Verify Stripe Connect is activated in your Stripe account

### Issue: Webhooks not firing

**Solution:**
- Check webhook endpoint URL is publicly accessible
- Verify `STRIPE_WEBHOOK_SECRET` is set correctly
- Test webhook delivery in Stripe Dashboard → Webhooks → Click on endpoint → Send test webhook
- Check application logs: `docker logs all-in-one-all-in-one-1`

### Issue: "This payment cannot be processed"

**Solution:**
- Organizer must connect Stripe account first
- Check event has valid payment products configured
- Verify Stripe account is activated (for live mode)

### Issue: Platform fees not being collected (SaaS mode)

**Solution:**
- Ensure `APP_SAAS_MODE_ENABLED=true`
- Verify fee amounts are set: `APP_SAAS_STRIPE_APPLICATION_FEE_PERCENT` or `APP_SAAS_STRIPE_APPLICATION_FEE_FIXED`
- Platform Stripe account must be Connect-enabled
- Restart containers after changing SaaS settings

---

## 📊 Viewing Payments & Fees

### Platform Owner View (You)

1. **Stripe Dashboard** → **Payments**: See all platform transactions
2. **Stripe Dashboard** → **Connect**: See organizer accounts and payouts
3. **Hi.Events** → `/admin/dashboard`: See platform-wide revenue statistics

### Organizer View (Your Clients)

1. **Their own Stripe Dashboard**: View their payments and payouts
2. **Hi.Events** → **Dashboard**: See their event-specific sales
3. **Hi.Events** → **Orders**: Manage refunds and order details

---

## 🎯 Recommended Configuration

### For Testing (Local Development)
```env
VITE_STRIPE_PUBLISHABLE_KEY=pk_test_YOUR_KEY
STRIPE_PUBLIC_KEY=pk_test_YOUR_KEY
STRIPE_SECRET_KEY=sk_test_YOUR_SECRET
APP_SAAS_MODE_ENABLED=false
APP_STRIPE_CONNECT_ACCOUNT_TYPE=express
```

### For Production (SaaS Platform)
```env
VITE_STRIPE_PUBLISHABLE_KEY=pk_live_YOUR_KEY
STRIPE_PUBLIC_KEY=pk_live_YOUR_KEY
STRIPE_SECRET_KEY=sk_live_YOUR_SECRET
STRIPE_WEBHOOK_SECRET=whsec_YOUR_WEBHOOK_SECRET
APP_SAAS_MODE_ENABLED=true
APP_SAAS_STRIPE_APPLICATION_FEE_PERCENT=2.5
APP_STRIPE_CONNECT_ACCOUNT_TYPE=express
APP_PLATFORM_SUPPORT_EMAIL=support@yourdomain.com
```

---

## 🔒 Security Best Practices

1. **Never commit** `.env` file to git
2. **Use test keys** for development
3. **Rotate keys** if exposed
4. **Enable webhook signature verification** (already configured)
5. **Use HTTPS** in production (required for webhooks)
6. **Set strong passwords** for Hi.Events accounts
7. **Enable 2FA** on your Stripe account

---

## 📚 Additional Resources

- [Stripe Dashboard](https://dashboard.stripe.com/)
- [Stripe Connect Documentation](https://stripe.com/docs/connect)
- [Stripe Testing Guide](https://stripe.com/docs/testing)
- [Hi.Events Documentation](https://hi.events/docs)
- [Stripe API Keys](https://dashboard.stripe.com/apikeys)

---

## 💡 Quick Tips

- Start with **Test Mode** - it's free and safe to experiment
- Use **Express Connect** accounts - easier for your organizers
- Set reasonable **platform fees** (1-5% is industry standard)
- Test the **full checkout flow** before going live
- Monitor **webhook logs** for payment issues
- Keep **Stripe keys secure** - never share them

---

**Need help?** Check the Hi.Events documentation or Stripe support for additional assistance.
