import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/user/views/account_info_screen.dart';
import 'package:green_leaf/modules/user/views/change_address_screen.dart';
import 'package:green_leaf/modules/user/views/change_email_screen.dart';
import 'package:green_leaf/modules/user/views/change_password_screen.dart';
import 'package:green_leaf/modules/user/views/login_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

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
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) {
                      return AccountInfo();
                    },
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8), // halka rounded effect
              splashColor: Colors.green.withOpacity(0.2), // ripple color
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      "Account Info",
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
            ),
            Divider(thickness: 1, color: Color(0XFF3B6C1E)),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) {
                      return ChangeAddressScreen();
                    },
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8), // halka rounded effect
              splashColor: Colors.green.withOpacity(0.2), // ripple color
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      "Change Address",
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
            ),
            Divider(thickness: 1, color: Color(0XFF3B6C1E)),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) {
                      return ChangeEmailScreen();
                    },
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8), // halka rounded effect
              splashColor: Colors.green.withOpacity(0.2), // ripple color
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      "Change Email",
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
            ),
            Divider(thickness: 1, color: Color(0XFF3B6C1E)),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) {
                      return ChangePasswordScreen();
                    },
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8), // halka rounded effect
              splashColor: Colors.green.withOpacity(0.2), // ripple color
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
                child: Row(
                  children: [
                    Text(
                      "Change Password",
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
            ),
            Divider(thickness: 1, color: Color(0XFF3B6C1E)),

            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) {
                      return LoginScreen();
                    },
                  ),
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
}
