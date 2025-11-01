//Register Screen Validators
class RegisterValidators {
  // Full Name
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Full Name';
    }
    if (value.length < 3) {
      return 'Name Should Be at Least 3 Characters ';
    }
    if (value.length > 30) {
      return 'Name should not exceed 30 characters ';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name should contain only alphabet characters ';
    }
    return null;
  }

  // Email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    if (value.length > 40) {
      return 'Email address is too long (max 40 characters)';
    }
    return null;
  }

  // Password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be more than 8 characters long';
    }

    bool hasLetter = value.contains(RegExp(r'[A-Za-z]'));
    bool hasNumber = value.contains(RegExp(r'[0-9]'));
    bool hasSpecial = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasLetter || !hasNumber || !hasSpecial) {
      return 'Password must include letters, numbers, and special characters';
    }

    return null;
  }

  // Confirm Password
  static String? validateConfirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please enter your confirm password';
    }
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}

//login screen validators
class LoginValidators {
  // Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Password';
    }

    return null; // Valid
  }
}

//Address Screen Validators + Change Address Screen Validators
class AddressScreenValidators {
  static String? validate(String label, String? value) {
    if (value == null || value.isEmpty) return "Enter $label";

    // ✅ Phone Number
    if (label == "Phone Number") {
      String val = value.replaceAll(' ', '');

      if (val.length != 8) return "Phone number must be 8 digits";

      if (!RegExp(r'^[79][0-9]{7}$').hasMatch(val)) {
        return "Phone number must start with 9 or 7 and contain only digits";
      }
    }

    // ✅ Way Number
    if (label == "Way Number") {
      if (value == "0") return "Way Number can't be Zero";

      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return "$label must be numeric";
      }

      if (value.length < 1 || value.length > 6) {
        return "Way Number Accepts Only Numbers Length 1-6";
      }
    }

    // ✅ Street Number
    if (label == "Street Number") {
      if (value == "0") return "Street Number can't be Zero";

      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return "$label must be numeric";
      }

      if (value.length < 1 || value.length > 6) {
        return "Street Number Accepts Only Numbers Length 1-6";
      }
    }

    // ✅ House Number
    if (label == "House Number") {
      if (value == "0") return "House Number can't be Zero";

      String val = value.replaceAll(' ', '');

      if (val.length < 1 || val.length > 6) {
        return "House Number must be 1-6 characters long";
      }

      bool digitsOnly = RegExp(r'^\d{2,6}$').hasMatch(val);

      bool numberWith1Letter = RegExp(r'^\d+[A-Z]{1}$').hasMatch(val);

      if (!digitsOnly && !numberWith1Letter) {
        return "House Number must be 2-6 digits or a number with 1 letters (A-Z)";
      }
    }

    // ✅ Area
    if (label == "Area") {
      if (value.length < 3 || value.length > 30) {
        return "Area must be 3-30 characters";
      }

      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
        return "Area cannot contain numbers or special characters";
      }
    }

    return null;
  }
}

//Manage Products from admin validators
class AddProductValidators {
  //  Product Name
  static String? validateProductName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Product Name';
    }

    if (value.length < 3 || value.length > 14) {
      return "Product Name must be More than 3 & less than 14 characters";
    }

    if (!RegExp(r'^[A-Za-z\s]+$').hasMatch(value.trim())) {
      return 'Product Name Should not Contain Numbers, Symbols';
    }

    return null;
  }

  //  Product Price
  static String? validateProductPrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter product price';
    }

    if (value == '0' || value.length > 7) {
      return "Price can't be zero or More than 6 digits Format:[3000.000]";
    }

    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }

    return null;
  }

  //  Product Type
  static String? validateProductType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter product type';
    }

    if (value.length < 3 || value.length > 14) {
      return "Type can't be Less than 3 & more than14 characters";
    }

    return null;
  }

  //  Product Description
  static String? validateProductDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter product description';
    }

    if (value.length < 3 || value.length > 14) {
      return "Description can't be Less than 3 & more than14 characters";
    }

    return null;
  }
}
