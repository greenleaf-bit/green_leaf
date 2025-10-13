import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/user/controllers/auth_controller.dart';

class ChangeEmailScreen extends StatelessWidget {
  ChangeEmailScreen({super.key});

  final _newEmailController = TextEditingController();
  final _confirmEmailController = TextEditingController();

  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Change Email",
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 60),
            TextFormField(
              controller: _newEmailController,
              decoration: inputDecoration("New Email"),
            ),
            TextFormField(
              controller: _confirmEmailController,
              decoration: inputDecoration("Confirm New Email"),
            ),
            const SizedBox(height: 160),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF5C8B40),
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                if (_newEmailController.text.trim() !=
                    _confirmEmailController.text.trim()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Emails do not match")),
                  );
                  return;
                }

                _authController.changeEmail(
                  newEmail: _newEmailController.text.trim(),
                  context: context,
                );
              },
              child: Text(
                'Submit',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(
        color: const Color(0XFF476C2F),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: const Color(0XFF3B6C1E).withOpacity(0.6)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: const Color(0XFF3B6C1E).withOpacity(0.6)),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: const Color(0XFF3B6C1E).withOpacity(0.6)),
      ),
    );
  }
}
