import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/user/views/help_center_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 30, top: 50, right: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/icons/profile_icon.png"),
                SizedBox(width: 15),
                Text(
                  "Hey Muatism",
                  style: GoogleFonts.lexend(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Color(0XFF336105),
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.settings_outlined, size: 33),
                ),
              ],
            ),
            SizedBox(height: 40),
            Divider(thickness: 1, color: Color(0XFF3B6C1E)),
            SizedBox(height: 40),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) {
                      return HelpCenterScreen();
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
                    Icon(
                      Icons.help_outlined,
                      size: 30,
                      color: Color(0XFF336105),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Help Center",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Color(0XFF39571E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
