import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'login_or_register_page.dart';
import 'login_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late SharedPreferences _prefs;
  bool _isLoggedIn = false; // Local variable to track login state

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _isLoggedIn =
            user != null; // Update login state based on Firebase auth state
      });
    });
  }

  // Method to initialize SharedPreferences
  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _isLoggedIn = _prefs.getBool('isLoggedIn') ?? false; // Retrieve login state
  }

  // Method to save login state to SharedPreferences
  Future<void> _saveLoginState(bool isLoggedIn) async {
    await _prefs.setBool('isLoggedIn', isLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoggedIn ? HomePage() : LoginOrRegisterPage(),
    );
  }
}
