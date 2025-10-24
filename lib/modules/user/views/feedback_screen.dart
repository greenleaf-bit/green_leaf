import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/main_screen.dart';
import '../controllers/order_controller.dart'; // 👈 apna order controller import karo

class FeedBackScreen extends StatefulWidget {
  final String orderId;
  final List<Map<String, dynamic>> cartItems; // cart items le aao

  const FeedBackScreen({
    super.key,
    required this.orderId,
    required this.cartItems,
  });

  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, double> _ratings = {};
  final OrderController _orderController = OrderController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    for (var item in widget.cartItems) {
      final id = item["productId"].toString();
      _controllers[id] = TextEditingController();
      _ratings[id] = 0;
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget buildStarRow(String productId) {
    return Row(
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          onPressed: () {
            setState(() {
              _ratings[productId] = starIndex.toDouble();
            });
          },
          icon: Icon(
            Icons.star,
            size: 46,
            color: starIndex <= (_ratings[productId] ?? 0)
                ? Colors.yellow[700]
                : Colors.grey[400],
          ),
        );
      }),
    );
  }
  Future<void> _submitFeedback() async {
    List<Map<String, dynamic>> feedbackList = [];

    // ✅ Validation check
    for (var item in widget.cartItems) {
      final id = item["productId"].toString();
      final rating = _ratings[id] ?? 0;
      final description = _controllers[id]?.text.trim() ?? "";

      if (rating < 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please give at least 1 star for ${item["name"]}.")),
        );
        return;
      }

      if (description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please write feedback for ${item["name"]}.")),
        );
        return;
      }

      feedbackList.add({
        "productId": id,
        "productName": item["name"],
        "rating": rating,
        "description": description,
      });
    }

    // ✅ Submit if validation passed
    setState(() {
      isLoading = true;
    });

    try {
      await _orderController.saveFeedback(
        orderId: widget.orderId,
        feedbacks: feedbackList,
      );
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback submitted successfully!")),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (ctx) => CustomBottomBar()),
            (route) => false,
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Give Feedback",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0XFF476C2F),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.cartItems.length,
        itemBuilder: (context, index) {
          final product = widget.cartItems[index];
          final id = product["productId"].toString();

          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    " Write Feedback for ${product["name"] ?? ""} ",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Color(0XFF476C2F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _controllers[id],
                    decoration: const InputDecoration(
                      hintText: "Write your feedback...",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Rate Experience",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Color(0XFF476C2F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  buildStarRow(id),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0XFF476C2F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: _submitFeedback,
          child: Text(
            "Submit Feedback",
            style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
