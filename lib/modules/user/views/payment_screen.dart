import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/user/views/address_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, String> address;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;

  const PaymentScreen({
    super.key,
    required this.address,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String paymentMethod = "Cash on Delivery";

  @override
  Widget build(BuildContext context) {
    final totalAmount =
        widget.subtotal + widget.deliveryFee + widget.serviceFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,

        centerTitle: true,
        title: Text(
          "Payment Method",
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
        padding: const EdgeInsets.only(left: 30, right: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            // Address
            Text(
              "Delivery Address",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0XFF3F6B22),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFF456B2E).withOpacity(0.53)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${widget.address['house']}, ${widget.address['street']}, "
                "Way: ${widget.address['way']}, Area: ${widget.address['area']}, "
                "Phone: ${widget.address['phone']}",
                style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddressScreen(
                        subtotal: widget.subtotal,
                        deliveryFee: widget.deliveryFee,
                        serviceFee: widget.serviceFee,
                      ),
                    ),
                  );
                },
                child: Text(
                  "Change Address",
                  style: GoogleFonts.inter(
                    color: Color(0XFF456B2E),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Text(
              "Pay With",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0XFF3F6B22),
              ),
            ),
            RadioListTile(
              title: const Text("Cash on Delivery"),
              value: "Cash on Delivery",
              groupValue: paymentMethod,
              onChanged: (val) {
                setState(() => paymentMethod = val!);
              },
            ),
            RadioListTile(
              title: const Text("Card Payment"),
              value: "Card Payment",
              groupValue: paymentMethod,
              onChanged: (val) {
                setState(() => paymentMethod = val!);
              },
            ),

            const Spacer(),

            // Payment Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  summaryRow("Subtotal", widget.subtotal),
                  summaryRow("Delivery Fee", widget.deliveryFee),
                  summaryRow("Service Fee", widget.serviceFee),
                  const Divider(),
                  summaryRow("Total Amount", totalAmount, bold: true),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // Proceed Order Logic Here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Order placed with $paymentMethod"),
                        ),
                      );
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
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget summaryRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "${value.toStringAsFixed(3)} OMR",
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
