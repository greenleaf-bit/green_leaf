import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/auth_controller.dart'; // apna path lagana

class ChangeAddressScreen extends StatefulWidget {
  const ChangeAddressScreen({super.key});

  @override
  State<ChangeAddressScreen> createState() => _ChangeAddressScreenState();
}

class _ChangeAddressScreenState extends State<ChangeAddressScreen> {
  final TextEditingController _addressController = TextEditingController();
  final AuthController _authController = AuthController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Change Address",
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
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            const SizedBox(height: 60),
            TextFormField(
              controller: _addressController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'New Address',
                labelStyle: GoogleFonts.inter(
                  color: const Color(0XFF476C2F),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0XFF3B6C1E).withOpacity(0.6),
                  ),
                ),
              ),
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
              onPressed: _isLoading
                  ? null
                  : () async {
                      if (_addressController.text.isNotEmpty) {
                        setState(() => _isLoading = true);
                        await _authController.updateAddress(
                          _addressController.text,
                        );
                        setState(() => _isLoading = false);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Address updated successfully!"),
                          ),
                        );

                        Navigator.pop(context);
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
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
    );
  }
}
