import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/user/controllers/auth_controller.dart';
import 'package:green_leaf/modules/user/views/login_screen.dart';
import 'package:green_leaf/modules/user/views/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    _checkSession(); // session check
  }

  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (isLoggedIn) {
      final email = prefs.getString('saved_email');
      final password = prefs.getString('saved_password');

      if (email != null && password != null) {
        // 🔹 Auto-login directly to home/admin
        await _authController.loginUser(
          email: email,
          password: password,
          context: context,
          skipSnackBar: false,
        );
        return; // important
      }
    }

    // 🔹 If not logged in → go to LoginScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 260,
            left: 75,
            right: 75,
            child: Image.asset("assets/images/greenleaf.png"),
          ),
          Positioned(
            top: 200,
            left: 70,
            right: 70,
            child: Image.asset("assets/images/scanner.png"),
          ),
          Positioned(
            top: 510,
            left: 93,
            right: 93,
            child: RichText(
              text: TextSpan(
                text: 'Green',
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Leaf',
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF3A7F0D),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset("assets/images/splashcolor.png", fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: Text(
                    "Your One-Stop Shop for Green Goodness",
                    style: GoogleFonts.lexend(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
