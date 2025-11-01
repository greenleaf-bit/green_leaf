import 'package:flutter_test/flutter_test.dart';
import 'package:green_leaf/core/utils/validators.dart';

void main() {
  group("AddressValidators Tests", () {
    // -------------------------------------------------------
    //  Phone Number Tests
    // -------------------------------------------------------
    test("Phone Number - empty", () {
      expect(
        AddressScreenValidators.validate("Phone Number", ""),
        "Enter Phone Number",
      );
    });

    test("Phone Number - length not 8", () {
      expect(
        AddressScreenValidators.validate("Phone Number", "1234567"),
        "Phone number must be 8 digits",
      );
    });

    test("Phone Number - does not start with 9 or 7", () {
      expect(
        AddressScreenValidators.validate("Phone Number", "12345678"),
        "Phone number must start with 9 or 7 and contain only digits",
      );
    });

    test("Phone Number - valid (starts with 9)", () {
      expect(
        AddressScreenValidators.validate("Phone Number", "91234567"),
        null,
      );
    });

    test("Phone Number - valid (starts with 7)", () {
      expect(
        AddressScreenValidators.validate("Phone Number", "71234567"),
        null,
      );
    });

    // -------------------------------------------------------
    //  Way Number Tests
    // -------------------------------------------------------
    test("Way Number - empty", () {
      expect(
        AddressScreenValidators.validate("Way Number", ""),
        "Enter Way Number",
      );
    });

    test("Way Number - zero not allowed", () {
      expect(
        AddressScreenValidators.validate("Way Number", "0"),
        "Way Number can't be Zero",
      );
    });

    test("Way Number - non-numeric", () {
      expect(
        AddressScreenValidators.validate("Way Number", "12A"),
        "Way Number must be numeric",
      );
    });

    test("Way Number - invalid length", () {
      expect(
        AddressScreenValidators.validate("Way Number", "1234567"),
        "Way Number Accepts Only Numbers Length 1-6",
      );
    });

    test("Way Number - valid", () {
      expect(AddressScreenValidators.validate("Way Number", "1234"), null);
    });

    // -------------------------------------------------------
    //  Street Number Tests (same rules as Way Number)
    // -------------------------------------------------------
    test("Street Number - zero not allowed", () {
      expect(
        AddressScreenValidators.validate("Street Number", "0"),
        "Street Number can't be Zero",
      );
    });

    test("Street Number - non-numeric", () {
      expect(
        AddressScreenValidators.validate("Street Number", "1A3"),
        "Street Number must be numeric",
      );
    });

    test("Street Number - valid", () {
      expect(AddressScreenValidators.validate("Street Number", "123456"), null);
    });

    // -------------------------------------------------------
    //  House Number Tests
    // -------------------------------------------------------
    test("House Number - zero not allowed", () {
      expect(
        AddressScreenValidators.validate("House Number", "0"),
        "House Number can't be Zero",
      );
    });

    test("House Number - length out of range", () {
      expect(
        AddressScreenValidators.validate("House Number", "1234567"),
        "House Number must be 1-6 characters long",
      );
    });

    test("House Number - invalid format", () {
      expect(
        AddressScreenValidators.validate("House Number", "12ABC"),
        "House Number must be 2-6 digits or a number with 1 letters (A-Z)",
      );
    });

    test("House Number - valid digits only", () {
      expect(AddressScreenValidators.validate("House Number", "1234"), null);
    });

    test("House Number - valid number + 1 letter", () {
      expect(AddressScreenValidators.validate("House Number", "12A"), null);
    });

    // -------------------------------------------------------
    //  Area Tests (letters only, 3–30)
    // -------------------------------------------------------
    test("Area - empty", () {
      expect(AddressScreenValidators.validate("Area", ""), "Enter Area");
    });

    test("Area - too short", () {
      expect(
        AddressScreenValidators.validate("Area", "Ab"),
        "Area must be 3-30 characters",
      );
    });

    test("Area - contains numbers", () {
      expect(
        AddressScreenValidators.validate("Area", "Muscat123"),
        "Area cannot contain numbers or special characters",
      );
    });

    test("Area - valid", () {
      expect(AddressScreenValidators.validate("Area", "Al Khuwair"), null);
    });
  });
}
