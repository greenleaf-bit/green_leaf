import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/admin/controllers/product_controller.dart';
import 'package:green_leaf/modules/admin/views/manage_products.dart';

class UpdateProductScreen extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> existingData;

  const UpdateProductScreen({
    super.key,
    required this.productId,
    required this.existingData,
  });

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProductController _productController = ProductController();
  bool isLoading = false;

  File? _selectedImage;
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _typeController;
  late TextEditingController _descriptionController;

  String? existingImageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingData['name']);
    _priceController = TextEditingController(
      text: widget.existingData['price'],
    );
    _typeController = TextEditingController(text: widget.existingData['type']);
    _descriptionController = TextEditingController(
      text: widget.existingData['description'],
    );
    existingImageUrl = widget.existingData['imageUrl'];
  }

  void _pickImage() async {
    final image = await _productController.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
        existingImageUrl =
            null; // nayi image choose ki to purani hide kar denge
      });
    }
  }

  void _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      String? imageUrl = existingImageUrl;

      // agar nayi image li hai to upload karo
      if (_selectedImage != null) {
        imageUrl = await _productController.uploadImageToCloudinary(
          _selectedImage!,
        );
      }

      if (imageUrl != null) {
        _productController.updateProduct(widget.productId, {
          "name": _nameController.text.trim(),
          "price": _priceController.text.trim(),
          "type": _typeController.text.trim(),
          "description": _descriptionController.text.trim(),
          "imageUrl": imageUrl,
        }, context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product Updated Successfully")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ManageProducts()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Image update failed")));
      }

      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFC4D0C0),
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
                  child: _selectedImage != null
                      ? Padding(
                          padding: const EdgeInsets.all(60),
                          child: Image.file(_selectedImage!),
                        )
                      : existingImageUrl != null
                      ? Image.network(existingImageUrl!)
                      : Center(
                          child: Text(
                            "Tap to select new Product Image",
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0XFF39571E).withOpacity(0.8),
                            ),
                          ),
                        ),
                ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.58,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      _buildRowField(
                        "Product Name",
                        _nameController,
                        'Enter Name',
                      ),
                      const Divider(thickness: 1),
                      const SizedBox(height: 20),

                      _buildRowField(
                        "Product Price",
                        _priceController,
                        'Enter Price',
                        keyboardType: TextInputType.number,
                        suffix: "OMR",
                      ),
                      const Divider(thickness: 1),
                      const SizedBox(height: 20),

                      _buildRowField(
                        "Product Type",
                        _typeController,
                        'Enter Type',
                      ),
                      const Divider(thickness: 1),
                      const SizedBox(height: 10),

                      TextFormField(
                        controller: _descriptionController,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter product description'
                            : null,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'Product Description',
                          labelStyle: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0XFF39571E).withOpacity(0.8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),

                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 15,
                            ),
                            backgroundColor: const Color(0XFF428DFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: _updateProduct,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  'Update Product',
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

  Widget _buildRowField(
    String label,
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    String? suffix,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0XFF39571E).withOpacity(0.8),
          ),
        ),
        SizedBox(
          width: 150,
          height: 30,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
            decoration: InputDecoration(
              suffixText: suffix,
              border: InputBorder.none,
              hintText: hint,
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0XFF39571E),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
