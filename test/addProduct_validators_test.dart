import 'package:flutter_test/flutter_test.dart';
import 'package:green_leaf/core/utils/validators.dart';

void main() {
  group("AddProductValidators Tests", () {
    // -------------------------------------------------------
    //  Product Name Tests
    // -------------------------------------------------------
    test("Product Name - empty", () {
      expect(
        AddProductValidators.validateProductName(""),
        "Please Enter Product Name",
      );
    });

    test("Product Name - too short", () {
      expect(
        AddProductValidators.validateProductName("ab"),
        "Product Name must be More than 3 & less than 14 characters",
      );
    });

    test("Product Name - too long", () {
      expect(
        AddProductValidators.validateProductName("abcdefghijklmnop"),
        "Product Name must be More than 3 & less than 14 characters",
      );
    });

    test("Product Name - numeric / symbol not allowed", () {
      expect(
        AddProductValidators.validateProductName("Tea123"),
        "Product Name Should not Contain Numbers, Symbols",
      );
    });

    test("Product Name - valid", () {
      expect(AddProductValidators.validateProductName("Green Tea"), null);
    });

    // -------------------------------------------------------
    //  Product Price Tests
    // -------------------------------------------------------
    test("Product Price - empty", () {
      expect(
        AddProductValidators.validateProductPrice(""),
        "Please enter product price",
      );
    });

    test("Product Price - zero", () {
      expect(
        AddProductValidators.validateProductPrice("0"),
        "Price can't be zero or More than 6 digits Format:[3000.000]",
      );
    });

    test("Product Price - too long (>7)", () {
      expect(
        AddProductValidators.validateProductPrice("12345678"),
        "Price can't be zero or More than 6 digits Format:[3000.000]",
      );
    });

    test("Product Price - invalid number", () {
      expect(
        AddProductValidators.validateProductPrice("abc"),
        "Please enter a valid number",
      );
    });

    test("Product Price - valid", () {
      expect(AddProductValidators.validateProductPrice("199.500"), null);
    });

    // -------------------------------------------------------
    //  Product Type Tests
    // -------------------------------------------------------
    test("Product Type - empty", () {
      expect(
        AddProductValidators.validateProductType(""),
        "Please enter product type",
      );
    });

    test("Product Type - too short", () {
      expect(
        AddProductValidators.validateProductType("ab"),
        "Type can't be Less than 3 & more than14 characters",
      );
    });

    test("Product Type - too long", () {
      expect(
        AddProductValidators.validateProductType("abcdefghijklmnop"),
        "Type can't be Less than 3 & more than14 characters",
      );
    });

    test("Product Type - valid", () {
      expect(AddProductValidators.validateProductType("Organic"), null);
    });

    // -------------------------------------------------------
    //  Product Description Tests
    // -------------------------------------------------------
    test("Product Description - empty", () {
      expect(
        AddProductValidators.validateProductDescription(""),
        "Please enter product description",
      );
    });

    test("Product Description - too short", () {
      expect(
        AddProductValidators.validateProductDescription("ab"),
        "Description can't be Less than 3 & more than14 characters",
      );
    });

    test("Product Description - too long", () {
      expect(
        AddProductValidators.validateProductDescription("abcdefghijklmnop"),
        "Description can't be Less than 3 & more than14 characters",
      );
    });

    test("Product Description - valid", () {
      expect(
        AddProductValidators.validateProductDescription("Fresh Tea"),
        null,
      );
    });
  });
}
