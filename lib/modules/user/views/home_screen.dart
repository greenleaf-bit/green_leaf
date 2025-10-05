import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/user/controllers/user_product_controller.dart';
import 'package:green_leaf/modules/user/views/product_detail.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final UserProductController _productController = UserProductController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFC4D0C0),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/name_icon.png",
                    width: 80,
                    height: 80,
                  ),
                  Text(
                    "Hey Mutasim",
                    style: GoogleFonts.lexend(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF336105),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Text(
                "Let’s find your plants!",
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF325A3E),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 7, right: 7),
                child: SearchBar(
                  leading: Icon(Icons.search),
                  hintText: "Search plants",
                  hintStyle: WidgetStateProperty.all(
                    GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF999898),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: _productController.getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No products found"));
                  }

                  final products = snapshot.data!.docs;

                  return GridView.builder(
                    itemCount: products.length,
                    shrinkWrap: true, // <-- ye add karo
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemBuilder: (context, index) {
                      final doc = products[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                productId: doc.id,
                                data: data,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(4),
                          width: 155,
                          height: 163,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            children: [
                              data['imageUrl'] != null
                                  ? Image.network(
                                      data["imageUrl"],
                                      width: 85,
                                      height: 110,
                                    )
                                  : Icon(
                                      Icons.image,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                              SizedBox(height: 5),
                              Text(
                                data["name"] ?? "No Name",
                                style: GoogleFonts.lexend(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0XFF325A3E),
                                ),
                              ),
                              Text(
                                "${data["price"] ?? 0} OMR",
                                style: GoogleFonts.lexend(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0XFF325A3E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
