import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/core/utils/biometric_helper.dart';
import 'package:green_leaf/modules/user/views/account_info_screen.dart';
import 'package:green_leaf/modules/user/views/change_address_screen.dart';
import 'package:green_leaf/modules/user/views/change_email_screen.dart';
import 'package:green_leaf/modules/user/views/change_password_screen.dart';
import 'package:green_leaf/modules/user/views/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _fingerprintEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadFingerprintSetting();
  }

  void _loadFingerprintSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fingerprintEnabled = prefs.getBool('fingerprint_enabled') ?? false;
    });
  }

  void _toggleFingerprint(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    final bioHelper = BiometricHelper();

    setState(() {
      _fingerprintEnabled = val;
    });

    await prefs.setBool('fingerprint_enabled', val);

    if (val) {
      // Enable fingerprint → save saved credentials
      final email = prefs.getString('saved_email') ?? '';
      final password = prefs.getString('saved_password') ?? '';
      if (email.isNotEmpty && password.isNotEmpty) {
        await bioHelper.saveCredentials(email, password);
      }
    }
    // If disabled, we just skip biometric login, credentials remain
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Settings",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0XFF476C2F),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0XFF476C2F),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
        child: Column(
          children: [
            // Account Info
            _buildSettingRow(
              context,
              title: "Account Info",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AccountInfo()),
                );
              },
            ),
            Divider(thickness: 1, color: Color(0XFF3B6C1E)),

            // Change Address
            _buildSettingRow(
              context,
              title: "Change Address",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChangeAddressScreen()),
                );
              },
            ),
            Divider(thickness: 1, color: Color(0XFF3B6C1E)),

            // Change Email
            _buildSettingRow(
              context,
              title: "Change Email",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChangeEmailScreen()),
                );
              },
            ),
            Divider(thickness: 1, color: Color(0XFF3B6C1E)),

            // Change Password
            _buildSettingRow(
              context,
              title: "Change Password",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
                );
              },
            ),
            Divider(thickness: 1, color: Color(0XFF3B6C1E)),

            // Fingerprint Toggle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Row(
                children: [
                  Text(
                    "Enable Fingerprint",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Color(0XFF39571E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Switch(
                    value: _fingerprintEnabled,
                    onChanged: _toggleFingerprint,
                    activeColor: Color(0XFF476C2F),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, color: Color(0XFF3B6C1E)),

            // Logout
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('is_logged_in', false); // 🔹 session off
                await prefs.setBool('fingerprint_enabled', false);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
                );
              },
              child: Text(
                "LogOut",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Color(0XFFB33030),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      splashColor: Colors.green.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Color(0XFF39571E),
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_circle_right_rounded,
              size: 25,
              color: Color(0XFF39571E),
            ),
          ],
        ),
      ),
    );
  }
}
