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
                validator: (val) => val!.isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                controller: numberCtrl,
                decoration: const InputDecoration(labelText: "Card Number"),
                keyboardType: TextInputType.number,
                validator: (val) =>
                val!.length < 16 ? "Enter valid number" : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: expiryCtrl,
                      decoration: const InputDecoration(
                        labelText: "Expiry (MM/YY)",
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Enter expiry";
                        } else if (isExpired(val.trim())) {
                          return "Card expired";
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
                      validator: (val) =>
                      val!.length < 3 ? "Enter valid CVC" : null,
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
