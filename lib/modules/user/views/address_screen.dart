import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/user/controllers/order_controller.dart';
import 'package:green_leaf/modules/user/views/payment_screen.dart';

class AddressScreen extends StatefulWidget {
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final List<Map<String, dynamic>> cartItems;

  const AddressScreen({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.cartItems,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final areaController = TextEditingController();
  final houseController = TextEditingController();
  final streetController = TextEditingController();
  final wayController = TextEditingController();
  final phoneController = TextEditingController();

  final OrderController _addressController = OrderController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    final previousAddress = await _addressController.getPreviousAddress();
    if (previousAddress != null) {
      areaController.text = previousAddress['area'] ?? '';
      houseController.text = previousAddress['house'] ?? '';
      streetController.text = previousAddress['street'] ?? '';
      wayController.text = previousAddress['way'] ?? '';
      phoneController.text = previousAddress['phone'] ?? '';
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFC4D0C0),
      appBar: AppBar(
        backgroundColor: const Color(0XFFC4D0C0),
        centerTitle: true,
        title: Text(
          "Address Details",
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    buildTextField("Area", areaController),
                    buildTextField("House Number", houseController),
                    buildTextField(
                      "Street Number",
                      streetController,
                      keyboardType: TextInputType.number,
                    ),
                    buildTextField(
                      "Way Number",
                      wayController,
                      keyboardType: TextInputType.number,
                    ),
                    buildTextField(
                      "Phone Number",
                      phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 70),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFF456B2E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final address = {
                            "area": areaController.text,
                            "house": houseController.text,
                            "street": streetController.text,
                            "way": wayController.text,
                            "phone": phoneController.text,
                          };

                          // // 🔹 Save to Firebase users collection (optional)
                          // await _addressController.saveUserAddress(address);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentScreen(
                                cartItems: widget.cartItems,
                                subtotal: widget.subtotal,
                                deliveryFee: widget.deliveryFee,
                                serviceFee: widget.serviceFee,
                                address: address,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Save Address",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) return "Enter $label";

          // Phone number validation
          if (label == "Phone Number") {
            // Remove spaces just in case
            String val = value.replaceAll(' ', '');

            // Check length exactly 8
            if (val.length != 8) {
              return "Phone number must be 8 digits";
            }

            // Check starts with 9 or 7 and all digits
            if (!RegExp(r'^[79][0-9]{7}$').hasMatch(val)) {
              return "Phone number must start with 9 or 7 and contain only digits";
            }
          }

          // Way Number validation (numeric only)
          if (label == "Way Number") {
            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return "$label must be numeric";
            }
            if (value.length < 1 || value.length > 6) {
              return "Way Number Accepts Only Numbers Length 1-6";
            }
          }
          if (label == "Street Number") {
            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return "$label must be numeric";
            }
            if (value.length < 1 || value.length > 6) {
              return "Street Number Accepts Only Numbers Length 1-6";
            }
          }

          // House Number or Street Number validation (optional numeric check)
          if (label == "House Number") {
            // Remove spaces just in case
            String val = value.replaceAll(' ', '');

            // Check total length 1-6
            if (val.length < 1 || val.length > 6) {
              return "House Number must be 1-6 characters long";
            }

            // Regex for 2-6 digits
            bool digitsOnly = RegExp(r'^\d{2,6}$').hasMatch(val);

            // Regex for number + exactly 2 letters at the end (e.g., 12AB)
            bool numberWith2Letters = RegExp(r'^\d+[A-Z]{2}$').hasMatch(val);

            if (!digitsOnly && !numberWith2Letters) {
              return "House Number must be 2-6 digits or a number with 2 letters (A-Z)";
            }
          }

          // Area validation (letters only)
          if (label == "Area") {
            if (value.length < 3 || value.length > 30) {
              return "Area must be 3-30 characters";
            }
            if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
              return "Area cannot contain numbers or special characters";
            }
          }

          return null; // validation passed
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(
            color: const Color(0XFF39571E).withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0XFF3B6C1E).withOpacity(0.6),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0XFF3B6C1E).withOpacity(0.6),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0XFF3B6C1E).withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}
