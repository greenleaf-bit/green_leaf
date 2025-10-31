import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/user/controllers/auth_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentController = TextEditingController();

  final TextEditingController _newController = TextEditingController();

  final TextEditingController _confirmController = TextEditingController();

  final AuthController _authController = AuthController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Change Password",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                TextFormField(
                  controller: _currentController,
                  obscureText: true,
                  decoration: inputDecoration("Current Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Current Password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _newController,
                  obscureText: true,

                  decoration: inputDecoration("New Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter New Password";
                    }
                    if (value.length < 8) {
                      return 'Password must be more than 8 characters long';
                    }
                    // Regex check for letters, numbers, and special characters
                    bool hasLetter = value.contains(RegExp(r'[A-Za-z]'));
                    bool hasNumber = value.contains(RegExp(r'[0-9]'));
                    bool hasSpecial = value.contains(
                      RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
                    );

                    if (!hasLetter || !hasNumber || !hasSpecial) {
                      return 'Password must be combination of  letters, numbers, and special characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmController,
                  obscureText: true,
                  decoration: inputDecoration("Confirm New Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Confirm New Password";
                    }
                    final newPass = _newController.text.trim();

                    if (newPass != value) {
                      return 'Password does not match';
                    }
                  },
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF5C8B40),
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState == null ||
                        !_formKey.currentState!.validate()) {
                      return;
                    }

                    setState(() {
                      isLoading = true;
                    });

                    final current = _currentController.text.trim();
                    final newPass = _confirmController.text.trim();

                    try {
                      await _authController.changePassword(
                        currentPassword: current,
                        newPassword: newPass,
                        context: context,
                      );
                    } finally {
                      if (mounted) {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },

                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
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
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String label) {
    return InputDecoration(
      errorMaxLines: 2,
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
