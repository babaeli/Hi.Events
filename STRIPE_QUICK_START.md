# ⚡ Stripe Integration - 5 Minute Quick Start

Follow these steps to enable payment processing in Hi.Events **RIGHT NOW**.

---

## ✅ Checklist (Complete in Order)

### ☑️ **Step 1: Get Stripe Account** (2 minutes)

1. Go to: https://dashboard.stripe.com/register
2. Sign up with your email
3. **Skip** activation for now (we'll use test mode)

---

### ☑️ **Step 2: Get Test Keys** (1 minute)

1. In Stripe Dashboard, ensure you're in **Test Mode** (toggle top-right)
2. Go to: https://dashboard.stripe.com/test/apikeys
3. Copy these two keys:

**Publishable Key** (safe to share):
```
pk_test_51XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

**Secret Key** (click "Reveal test key", keep secret):
```
sk_test_51XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

---

### ☑️ **Step 3: Update Hi.Events Configuration** (1 minute)

Open: `Hi.Events-develop/docker/all-in-one/.env`

Find these lines and replace with YOUR keys:

```env
# Line 9 - Frontend key
VITE_STRIPE_PUBLISHABLE_KEY=pk_test_YOUR_PUBLISHABLE_KEY_HERE

# Line 53 - Backend public key
STRIPE_PUBLIC_KEY=pk_test_YOUR_PUBLISHABLE_KEY_HERE

# Line 54 - Backend secret key (KEEP THIS SECRET!)
STRIPE_SECRET_KEY=sk_test_YOUR_SECRET_KEY_HERE
```

**Save the file.**

---

### ☑️ **Step 4: Restart Hi.Events** (1 minute)

```bash
cd Hi.Events-develop/docker/all-in-one
docker compose down
docker compose up -d
```

Wait 30 seconds for containers to start.

---

### ☑️ **Step 5: Test Payment Flow** (2 minutes)

1. **Login to Hi.Events**: http://localhost:8123
   - Use your existing account: `flynnduerrel@gmail.com`

2. **Connect Stripe** (first time only):
   - Go to **Settings** → **Payment Settings**
   - Click **"Connect with Stripe"**
   - Complete the Stripe Connect flow

3. **Create a Test Event**:
   - Click **"Create Event"**
   - Name: "Test Concert"
   - Date: Tomorrow
   - Add Ticket: "General Admission" - $50

4. **Buy a Test Ticket**:
   - Go to your event's public page
   - Click **"Get Tickets"**
   - Use this test card:
     - **Card**: `4242 4242 4242 4242`
     - **Expiry**: `12/25` (any future date)
     - **CVC**: `123`
     - **ZIP**: `12345`
   - Complete checkout

5. **Verify Payment**:
   - Go to Stripe Dashboard → Payments
   - You should see the test transaction! ✅

---

## 🎉 Done!

You now have a working payment system!

### What Works Now:

✅ Stripe checkout integration  
✅ Test card payments  
✅ Digital ticket generation  
✅ QR code tickets  
✅ Email receipts (check logs)  
✅ Payment tracking  

---

## 🚀 Next Steps

### For Real Money (Production):

1. **Activate Stripe Account**:
   - Stripe Dashboard → Complete activation
   - Add bank account
   - Verify identity

2. **Get Live Keys**:
   - Toggle to **Live Mode**
   - Copy `pk_live_...` and `sk_live_...` keys
   - Update `.env` with live keys

3. **Setup Webhooks**: See full guide in `PAYMENT_INTEGRATION_GUIDE.md`

---

## 💡 Quick Test Cards

| Card Number          | Result              |
|---------------------|---------------------|
| `4242 4242 4242 4242` | ✅ Success          |
| `4000 0025 0000 3155` | ✅ Requires 3D Secure |
| `4000 0000 0000 9995` | ❌ Insufficient Funds |
| `4000 0000 0000 0002` | ❌ Card Declined     |

All test cards:
- Expiry: Any future date
- CVC: Any 3 digits
- ZIP: Any 5 digits

---

## 🔍 Troubleshooting

**"Invalid API Key"**
→ Double-check you copied the complete key (starts with `pk_test_` or `sk_test_`)
→ Ensure no extra spaces in `.env` file
→ Restart Docker: `docker compose restart`

**"Cannot connect to Stripe"**
→ Check you're using test mode keys
→ Verify `.env` file was saved
→ Check container logs: `docker logs all-in-one-all-in-one-1`

**"Payment failed"**
→ Use card `4242 4242 4242 4242`
→ Verify Stripe account is connected in Hi.Events settings

---

## 📚 More Info

- Full guide: `PAYMENT_INTEGRATION_GUIDE.md`
- Stripe docs: https://stripe.com/docs
- Test cards: https://stripe.com/docs/testing

**Need help?** Check the full `PAYMENT_INTEGRATION_GUIDE.md` for detailed explanations.
