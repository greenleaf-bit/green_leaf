import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/user/controllers/order_controller.dart';
import '../controllers/auth_controller.dart';

class ChangeAddressScreen extends StatefulWidget {
  const ChangeAddressScreen({super.key});

  @override
  State<ChangeAddressScreen> createState() => _ChangeAddressScreenState();
}

class _ChangeAddressScreenState extends State<ChangeAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final areaController = TextEditingController();
  final houseController = TextEditingController();
  final streetController = TextEditingController();
  final wayController = TextEditingController();
  final phoneController = TextEditingController();

  final OrderController _orderController = OrderController();
  bool _loading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    final userAddress = await _orderController.getPreviousAddress();
    if (userAddress != null) {
      areaController.text = userAddress['area'] ?? '';
      houseController.text = userAddress['house'] ?? '';
      streetController.text = userAddress['street'] ?? '';
      wayController.text = userAddress['way'] ?? '';
      phoneController.text = userAddress['phone'] ?? '';
    }
    setState(() => _loading = false);
  }

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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // 🔹 Area Dropdown
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: DropdownButtonFormField<String>(
                        value: areaController.text.isNotEmpty
                            ? areaController.text
                            : null,
                        decoration: InputDecoration(
                          labelText: "Area",
                          labelStyle: GoogleFonts.inter(
                            color: const Color(0XFF39571E).withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          border: const UnderlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "AdDakhiliyah",
                            child: Text("AdDakhiliyah"),
                          ),
                          DropdownMenuItem(
                            value: "AdDhahirah",
                            child: Text("AdDhahirah"),
                          ),
                          DropdownMenuItem(
                            value: "AlBatinah North",
                            child: Text("AlBatinah North"),
                          ),
                          DropdownMenuItem(
                            value: "AlBatinah South",
                            child: Text("AlBatinah South"),
                          ),
                          DropdownMenuItem(
                            value: "AlBuraimi",
                            child: Text("AlBuraimi"),
                          ),
                          DropdownMenuItem(
                            value: "AlWusta",
                            child: Text("AlWusta"),
                          ),
                          DropdownMenuItem(
                            value: "AshSharqiyah North",
                            child: Text("AshSharqiyah North"),
                          ),
                          DropdownMenuItem(
                            value: "AshSharqiyah South",
                            child: Text("AshSharqiyah South"),
                          ),
                          DropdownMenuItem(
                            value: "Dhofar",
                            child: Text("Dhofar"),
                          ),
                          DropdownMenuItem(
                            value: "Musandam",
                            child: Text("Musandam"),
                          ),
                          DropdownMenuItem(
                            value: "Muscat",
                            child: Text("Muscat"),
                          ),
                        ],
                        onChanged: (value) => areaController.text = value ?? '',
                        validator: (value) => value == null || value.isEmpty
                            ? "Select area"
                            : null,
                      ),
                    ),

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
                        backgroundColor: const Color(0XFF5C8B40),
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: _isSaving
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final address = {
                                  "area": areaController.text,
                                  "house": houseController.text,
                                  "street": streetController.text,
                                  "way": wayController.text,
                                  "phone": phoneController.text,
                                };

                                setState(() => _isSaving = true);
                                await _orderController.updateAddress(address);
                                setState(() => _isSaving = false);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Address updated successfully!",
                                    ),
                                  ),
                                );

                                Navigator.pop(context);
                              }
                            },
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Save Changes',
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
          errorMaxLines: 2,
          labelStyle: GoogleFonts.inter(
            color: const Color(0XFF39571E).withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }
}
