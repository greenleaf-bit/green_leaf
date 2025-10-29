import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllFeedbackScreen extends StatelessWidget {
  const AllFeedbackScreen({super.key});

  Future<List<Map<String, dynamic>>> fetchAllFeedbacks() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<Map<String, dynamic>> allFeedbacks = [];

    // 🔹 Get all feedback documents
    QuerySnapshot feedbackSnapshot = await firestore
        .collection('feedbacks')
        .get();

    for (var fbDoc in feedbackSnapshot.docs) {
      final feedbackData = fbDoc.data() as Map<String, dynamic>? ?? {};
      final String userId = feedbackData['userId'] ?? '';
      String customerName = 'Unknown';
      int customerId = 0;

      // 🔹 Get user details from 'users' collection
      if (userId.isNotEmpty) {
        final userSnapshot = await firestore
            .collection('users')
            .where('uid', isEqualTo: userId)
            .limit(1)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          final userData = userSnapshot.docs.first.data();
          customerName = userData['fullname'] ?? 'Unknown';
          customerId = userData['id'] ?? 0;
        }
      }

      // 🔹 Add feedback details to list
      allFeedbacks.add({
        'userId': userId,
        'id': customerId,
        'customerName': customerName,
        'productName': feedbackData['productName'] ?? 'Unknown Product',
        'description': feedbackData['comment'] ?? 'No description',
        'rating': feedbackData['rating'] ?? 0,
      });
    }

    return allFeedbacks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFC4D0C0),
      appBar: AppBar(
        backgroundColor: const Color(0XFFC4D0C0),
        centerTitle: true,
        title: Text(
          "All Feedbacks",
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchAllFeedbacks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final feedbacks = snapshot.data ?? [];

          if (feedbacks.isEmpty) {
            return const Center(child: Text("No feedbacks available."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final feedback = feedbacks[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(15.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0XFFE8F5EE),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0XFF3B6C1E).withOpacity(0.6),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Customer UID: ",
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0XFF454545),
                          ),
                        ),
                        Text(
                          feedback['id'].toString(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0XFF428DFF),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Customer Name: ",
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0XFF454545),
                          ),
                        ),
                        Text(
                          feedback['customerName'].toString(),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0XFF428DFF),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0XFF9D9D9D), thickness: 1),
                    Text(
                      "Product: ${feedback['productName']}",
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: const Color(0XFF454545),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      feedback['description'].toString(),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: const Color(0XFF456B2E).withOpacity(0.86),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rating",
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0XFF454545),
                          ),
                        ),
                        Row(
                          children: List.generate(
                            (feedback['rating'] ?? 0)
                                .toInt(), // 👈 convert to int
                            (i) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
