import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  late Client _client;
  late Account _account;
  models.User? _currentUser;

  // Initialize Appwrite
  void initialize({required String endpoint, required String projectId}) {
    _client = Client().setEndpoint(endpoint).setProject(projectId);
    _account = Account(_client);
  }

  // Get current user
  models.User? get currentUser => _currentUser;

  // Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  // Get user metadata (name, email, etc.)
  Map<String, dynamic>? get userMetadata {
    if (_currentUser == null) return null;
    return {'full_name': _currentUser!.name, 'email': _currentUser!.email};
  }

  // Load current session
  Future<void> loadSession() async {
    try {
      _currentUser = await _account.get();
    } catch (e) {
      _currentUser = null;
    }
  }

  // Sign up with email verification required
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String mobile,
    required String dateOfBirth,
  }) async {
    try {
      // Create account with unique ID
      final userId = ID.unique();
      await _account.create(
        userId: userId,
        email: email,
        password: password,
        name: fullName,
      );

      // Appwrite automatically sends verification email if configured
      // Create email verification
      try {
        await _account.createVerification(
          url: 'https://yourapp.com/verify', // This can be any URL
        );
      } catch (e) {
        // Verification email sending might fail but account is created
        print('Verification email error: $e');
      }

      // Store additional user data in preferences (prefs)
      try {
        await _account.updatePrefs(
          prefs: {'mobile': mobile, 'date_of_birth': dateOfBirth},
        );
      } catch (e) {
        print('Error saving preferences: $e');
      }
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Sign in with email and password
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      // Load user data
      _currentUser = await _account.get();

      // Note: Email verification check
      // Appwrite doesn't block login for unverified emails by default
      // You can check verification status with _currentUser.emailVerification
      if (!_currentUser!.emailVerification) {
        // Optional: You can choose to enforce verification here
        // await signOut();
        // throw Exception('Please verify your email address before signing in.');

        // For now, we'll allow login but you can uncomment above to enforce
      }
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      _currentUser = null;
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  // Reset password
  Future<void> resetPassword({required String email}) async {
    try {
      await _account.createRecovery(
        email: email,
        url: 'https://yourapp.com/reset', // Password reset redirect URL
      );
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to send reset email: ${e.toString()}');
    }
  }

  // Update user profile
  Future<void> updateProfile({String? fullName, String? mobile}) async {
    try {
      if (fullName != null) {
        await _account.updateName(name: fullName);
      }

      if (mobile != null) {
        // Get current prefs and convert to Map
        final currentPrefs = _currentUser?.prefs ?? <String, dynamic>{};
        final prefsMap = Map<String, dynamic>.from(currentPrefs as Map);
        prefsMap['mobile'] = mobile;
        await _account.updatePrefs(prefs: prefsMap);
      }

      // Reload user data
      _currentUser = await _account.get();
    } on AppwriteException catch (e) {
      throw _handleAppwriteException(e);
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }

  // Handle Appwrite exceptions
  String _handleAppwriteException(AppwriteException e) {
    switch (e.code) {
      case 401:
        return 'Invalid email or password. Please try again.';
      case 409:
        return 'An account with this email already exists.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 400:
        if (e.message?.contains('password') ?? false) {
          return 'Password must be at least 8 characters.';
        }
        return e.message ?? 'Invalid request. Please check your input.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
}
