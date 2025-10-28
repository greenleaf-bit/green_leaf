import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardDetails extends StatefulWidget {
  const CardDetails({super.key});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController numberCtrl = TextEditingController();
  final TextEditingController expiryCtrl = TextEditingController();
  final TextEditingController cvcCtrl = TextEditingController();

  // Luhn Algorithm function
  bool validateCardNumber(String input) {
    String number = input.replaceAll(' ', ''); // remove spaces

    if (!RegExp(r'^\d+$').hasMatch(number)) return false;

    int sum = 0;
    bool alternate = false;

    for (int i = number.length - 1; i >= 0; i--) {
      int n = int.parse(number[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) n -= 9;
      }
      sum += n;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  bool isExpired(String input) {
    try {
      // Expecting format MM/YY
      final parts = input.split('/');
      if (parts.length != 2) return true;

      final month = int.tryParse(parts[0]) ?? 0;
      final year = int.tryParse(parts[1]) ?? 0;

      if (month < 1 || month > 12) return true;

      // Convert YY to 20YY
      final expiryYear = 2000 + year;

      // Compare with current date
      final now = DateTime.now();
      final expiryDate = DateTime(expiryYear, month + 1, 0);

      // ✅ expired if expiryDate < today
      return expiryDate.isBefore(now);
    } catch (_) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Card Details",
          style: GoogleFonts.inter(
            color: const Color(0XFF476C2F),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0XFF476C2F)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: "Card Holder Name",
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Name on Card is Required";
                  }
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(val)) {
                    return "Name can only contain letters";
                  }
                  if (val.length < 3 || val.length > 26) {
                    return "Name must be between 3 and 26 characters";
                  }
                  return null;
                },
              ),
              // TextFormField with Luhn validation
              TextFormField(
                controller: numberCtrl,
                decoration: const InputDecoration(labelText: "Card Number"),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Card Number is Required";
                  }
                  if (val.replaceAll(' ', '').length != 16) {
                    return "Card Number must be 16 digits";
                  }
                  if (val.contains(' ')) {
                    return "Card Number cannot contain spaces";
                  }
                  if (!validateCardNumber(val)) {
                    return "Invalid Card Number (Luhn Algorithm failed )";
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines: 1,

                      controller: expiryCtrl,
                      decoration: const InputDecoration(
                        labelText: "Expiry (MM/YY)",
                        errorMaxLines: 3,
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Expiry Date is required";
                        }

                        String input = val.trim();

                        // Check MM/YY format
                        if (!RegExp(
                          r'^(0[1-9]|1[0-2])\/\d{2}$',
                        ).hasMatch(input)) {
                          return "Enter expiry in MM/YY format";
                        }

                        // Past date check
                        if (isExpired(input)) {
                          return "Expiry Date is past date";
                        }

                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: cvcCtrl,
                      decoration: const InputDecoration(labelText: "CVC"),
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Card CVC is Required";
                        }
                        if (val.length != 3) {
                          return "Card CVC only 3 digits";
                        }
                        if (val.contains(' ')) {
                          return "Card CVC cannot contain spaces";
                        }
                        if (!RegExp(r'^\d+$').hasMatch(val)) {
                          return "Only numbers are allowed";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, {
                      "name": nameCtrl.text,
                      "number": numberCtrl.text,
                      "expiry": expiryCtrl.text,
                      "cvc": cvcCtrl.text,
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF456B2E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Center(
                  child: Text(
                    "Proceed",
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
