import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProductController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //select image from gallery
  Future<File?> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  //upload image to cloudinary
  Future<String?> uploadImageToCloudinary(File imageFile) async {
    const cloudName = "dhir0vyfa";
    const uploadPreset = "green_leaf_upload";

    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    var request = http.MultipartRequest("POST", url);
    request.fields["upload_preset"] = uploadPreset;
    request.files.add(
      await http.MultipartFile.fromPath("file", imageFile.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final res = await http.Response.fromStream(response);
      final data = res.body;
      final imageUrl = RegExp(r'"url":"([^"]+)"').firstMatch(data)?.group(1);
      return imageUrl?.replaceAll(r'\"', '');
    } else {
      return null;
    }
  }

  // Save product in Firestore
  Future<void> addProduct({
    required String name,
    required String price,
    required String type,
    required String description,
    required String imageUrl,
  }) async {
    await _firestore.collection("products").add({
      "name": name,
      "price": price,
      "type": type,
      "description": description,
      "imageUrl": imageUrl,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// Update Product
  Future<void> updateProduct(
    String productId,
    Map<String, dynamic> productData,
    BuildContext context,
  ) async {
    try {
      await _firestore
          .collection("products")
          .doc(productId)
          .update(productData);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Product Updated Successfully")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  /// Delete Product with Confirmation
  Future<void> deleteProductWithConfirmation(
    String productId,
    BuildContext context,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this product?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel", style: TextStyle(color: Color(0xFF3B6C1E))),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: Text("Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await _firestore.collection("products").doc(productId).delete();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Product Deleted")));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  /// Get Products Stream (for listing)
  Stream<QuerySnapshot> getProducts() {
    return _firestore.collection("products").snapshots();
  }
}
