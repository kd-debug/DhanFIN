# DhanFIN - Appwrite Setup Guide

## Why Appwrite?
✅ **100% Free** - No credit card needed  
✅ **No Downloads** - Cloud-hosted, ready to use  
✅ **Easy Setup** - 5 minutes to get started  
✅ **Built-in Auth** - Email/password + OAuth support  
✅ **Open Source** - Transparent and reliable  

---

## Quick Setup (5 Minutes)

### Step 1: Create Appwrite Account

1. Go to **[Appwrite Cloud](https://cloud.appwrite.io/)**
2. Click **"Sign Up"**
3. Create account with your email/Google/GitHub
4. Verify your email if required

### Step 2: Create a New Project

1. After logging in, click **"Create Project"**
2. Enter project details:
   - **Name**: DhanFIN (or any name you like)
   - **Project ID**: Will be auto-generated
3. Click **"Create"**
4. Your project is ready instantly! 🎉

### Step 3: Get Your Project ID

1. In your project dashboard, you'll see your **Project ID** at the top
2. Copy this Project ID (Example: `65f1234567890abcdef`)

### Step 4: Update Your Flutter App

1. Open `lib/main.dart`
2. Find this line:
   ```dart
   projectId: 'YOUR_PROJECT_ID',
   ```
3. Replace `YOUR_PROJECT_ID` with your actual Project ID:
   ```dart
   projectId: '65f1234567890abcdef',  // Your Project ID from Appwrite
   ```

### Step 5: Enable Email Authentication

1. In Appwrite Console, go to **Auth** (left sidebar)
2. Click on **Settings** tab
3. Scroll to **Auth Methods**
4. Enable **Email/Password**:
   - Toggle it ON
   - Click **Update**

### Step 6: Configure Email Settings (Optional but Recommended)

#### For Email Verification & Password Reset:

1. In **Auth** → **Settings**
2. Scroll to **Email Templates**
3. You'll see templates for:
   - **Email Verification**
   - **Password Recovery**
   - **Magic URL**

4. **Default Configuration** (Works immediately):
   - Appwrite uses default SMTP
   - Emails will be sent from `noreply@appwrite.io`
   - Rate limited but sufficient for testing

5. **Custom SMTP** (For production - optional):
   - Scroll to **SMTP Configuration**
   - Click **Update SMTP Settings**
   - Add your SMTP provider details:
     - **Host**: e.g., `smtp.gmail.com`
     - **Port**: 587 or 465
     - **Username**: Your email
     - **Password**: App password
     - **Sender Email**: Your email
     - **Sender Name**: DhanFIN

### Step 7: Set Email Verification URLs

1. In **Auth** → **Settings**
2. Find **Security** section
3. Set redirect URLs:
   - **Success URL**: `https://yourapp.com/success` (can be any URL for now)
   - **Failure URL**: `https://yourapp.com/failure` (can be any URL for now)

These URLs are where users will be redirected after clicking email links.

### Step 8: Install Dependencies

Open terminal in your project folder and run:

```bash
flutter pub get
```

### Step 9: Test Your App

```bash
flutter run
```

---

## Complete Configuration Summary

### Your main.dart should look like this:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Appwrite
  AuthService().initialize(
    endpoint: 'https://cloud.appwrite.io/v1',  // Don't change this
    projectId: '65f1234567890abcdef',  // Your Project ID here
  );

  runApp(const DhanFINApp());
}
```

---

## Testing the Setup

### 1. **Register a New User**
   - Open your app
   - Click "Sign Up"
   - Fill in the form with a **real email address**
   - Submit

### 2. **Check Email**
   - Check your inbox (and spam folder)
   - Look for verification email from Appwrite
   - Click the verification link

### 3. **Login**
   - Return to the app
   - Enter your email and password
   - Click "Log In"
   - You should be logged in successfully! ✅

---

## Troubleshooting

### ❌ "Invalid credentials" error
**Solution**: Make sure you copied the correct Project ID from Appwrite Console

### ❌ Not receiving verification emails
**Solutions**:
- Check spam/junk folder
- Wait 2-3 minutes (email delivery can be delayed)
- Try with different email provider (Gmail, Outlook)
- For production, configure custom SMTP

### ❌ Build errors after flutter pub get
**Solutions**:
```bash
flutter clean
flutter pub get
flutter run
```

### ❌ Account created but can't login
**Solution**: 
- Email verification is optional in the current setup
- Login should work even without verification
- If issues persist, check Appwrite Console → Auth → Users to see if account exists

---

## Appwrite Console Features

### View All Users
1. Go to **Auth** → **Users**
2. See all registered users
3. Can manually verify/delete users
4. View user sessions

### Check Sessions
1. **Auth** → **Users** → Click on a user
2. See active sessions
3. Can manually revoke sessions

### View Logs
1. Go to **Logs** in left sidebar
2. See all API calls
3. Debug authentication issues

---

## Key Differences from Supabase

| Feature | Appwrite | Supabase |
|---------|----------|----------|
| Setup Time | 5 minutes | 10-15 minutes |
| Email Config | Optional (has default) | Required for production |
| Dashboard | Very user-friendly | More technical |
| Free Tier | Generous, no credit card | Requires email verification |
| Email Verification | Optional by default | Enforced |

---

## Production Checklist

Before deploying to production:

- [ ] Set up custom SMTP for reliable email delivery
- [ ] Configure proper redirect URLs for your domain
- [ ] Enable email verification enforcement (optional)
- [ ] Set up rate limiting in Appwrite Console
- [ ] Enable 2FA for your Appwrite account
- [ ] Set up team access if working with others
- [ ] Monitor usage in Appwrite Console

---

## Recommended SMTP Providers (Free Tiers)

1. **SendGrid**
   - Free: 100 emails/day
   - Easy setup
   - Reliable delivery

2. **Mailgun**
   - Free: 5,000 emails/month
   - Good for startups

3. **Brevo (formerly Sendinblue)**
   - Free: 300 emails/day
   - Great deliverability

4. **Gmail SMTP** (Testing only)
   - Free: 500 emails/day
   - Not recommended for production

---

## Advanced Configuration (Optional)

### Enable OAuth Providers

1. **Auth** → **Settings** → **OAuth2 Providers**
2. Enable Google/Facebook/GitHub login
3. Add OAuth credentials from respective platforms

### Set Password Requirements

1. **Auth** → **Settings** → **Security**
2. Configure:
   - Minimum password length (default: 8)
   - Password expiry
   - Session duration

### Rate Limiting

1. **Auth** → **Settings** → **Security**
2. Configure request limits to prevent abuse

---

## Support & Resources

- **Appwrite Documentation**: https://appwrite.io/docs
- **Flutter SDK Docs**: https://appwrite.io/docs/sdks#client
- **Community Discord**: https://appwrite.io/discord
- **GitHub Issues**: https://github.com/appwrite/appwrite

---

## Next Steps After Setup

1. ✅ Authentication is working
2. ✅ Users can register and login
3. ✅ Email verification is configured
4. ⏭️ Build the financial dashboard
5. ⏭️ Add database collections for transactions
6. ⏭️ Implement data storage and retrieval

---

## Why Appwrite is Better for Beginners

✅ **No complex configuration** - Works out of the box  
✅ **Visual dashboard** - Easy to understand  
✅ **Clear error messages** - Better debugging  
✅ **No credit card** - Truly free to start  
✅ **Active community** - Fast support  

---

**Your app is now using Appwrite! 🚀**

If you have any issues, check the Appwrite Console logs or ask for help!
