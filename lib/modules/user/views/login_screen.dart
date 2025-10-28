import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/core/utils/custom_textfield.dart';
import 'package:green_leaf/modules/user/controllers/auth_controller.dart';
import 'package:green_leaf/modules/user/views/forgot_password_screen.dart';
import 'package:green_leaf/modules/user/views/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/biometric_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  bool isLoading = false;
  bool _fingerprintEnabled = false; // ✅ toggle state
  /*************  ✨ Windsurf Command ⭐  *************/
  /// Login user with given email and password.
  ///
  /// If the form is valid, set the loading state to true and call the loginUser method of the AuthController.
  /*******  aa7b25ab-a08a-40bf-b09c-40c877d34f7f  *******/
  @override
  void initState() {
    super.initState();
    _loadFingerprintSetting();
    _tryAutoBiometricLogin();
  }

  void _loadFingerprintSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fingerprintEnabled = prefs.getBool('fingerprint_enabled') ?? false;
    });
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await _authController.loginUser(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        context: context,
      );

      // 🔹 Always save credentials
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_email', emailController.text.trim());
      await prefs.setString('saved_password', passwordController.text.trim());

      // 🔹 Enable fingerprint if toggle is ON
      final bioHelper = BiometricHelper();
      if (_fingerprintEnabled) {
        await bioHelper.saveCredentials(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _tryAutoBiometricLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('fingerprint_enabled') ?? false;

    if (!isEnabled) return;

    final bioHelper = BiometricHelper();
    final canUse = await bioHelper.canAuthenticate();
    if (!canUse) return;

    final success = await bioHelper.authenticateUser();
    if (success) {
      final creds = await bioHelper.getSavedCredentials();
      if (creds != null) {
        await _authController.loginUser(
          email: creds['email']!,
          password: creds['password']!,
          context: context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 140),
                Text(
                  'Login',
                  style: GoogleFonts.inter(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF39571E),
                  ),
                ),
                Text(
                  "Login to your new account",
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFA5AFA8),
                  ),
                ),
                SizedBox(height: 20),
                CustomTextField(
                  controller: emailController,
                  hintText: "Email",
                  prefixIcon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  obscureText: true,
                  controller: passwordController,
                  hintText: "Password",
                  prefixIcon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Password';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 19),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.inter(
                          color: Color(0xFF325A3E),
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                // 🔹 Fingerprint Toggle Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SwitchListTile(
                    activeColor: Color(0xFF325A3E),
                    inactiveTrackColor: Color(0xFFA5AFA8).withOpacity(0.2),
                    title: Text(
                      "Enable Fingerprint",
                      style: GoogleFonts.inter(
                        color: Color(0xFF325A3E),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    value: _fingerprintEnabled,
                    onChanged: (val) async {
                      final prefs = await SharedPreferences.getInstance();
                      setState(() {
                        _fingerprintEnabled = val;
                      });
                      await prefs.setBool('fingerprint_enabled', val);
                      final bioHelper = BiometricHelper();
                      if (val) {
                        await bioHelper.saveCredentials(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      }
                    },
                  ),
                ),
                Image.asset(
                  "assets/images/login_image.png",
                  width: 190,
                  height: 190,
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF456B2E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      onPressed: login,
                      child: Center(
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Text(
                                'Login',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account? ",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF999999),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF39571E),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
