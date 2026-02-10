# FinanceFlow - Flutter Financial Application

A professional Flutter-based financial application with authentication and user management, powered by **Appwrite**.

## 🎯 Project Status

### ✅ Completed Features

1. **Authentication System**
   - Login Screen with email/password authentication
   - Register Screen with comprehensive user information collection
   - Forgot Password Screen with email reset functionality
   - Email verification support
   - Integration with **Appwrite Backend**

2. **UI Design**
   - Clean, modern interface matching the design mockup
   - Professional dark green theme (#1B5E20)
   - Responsive layouts
   - Form validation
   - Loading states and error handling

3. **Security Features**
   - Email validation using `email_validator` package
   - Password strength requirements (minimum 8 characters for Appwrite)
   - Email verification support
   - Secure password reset flow

### 🔜 Upcoming Features

- Financial Dashboard with account summary
- Transaction history management
- Expense and income tracking
- Financial categories (Savings, Expenses, Investments)
- Data visualization and charts
- Budget management
- Financial insights and reports

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point and routing
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart         # Login screen
│   │   ├── register_screen.dart      # Registration screen
│   │   └── forgot_password_screen.dart # Password reset screen
│   └── home/
│       └── dashboard_screen.dart     # Main dashboard (placeholder)
└── services/
    └── auth_service.dart             # Supabase authentication service
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.10.4 or higher)
- Dart SDK
- A code editor (VS Code, Android Studio, etc.)
- An **Appwrite Cloud account** (100% free, no credit card needed)

### Installation Steps

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Set Up Appwrite**
   - Read the detailed setup guide in [APPWRITE_SETUP.md](APPWRITE_SETUP.md)
   - Create an Appwrite Cloud account at https://cloud.appwrite.io
   - Create a new project
   - Get your Project ID
   - Enable email authentication

3. **Update Credentials**
   - Open `lib/main.dart`
   - Replace the placeholder value:
     ```dart
     AuthService().initialize(
       endpoint: 'https://cloud.appwrite.io/v1',
       projectId: 'YOUR_PROJECT_ID',  // Replace with your Project ID
     );
     ```

4. **Run the App**
   ```bash
   flutter run
   ```

## 📦 Dependencies
appwrite: ^13.0.1` - Appwrite SDK
- `supabase_flutter: ^2.5.6` - Supabase client for authentication and backend
- `email_validator: ^3.0.0` - Email validation
- `intl: ^0.19.0` - Date formatting and internationalization
- `flutter_svg: ^2.0.10+1` - SVG support (for future icons/graphics)

## 🔐 Authentication Flow

1. **Registration**
   - User fills in: Full Name, Email, Mobile, Date of Birth, Password
   - Email validation ensures authentic email addresses
   - Password confirmation prevents typos
   - Appwrite creates account and sends verification email (optional)
   - User can login immediately or verify email first

2. **Login**
   - User enters email and password
   - Appwrite authenticates the credentials
   - User is logged in and redirected to dashboard
   - Email verification is optional (can be enforced if needed)

3. **Password Reset**
   - User enters email address
   - Appwrite sends password reset link
   - User clicks link and sets new password

## 🎨 Design Specifications

- **Primary Color**: #1B5E20 (Professional Dark Green)
- **Background**: #F5F5F5 (Light gray for forms)
- **Typography**: Roboto font family
- **UI Style**: Clean, modern, finance-focused design

## ⚙️ Configuration

### Email Verification Setup (Optional)

The app supports email verification via Appwrite:

1. In Appwrite Console → Auth → Settings
2. Email verification is optional by default
3. Users can login without verifying their email
4. To enforce verification, update the auth service code

### Customizing Email Templates

1. Go to Appwrite Console → Auth → Email Templates
2. Customize the verification and password reset emails
3. Add your branding and messaging

## 🧪 Testing the App

1. **Register a New Account**
   - Use a real email address you have access to
   - Fill in all required fields
   - Submit the form

2. **Login Immediately**
   - You can login right away
   - Email verification is optional

3. **Check Your Email (Optional)**
   - Look for the verification email from Appwrite
   - Click the verification link if you want to verify

## 🐛 Troubleshooting

### Cannot connect to Appwrite
- Make sure you've replaced `YOUR_PROJECT_ID` in main.dart
- Check that your Project ID is correct
- Verify internet connection

### Account created but can't login
- Check Appwrite Console → Auth → Users to verify account exists
- Ensure you're using the correct email and password
- Password must be at least 8 characters

### Not receiving emails
- Check spam/junk folder
- Verify email settings in Supabase Dashboard
- Consider setting up custom SMTP for production

### Build errors
```bash
flutter clean
flutter pub get
flutter run
```

## 📝 Next Development Steps

1. **Dashboard Implementation**
   - Account balance display
   - Summary cards for income/expenses
   - Quick action buttons

2. **Transaction Management**
   - Add/edit/delete transactions
   - Transaction history with filtering
   - Category assignment

3. **Financial Insights**
   - Spending charts and graphs
   - Budget tracking
   - Financial reports
   - Savings goals

4. **User Profile**
   - Profile editing
   - Settings management
   - Preferences

## 🔒 Security Best Practices

- ✅ Email verification required
- ✅ Password strength validation
- ✅ Secure password reset flow
- ✅ Input validation on all forms
- ✅ Supabase Row Level Security (to be implemented for database tables)
Appwrite Setup Guide](APPWRITE_SETUP.md) - Detailed Appwrite configuration
- [Flutter Documentation](https://docs.flutter.dev/)
- [Appwrite Documentation](https://appwrite.io
- [Supabase Setup Guide](SUPABASE_SETUP.md) - Detailed Supabase configuration
- [Flutter Documentation](https://docs.flutter.dev/)
- [Supabase Documentation](https://supabase.com/docs)

## 🤝 Contributing

This is a student project for MAD-CIE. Future enhancements will include:
- Dark mode support
- Biometric authentication
- Multi-currency support
- Export functionality
- Data backup and restore

## 📄 License

This project is part of an academic assignment.

---

**Current Version**: 1.0.0  
**Last Updated**: February 2026  
**Status**: Authentication Phase Complete ✅
