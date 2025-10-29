import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_leaf/main_screen.dart';

class CartController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Add to Cart
  Future<void> addToCart({
    required String productId,
    required Map<String, dynamic> productData,
    required int quantity,
    required BuildContext context,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Please login first")));
        return;
      }

      final cartRef = _firestore
          .collection("carts")
          .doc(user.uid)
          .collection("items")
          .doc(productId);

      final doc = await cartRef.get();

      if (doc.exists) {
        // already in cart -> update quantity
        int oldQty = doc["quantity"];
        int newQty = oldQty + quantity;

        await cartRef.update({
          "quantity": newQty,
          "totalPrice": (doc["price"] * newQty),
        });
      } else {
        // new cart item
        await cartRef.set({
          "productId": productId,
          "name": productData["name"],
          "price": double.parse(productData["price"].toString()),
          "imageUrl": productData["imageUrl"],
          "type": productData["type"],
          "description": productData["description"],
          "quantity": quantity,
          "totalPrice":
              double.parse(productData["price"].toString()) * quantity,
          "createdAt": FieldValue.serverTimestamp(),
        });
        //For Automated Testing
        print(
          "✅ Added new item to cart: ${productData["name"]} | Quantity: $quantity | Price: ${productData["price"]}",
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Added to cart successfully"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => CustomBottomBar()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  /// Get User Cart
  Stream<QuerySnapshot> getCartItems() {
    final user = _auth.currentUser;
    return _firestore
        .collection("carts")
        .doc(user!.uid)
        .collection("items")
        .snapshots();
  }

  /// Update Quantity
  Future<void> updateQuantity(
    String productId,
    int newQty,
    double price,
  ) async {
    final user = _auth.currentUser;
    final totalPrice = price * newQty;

    await _firestore
        .collection("carts")
        .doc(user!.uid)
        .collection("items")
        .doc(productId)
        .update({"quantity": newQty, "totalPrice": totalPrice});
  }

  /// Delete from cart
  Future<void> deleteFromCart(String productId, BuildContext context) async {
    try {
      final user = _auth.currentUser;
      await _firestore
          .collection("carts")
          .doc(user!.uid)
          .collection("items")
          .doc(productId)
          .delete();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Item removed from cart")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}
