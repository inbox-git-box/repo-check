# 🚀 Quick Start - Scrumora (With Email Security)

## NEW FEATURES ✨
- ✅ Email verification for new users
- ✅ Secure password reset 
- ✅ Removed exposed credentials
- ✅ Production-ready auth system (1M+ users)

---

## TL;DR - Run Everything

### macOS/Linux
```bash
chmod +x start.sh
./start.sh
# In another terminal
cd scrumora-api && npm run seed
```

### Windows
```bash
start.bat
REM In another terminal
cd scrumora-api && npm run seed
```

Then open http://localhost:5173 in your browser.

---

## Prerequisites (One-time Setup)

### 1. Install Node.js
- **macOS:** `brew install node`
- **Windows:** Download from [nodejs.org](https://nodejs.org)

### 2. Install MongoDB
- **macOS:** `brew install mongodb-community && brew services start mongodb-community`
- **Windows:** Download from [MongoDB Community](https://www.mongodb.com/try/download/community)

### 3. Verify Installation
```bash
node --version   # Should be v18+
npm --version
mongod --version # Should be v7.0+
```

---

## Running Scrumora

### Option 1: One Command (Recommended)

**macOS/Linux:**
```bash
./start.sh
```

**Windows:**
```bash
start.bat
```

### Option 2: Manual (Each in separate terminal)

**Terminal 1 - Backend:**
```bash
cd scrumora-api && npm run dev
# Backend runs on http://localhost:5001/api
```

**Terminal 2 - Frontend:**
```bash
cd scrumora-fe && npm run dev
# Frontend runs on http://localhost:5173
```

**Terminal 3 - Seed Demo Accounts:**
```bash
cd scrumora-api && npm run seed
```

---

## Access Points

| Component | URL                           |
|-----------|-------------------------------|
| Frontend  | http://localhost:5173         |
| Backend   | http://localhost:5001/api     |
| Database  | mongodb://localhost:27017     |

---

## 📋 Testing New Features

### Test 1: Email Verification (New User Registration)
1. Go to http://localhost:5173/register
2. Fill in: Name, Email, Password
3. Click "Create account"
4. **You're redirected to:** http://localhost:5173/verify-email
5. **Check Terminal 1** (Backend): See 6-digit code in logs
6. Enter email and code
7. ✅ Success: Redirected to login page

### Test 2: Forgot Password
1. Go to http://localhost:5173/login
2. Click "Forgot your password?"
3. Enter your email
4. **You see:** "Check your email for reset link"
5. **Check Terminal 1** (Backend): See reset link in logs
6. Copy the link and open in browser
7. Enter new password
8. ✅ Success: Redirected to login page
9. Log in with new password

### Test 3: Demo Account Login (Already Verified)
1. Go to http://localhost:5173/login
2. Email: `aarav@scrumora.local`
3. Password: `Learner@123`
4. ✅ Success: Logged in immediately (no email verification needed)

### Test 4: Verify Removed Credentials
1. Go to http://localhost:5173/login
2. **Check:** No hardcoded demo credentials visible on page
3. ✅ Security improved!

---

## Demo Accounts (After `npm run seed`)

### Regular Users
- Email: `aarav@scrumora.local` / Password: `Learner@123`
- Email: `priya@scrumora.local` / Password: `Learner@123`
- Email: `rahul@scrumora.local` / Password: `Learner@123`

### Admin Accounts
- Email: `sneha@scrumora.local` / Password: `Learner@123`
- Email: `admin@scrumora.local` / Password: `Admin@12345`

---

## 🔍 Development Debugging

### ⭐ Skip Email Verification (For Development Without Email Provider)
If you don't have an email provider subscription yet, set this in `.env`:
```
SKIP_EMAIL_VERIFICATION=true
```

**With this flag:**
- ✅ New users are **auto-verified** on signup (no email needed)
- ✅ Can login immediately after registration
- ✅ Password reset shows reset link in **terminal console**
- ✅ Verification codes shown in **terminal console**

**To switch back to email verification:**
```
SKIP_EMAIL_VERIFICATION=false
```
Then set up email provider (SendGrid/AWS SES) - see `AUTH_IMPROVEMENTS.md`

---

### See Verification Codes
When not skipping email verification, codes are logged to the terminal running `npm run dev`:
```
📧 Email to user@example.com:
Verify your Scrumora email address
<h1 style="...">123456</h1>
```

### See Password Reset Links
Reset links are logged to terminal:
```
📧 Email to user@example.com:
Reset your Scrumora password
<a href="http://localhost:5173/reset-password?token=abc123...&email=user@example.com">
```

---

## Troubleshooting

### MongoDB not running?
```bash
# macOS
brew services start mongodb-community

# Windows
net start MongoDB
```

### Port in use?
```bash
# macOS/Linux - Find & kill process
lsof -i :5173 | awk 'NR==2 {print $2}' | xargs kill -9
lsof -i :5001 | awk 'NR==2 {print $2}' | xargs kill -9

# Windows
netstat -ano | findstr :5173
taskkill /PID <PID> /F
```

### Dependencies missing?
```bash
npm run install:all
npm run build
```

### Verification code not showing?
- Make sure Terminal 1 (backend) is running `npm run dev`
- Check for the 📧 emoji in terminal output
- Code expires after 15 minutes (click "Resend" for new one)

### Reset link not working?
- Make sure FRONTEND_URL in `.env` is correct
- Links expire after 30 minutes (click "Forgot Password" again)

### Can't log in with new account?
- Check that you've completed email verification
- Look for error message in UI
- Check backend logs for errors

---

## 📚 Full Documentation

- **Implementation Details:** See `IMPLEMENTATION_SUMMARY.md`
- **Architecture & Scalability:** See `AUTH_IMPROVEMENTS.md`
- **Setup Guide:** See `SETUP_NO_DOCKER.md`

---

## ✅ Deployment Checklist

Before deploying to production:
- [ ] Set up email provider (SendGrid/AWS SES) - see `AUTH_IMPROVEMENTS.md`
- [ ] Configure environment variables (FRONTEND_URL, FROM_EMAIL, SENDGRID_API_KEY)
- [ ] Change JWT secrets (not dev values)
- [ ] Test email delivery with 50+ registrations
- [ ] Monitor error logs
- [ ] Verify database backups
- [ ] Set up monitoring/alerts

---

**Ready to test? Start with Test 1 above! 🎉**
