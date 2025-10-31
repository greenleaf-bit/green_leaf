import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/admin/views/manage_customers.dart';
import 'package:green_leaf/modules/admin/views/manage_orders.dart';
import 'package:green_leaf/modules/admin/views/manage_products.dart';
import 'package:green_leaf/modules/admin/views/manage_report_screen.dart';
import 'package:green_leaf/modules/user/views/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomeScreen extends StatelessWidget {
  final Function(int) onTabChange;
  const AdminHomeScreen({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFC4D0C0),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/adminleaf.png",
                  height: 110,
                  width: 110,
                ),
                const SizedBox(width: 5),
                Text(
                  "Hey Admin",
                  style: GoogleFonts.lexend(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Color(0XFF336105),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool(
                      'is_logged_in',
                      false,
                    ); // 🔹 session off
                    // await prefs.setBool('fingerprint_enabled', false);
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
                    "Logout",
                    style: GoogleFonts.lexend(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF336105),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(thickness: 1, color: Color(0xFF3B6C1E).withOpacity(0.6)),
            const SizedBox(height: 20),
            Text(
              "Admin Dashboard",
              style: GoogleFonts.inter(
                fontSize: 20,

                fontWeight: FontWeight.w600,
                color: Color(0XFF456B2E),
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => onTabChange(1),

                  child: Container(
                    height: 160,
                    width: 155,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/product.png",
                            height: 90,
                            width: 90,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Manage Products",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0XFF456B2E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => onTabChange(2),

                  child: Container(
                    height: 160,
                    width: 155,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/order.png",
                            height: 90,
                            width: 90,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Manage Orders",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0XFF456B2E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => onTabChange(3),
                  child: Container(
                    height: 160,
                    width: 155,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/customer.png",
                            height: 90,
                            width: 90,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Manage Customers",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0XFF456B2E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => onTabChange(4),
                  child: Container(
                    height: 160,
                    width: 155,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/report.png",
                            height: 90,
                            width: 90,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Manage Reports",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0XFF456B2E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
