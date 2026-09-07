# 🧪 Hi.Events Testing Guide

## Overview
This guide will help you test both user roles (Super Admin and Organizer) and understand how they interact with events.

---

## ✅ Current Setup

### **Accounts Created:**
1. **Super Admin** (Platform Owner)
   - Email: `admin@hievents.com`
   - Password: `SuperAdmin2024`

2. **Event Organizer** (Normal User)
   - Email: `organizer@test.com`
   - Password: `User123456`
   - Account: Event Organizer Co

### **Database Status:**
- ✅ All old events cleared
- ✅ Clean database ready for testing
- ✅ Both accounts active and ready

---

## 📝 Testing Steps

### **PART 1: Create Events as Organizer**

#### **Step 1: Login as Organizer**
1. Go to: http://localhost:8123/auth/login
2. Email: `organizer@test.com`
3. Password: `User123456`
4. Click **Login**

#### **Step 2: Create Event #1 - Music Concert**
1. After login, you'll be at: http://localhost:8123/manage/events
2. Click **"Create Event"** button
3. Fill in event details:
   - **Event Title**: "Summer Music Festival 2026"
   - **Description**: "Join us for an amazing outdoor music festival featuring top artists"
   - **Start Date**: Choose a future date
   - **End Date**: Same day or next day
   - **Location**: "Central Park, New York"
   - **Event Status**: Published (so it's visible)

4. **Create Ticket Types**:
   - **General Admission**
     - Price: $50
     - Quantity: 100
     - Description: Standard entry to the festival
   
   - **VIP Pass**
     - Price: $150
     - Quantity: 20
     - Description: VIP area access, meet & greet

5. **Save Event**

#### **Step 3: Create Event #2 - Tech Conference**
1. Click **"Create Event"** again
2. Fill in:
   - **Event Title**: "Tech Innovation Summit 2026"
   - **Description**: "Annual tech conference featuring industry leaders"
   - **Start Date**: Different future date
   - **Location**: "Convention Center, San Francisco"
   - **Event Status**: Published

3. **Create Ticket Types**:
   - **Early Bird**
     - Price: $199
     - Quantity: 50
     - Sale Ends: 2 weeks before event
   
   - **Regular Admission**
     - Price: $299
     - Quantity: 200

4. **Save Event**

#### **Step 4: Create Event #3 - Charity Gala**
1. Click **"Create Event"** again
2. Fill in:
   - **Event Title**: "Annual Charity Gala 2026"
   - **Description**: "Fundraising dinner to support local charities"
   - **Start Date**: Another future date
   - **Location**: "Grand Hotel Ballroom, Chicago"
   - **Event Status**: Published

3. **Create Ticket Types**:
   - **Individual Seat**
     - Price: $250
     - Quantity: 100
   
   - **Table of 10**
     - Price: $2000
     - Quantity: 20

4. **Save Event**

---

### **PART 2: View Events as Organizer**

While logged in as **organizer@test.com**:

#### **What You Can See:**
1. **Events Dashboard** (`/manage/events`)
   - All 3 events you just created
   - Event statistics (ticket sales, revenue)
   - Quick actions (edit, duplicate, view)

2. **Individual Event Pages**
   - Click any event
   - See ticket sales breakdown
   - View attendee list (empty for now)
   - Access event settings
   - Manage promo codes
   - Send messages to attendees

3. **Analytics Dashboard**
   - Total revenue from all YOUR events
   - Sales by event
   - Sales by ticket type
   - Date range filters

#### **What You CANNOT See:**
- ❌ Other organizers' events
- ❌ Platform-wide statistics
- ❌ Super Admin dashboard (`/admin`)
- ❌ Other accounts on the platform

---

### **PART 3: View Same Events as Super Admin**

#### **Step 1: Logout and Login as Super Admin**
1. Click your profile → **Logout**
2. Login with:
   - Email: `admin@hievents.com`
   - Password: `SuperAdmin2024`

#### **Step 2: Access Admin Dashboard**
1. After login, go to: http://localhost:8123/admin
2. You'll see the **Platform Dashboard**

#### **What You Can See as Super Admin:**

##### **A) Dashboard Overview**
- **Total Accounts**: 2 (Platform Admin + Event Organizer Co)
- **Total Events**: 3 (all events across all organizers)
- **Total Revenue**: $0 (no sales yet)
- **Recent Activity**: New events created

##### **B) Accounts Tab**
- Click **"Accounts"** in admin menu
- See **Event Organizer Co** listed
- Click on it to see:
  - Account details
  - All 3 events by this organizer
  - Account statistics
  - **Impersonate** button

##### **C) View All Events**
- Through the accounts page, you can see ALL events
- Even if there were 100 different organizers
- You'd see ALL their events in one place

##### **D) System Information**
- Click **"System"** tab
- See platform health
- Database status
- Failed jobs (if any)

---

### **PART 4: Impersonate the Organizer**

This is a powerful Super Admin feature!

#### **Step 1: Start Impersonation**
1. While logged in as Super Admin
2. Go to: http://localhost:8123/admin
3. Click **"Accounts"** → **"Event Organizer Co"**
4. Click **"Impersonate"** button

#### **What Happens:**
- You're now "logged in as" the organizer
- You see EXACTLY what they see
- You can perform actions AS THEM
- Useful for customer support: "I can see what you're seeing"

#### **Step 2: While Impersonating**
- You'll see the 3 events
- You can edit events
- You can create new events
- **Banner at top**: "You are impersonating John Organizer"

#### **Step 3: Stop Impersonation**
- Click **"Stop Impersonating"** button in the banner
- You're back to Super Admin view

---

### **PART 5: Create a Second Organizer (Test Multi-Tenant)**

To really see the power of multi-tenancy:

#### **Step 1: Create Another Organizer Account**
1. Logout from all accounts
2. Go to: http://localhost:8123/auth/register
3. Register with:
   - Email: `organizer2@test.com`
   - Password: `User123456`
   - First Name: Sarah
   - Last Name: Producer
   - Company: Music Venue LLC

#### **Step 2: Create Events for Organizer 2**
1. Login as `organizer2@test.com`
2. Create 1 or 2 events (whatever you want)

#### **Step 3: Verify Separation**
1. **As organizer2@test.com:**
   - You see ONLY your events
   - You DON'T see Event Organizer Co's events

2. **Login as organizer@test.com:**
   - You see ONLY your original 3 events
   - You DON'T see Music Venue LLC's events

3. **Login as Super Admin:**
   - You see BOTH organizers
   - You see ALL 5 events total
   - You can switch between both accounts

---

## 🎯 Key Concepts to Understand

### **1. Data Isolation (Multi-Tenancy)**
```
Platform (You see everything as Super Admin)
├── Event Organizer Co (organizer@test.com)
│   ├── Summer Music Festival
│   ├── Tech Innovation Summit
│   └── Charity Gala
└── Music Venue LLC (organizer2@test.com)
    ├── Rock Concert
    └── Jazz Night

organizer@test.com can ONLY see their 3 events
organizer2@test.com can ONLY see their 2 events
admin@hievents.com can see ALL 5 events
```

### **2. Role-Based Access Control**

| Feature | Organizer | Super Admin |
|---------|-----------|-------------|
| Create Events | ✅ (own account) | ✅ (any account) |
| View Events | ✅ (own only) | ✅ (all accounts) |
| Access /admin | ❌ | ✅ |
| View Revenue | ✅ (own only) | ✅ (platform-wide) |
| Impersonate Users | ❌ | ✅ |
| Platform Stats | ❌ | ✅ |

### **3. Platform Fees (SaaS Mode)**

When an organizer sells a ticket:
```
Ticket Price: $100
├── Platform Fee (10%): $10
├── Fixed Fee: $0.50
└── Organizer Gets: $89.50

Super Admin (YOU) gets: $10.50 automatically
```

This happens through Stripe Connect (when configured).

---

## 🧪 Testing Checklist

### **As Organizer (organizer@test.com):**
- [ ] Login successfully
- [ ] Create 3 different events
- [ ] Add multiple ticket types to each event
- [ ] View events dashboard
- [ ] Edit an event
- [ ] Try to access /admin (should fail)
- [ ] View analytics (only your events)

### **As Super Admin (admin@hievents.com):**
- [ ] Login successfully
- [ ] Access /admin dashboard
- [ ] See total accounts count
- [ ] See all 3 events from organizer
- [ ] View account details
- [ ] Impersonate the organizer
- [ ] Create event while impersonating
- [ ] Stop impersonation
- [ ] View platform-wide statistics

### **Multi-Tenant Test:**
- [ ] Create second organizer account
- [ ] Login as organizer 1 → see only their events
- [ ] Login as organizer 2 → see only their events
- [ ] Login as Super Admin → see ALL events from both

---

## 📊 Expected Results

### **After Creating 3 Events:**

**Organizer View (`/manage/events`):**
```
My Events (3)
├── Summer Music Festival 2026
│   └── Tickets: 2 types, 0 sold
├── Tech Innovation Summit 2026
│   └── Tickets: 2 types, 0 sold
└── Annual Charity Gala 2026
    └── Tickets: 2 types, 0 sold

Total Revenue: $0
```

**Super Admin View (`/admin`):**
```
Platform Dashboard
├── Total Accounts: 2
├── Total Events: 3
├── Total Revenue: $0
└── Active Organizers: 1

Recent Activity:
├── Event Organizer Co created 3 events
└── Account is active
```

---

## 🚀 Next Steps After Testing

1. **Test Ticket Purchases:**
   - Use Stripe test card: `4242 4242 4242 4242`
   - Buy tickets as a customer
   - See revenue appear in dashboards

2. **Test Attendee Management:**
   - View purchased tickets
   - Export attendee lists
   - Generate check-in QR codes

3. **Test Communications:**
   - Send email to attendees
   - Bulk messaging by ticket type

4. **Test Promo Codes:**
   - Create discount codes
   - Test percentage and fixed discounts
   - Hidden tickets with codes

---

## 🆘 Troubleshooting

### **Can't see events:**
- Make sure event status is "Published"
- Check you're logged into correct account
- Refresh the page

### **Can't access /admin:**
- Only Super Admin can access
- Regular organizers will be redirected

### **Events showing for wrong organizer:**
- Logout and login again
- Clear browser cache
- Check which email you're logged in with

---

## 📝 Summary

This testing guide shows:
1. ✅ How organizers create and manage events
2. ✅ How Super Admin sees everything
3. ✅ Data isolation between organizers
4. ✅ Impersonation for customer support
5. ✅ Platform-wide vs account-specific views

**Now you're ready to test the full platform!** 🎉

Login as the organizer and start creating those 3 events!
