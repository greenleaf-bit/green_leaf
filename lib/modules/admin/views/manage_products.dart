import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_leaf/modules/admin/controllers/product_controller.dart';
import 'package:green_leaf/modules/admin/views/add_product.dart';
import 'package:green_leaf/modules/admin/views/update_product_screen.dart';
import 'package:green_leaf/modules/user/views/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageProducts extends StatefulWidget {
  const ManageProducts({super.key});

  @override
  State<ManageProducts> createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  final ProductController _productController = ProductController();

  void _editProduct(DocumentSnapshot doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProductScreen(
          productId: doc.id,
          existingData: doc.data() as Map<String, dynamic>,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFC4D0C0),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/adminleaf.png",
                  height: 110,
                  width: 110,
                ),
                const SizedBox(width: 5),
                Text(
                  "Hey Admin",
                  style: GoogleFonts.lexend(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: Color(0XFF336105),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool(
                      'is_logged_in',
                      false,
                    ); // 🔹 session off
                    await prefs.setBool('fingerprint_enabled', false);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) {
                          return LoginScreen();
                        },
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(
                    "Logout",
                    style: GoogleFonts.lexend(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF336105),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manage Products',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0XFF456B2E),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFFFCFF7B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddProduct()),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        'Add New Product',
                        style: GoogleFonts.inter(
                          color: Color(0XFF456B2E),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.add_a_photo_outlined,
                        size: 15,
                        color: Color(0XFF456B2E),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Products Grid using Controller
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _productController.getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No products found"));
                  }

                  final products = snapshot.data!.docs;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: GridView.builder(
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final doc = products[index];
                        final data = doc.data() as Map<String, dynamic>;

                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: data["imageUrl"] != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                          top: 10.0,
                                        ),
                                        child: Image.network(
                                          data["imageUrl"],
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Icon(
                                        Icons.image,
                                        size: 80,
                                        color: Colors.grey,
                                      ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: SizedBox(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data["name"] ?? "No Name",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Color(0xFF325A3E),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _editProduct(doc);
                                        },
                                        child: Container(
                                          width: 60,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0XFF428DFF),
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: Text(
                                            "Update",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: SizedBox(
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${data["price"] ?? 0} OMR",
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF325A3E),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _productController
                                              .deleteProductWithConfirmation(
                                                doc.id,
                                                context,
                                              );
                                        },
                                        child: Container(
                                          width: 60,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0XFFC40000),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 4,
                                                offset: Offset(2, 2),
                                              ),
                                            ],
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: Text(
                                            "Delete",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
