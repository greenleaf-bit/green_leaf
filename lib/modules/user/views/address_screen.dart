import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/user/views/payment_screen.dart';

class AddressScreen extends StatefulWidget {
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;

  const AddressScreen({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFC4D0C0),
      appBar: AppBar(
        backgroundColor: const Color(0XFFC4D0C0),
        centerTitle: true,
        title: const Text("Add Address"),
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
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField("Area", areaController),
              buildTextField("House Number", houseController),
              buildTextField("Street Number", streetController),
              buildTextField("Way Number", wayController),
              buildTextField(
                "Phone Number",
                phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF456B2E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final address = {
                      "area": areaController.text,
                      "house": houseController.text,
                      "street": streetController.text,
                      "way": wayController.text,
                      "phone": phoneController.text,
                    };
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentScreen(
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
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
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
        validator: (value) =>
            value == null || value.isEmpty ? "Enter $label" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
