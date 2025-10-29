import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/admin/controllers/product_controller.dart';
import 'package:green_leaf/modules/admin/views/admin_bottom_bar.dart';
import 'package:green_leaf/modules/admin/views/manage_products.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ProductController _productController = ProductController();
  bool isLoading = false;

  File? _selectedImage;

  void _pickImage() async {
    final image = await _productController.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _addProduct() async {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      setState(() => isLoading = true);

      // Upload image to Cloudinary
      final imageUrl = await _productController.uploadImageToCloudinary(
        _selectedImage!,
      );

      if (imageUrl != null) {
        await _productController.addProduct(
          name: _nameController.text.trim(),
          price: _priceController.text.trim(),
          type: _typeController.text.trim(),
          description: _descriptionController.text.trim(),
          imageUrl: imageUrl,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product Added Successfully")),
        );
        _formKey.currentState!.reset();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminBottomBar()),
        );

        setState(() {
          _selectedImage = null;
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Image upload failed")));
      }

      setState(() => isLoading = false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select image & fill all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFC4D0C0),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.42,

                  child: _selectedImage == null
                      ? Center(
                          child: Text(
                            "Insert Product Image",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0XFF39571E).withOpacity(0.8),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                            left: 50,
                            right: 50,
                            top: 80,
                            bottom: 50,
                          ),
                          child: Image.file(_selectedImage!),
                        ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Product Name",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0XFF39571E).withOpacity(0.8),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            height: 30,
                            child: TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter product name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 0,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Enter Name',

                                hintStyle: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0XFF39571E),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: Color(0XFF3B6C1E).withOpacity(0.6),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Product Price",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0XFF39571E).withOpacity(0.8),
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 150,
                            height: 30,
                            child: TextFormField(
                              controller: _priceController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter product price';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                suffixText: "OMR",
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0,

                                  horizontal: 0,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Enter Price',

                                hintStyle: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0XFF39571E),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: Color(0XFF3B6C1E).withOpacity(0.6),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Product Type",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0XFF39571E).withOpacity(0.8),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            height: 30,

                            child: TextFormField(
                              controller: _typeController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter product type';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 0,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Enter Type',

                                hintStyle: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0XFF39571E),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: Color(0XFF3B6C1E).withOpacity(0.6),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        child: TextFormField(
                          controller: _descriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter product description';
                            }
                            return null;
                          },
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0XFF3B6C1E).withOpacity(0.6),
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0XFF3B6C1E).withOpacity(0.6),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0XFF3B6C1E).withOpacity(0.6),
                              ),
                            ),
                            labelText: 'Product Description',

                            labelStyle: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0XFF39571E).withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 60),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                              left: 15,
                              right: 15,
                            ),
                            backgroundColor: Color(0XFF659746),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _addProduct();
                            }
                          },
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Add Product',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
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
        ),
      ),
    );
  }
}
