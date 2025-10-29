import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool isLoadingProducts = true;

  List<Map<String, dynamic>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _loadUnreviewedProducts();
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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User not logged in.")));
      return;
    }

    List<Map<String, dynamic>> feedbackList = [];

    for (var item in widget.cartItems) {
      final id = item["productId"].toString();
      final rating = _ratings[id] ?? 0;
      final description = _controllers[id]?.text.trim() ?? "";

      if (rating < 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please give at least 1 star for ${item["name"]}."),
          ),
        );
        return;
      }

      if (description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please write feedback for ${item["name"]}.")),
        );
        return;
      }

      // ✅ Step 1: Check if feedback already exists for this user & product
      final existingFeedback = await FirebaseFirestore.instance
          .collection('feedbacks')
          .where('userId', isEqualTo: user.uid)
          .where('productId', isEqualTo: id)
          .get();

      if (existingFeedback.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You already gave feedback for ${item["name"]}."),
          ),
        );
        continue; // skip this product
      }

      feedbackList.add({
        "productId": id,
        "productName": item["name"],
        "rating": rating,
        "comment": description,
        "userId": user.uid,
        "orderId": widget.orderId,
        "createdAt": FieldValue.serverTimestamp(),
      });
    }

    if (feedbackList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No new feedback to submit.")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final feedbackRef = FirebaseFirestore.instance.collection('feedbacks');
      for (var feedback in feedbackList) {
        await feedbackRef.add(feedback);
      }

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback submitted successfully!")),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (ctx) => CustomBottomBar()),
        (route) => false,
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _loadUnreviewedProducts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    print("🕒 Loading unreviewed products...");

    final feedbackDocs = await FirebaseFirestore.instance
        .collection('feedbacks')
        .where('userId', isEqualTo: user.uid)
        .get();

    final reviewedIds = feedbackDocs.docs
        .map((doc) => doc['productId'].toString())
        .toList();

    print("🎯 Reviewed product IDs: $reviewedIds");

    final unreviewedItems = widget.cartItems
        .where((item) => !reviewedIds.contains(item["productId"].toString()))
        .toList();

    print("🛍️ Unreviewed products count: ${unreviewedItems.length}");

    if (unreviewedItems.isEmpty) {
      // ✅ If all feedbacks already given → navigate back automatically
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,

            content: Text("You’ve already given feedback for all products."),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (ctx) => CustomBottomBar()),
        );
      });
      return;
    }

    for (var item in unreviewedItems) {
      final id = item["productId"].toString();
      _controllers[id] = TextEditingController();
      _ratings[id] = 0;
    }

    setState(() {
      _filteredItems = unreviewedItems;
      isLoadingProducts = false;
    });
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
      body: isLoadingProducts
          ? Center(child: CircularProgressIndicator(color: Color(0XFF476C2F)))
          : _filteredItems.isEmpty
          ? Center(
              child: Text(
                "You’ve already given feedback for all products!",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Color(0XFF476C2F),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final product = _filteredItems[index];
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
