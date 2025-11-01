import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/core/utils/validators.dart';
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
                        onChanged: (value) {
                          setState(() {
                            areaController.text = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select an area";
                          }
                          return null;
                        },
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

                          // // 🔹 Save to Firebase users collection
                          await _addressController.saveUserAddress(address);

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
        validator: (value) => AddressScreenValidators.validate(label, value),
        decoration: InputDecoration(
          labelText: label,
          errorMaxLines: 2,

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
