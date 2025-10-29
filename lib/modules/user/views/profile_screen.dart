import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/user/views/help_center_screen.dart';
import 'package:green_leaf/modules/user/views/notification_screen.dart';
import 'package:green_leaf/modules/user/views/setting_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = ""; // <-- yahan store hoga firebase se name

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          userName = doc["fullname"] ?? "User";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, top: 50, right: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/icons/profile_icon.png"),
                SizedBox(width: 15),
                Text(
                  "Hey $userName",
                  style: GoogleFonts.lexend(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Color(0XFF336105),
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) {
                          return SettingScreen();
                        },
                      ),
                    );
                  },
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
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) {
                      return NotificationScreen();
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
                      Icons.notifications_outlined,
                      size: 30,
                      color: Color(0XFF336105),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Notifications",
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
