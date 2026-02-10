import 'package:flutter/material.dart';
import 'package:project_android/services/auth_service.dart';
import 'package:project_android/screens/auth/login_screen.dart';
import 'package:project_android/screens/home/dashboard_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AuthService().initialize(
    endpoint: 'https://cloud.appwrite.io/v1',
    projectId: '698ade020006663ff8ac',
  );

  runApp(const DhanFINApp());
}

class DhanFINApp extends StatelessWidget {
  const DhanFINApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DhanFIN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 19, 68, 23),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 19, 68, 23),
          primary: const Color(0xFF1B5E20),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      await AuthService().loadSession();
      setState(() {
        _isLoggedIn = AuthService().isLoggedIn;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1B5E20),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    return _isLoggedIn ? const DashboardScreen() : const LoginScreen();
  }
}
