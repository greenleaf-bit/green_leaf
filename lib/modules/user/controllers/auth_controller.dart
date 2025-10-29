import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_leaf/main_screen.dart';
import 'package:green_leaf/modules/admin/views/admin_bottom_bar.dart';
import 'package:green_leaf/modules/admin/views/admin_home_screen.dart';
import 'package:green_leaf/modules/user/models/user_model.dart';
import 'package:green_leaf/modules/user/views/home_screen.dart';
import 'package:green_leaf/modules/user/views/login_screen.dart';
import 'package:green_leaf/core/utils/biometric_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register user
  Future<void> registerUser({
    required String fullname,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String role = "user";
      if (email == "project2greenleaf@gmail.com" && password == "admin123#") {
        role = "admin";
      }

      // 🔹 Get and increment user counter
      DocumentReference counterRef = _firestore
          .collection('metadata')
          .doc('user_counter');

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(counterRef);

        int newId = 1;
        if (snapshot.exists) {
          int currentId = snapshot.get('count');
          newId = currentId + 1;
          transaction.update(counterRef, {'count': newId});
        } else {
          // first user
          transaction.set(counterRef, {'count': 1});
          newId = 1;
        }

        // Create user model
        UserModel user = UserModel(
          uid: cred.user!.uid,
          fullname: fullname,
          email: email,
          role: role,
          address: null,
          id: newId, // ✅ Add this field in your model
        );

        // Save user
        transaction.set(
          _firestore.collection("users").doc(cred.user!.uid),
          user.toMap(),
        );
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registered Successfully")));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration Failed: ${e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // login users and admin
  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
    skipSnackBar = true,
  }) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore
          .collection("users")
          .doc(cred.user!.uid)
          .get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User not found")));
        return;
      }

      String role = userDoc["role"];
      if (skipSnackBar) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login Successful")));
      }
      //  Always save credentials
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_email', email);
      await prefs.setString('saved_password', password);
      await prefs.setBool('is_logged_in', true); //  session flag

      // 🔹 Only enable biometric if toggle is ON
      final bioHelper = BiometricHelper();
      final isEnabled = prefs.getBool('fingerprint_enabled') ?? false;
      if (isEnabled) {
        await bioHelper.saveCredentials(
          email,
          password,
        ); // optional helper logic
      }

      if (role == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminBottomBar()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => CustomBottomBar()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Failed: ${e.message}")));
    }
  }

  //update address
  Future<void> updateAddress(String newAddress) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection("users").doc(user.uid).update({
          "address": newAddress,
        });
      }
    } catch (e) {
      throw Exception("Failed to update address: $e");
    }
  }

  Future<String?> getUserAddress() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection("users").doc(user.uid).get();
      return doc.data()?["address"];
    }
    return null;
  }

  //Change Email
  Future<void> changeEmail({
    required String newEmail,
    required BuildContext context,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No user logged in")));
      return;
    }

    try {
      await user.verifyBeforeUpdateEmail(newEmail);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Verification email sent to $newEmail. Please check your inbox.",
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
    }
  }

  // Change Password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw "User not logged in";

      // Reauthenticate user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password updated successfully"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) {
            return CustomBottomBar();
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Error: ${e.message}";
      if (e.code == 'wrong-password') {
        message = "Current password is incorrect";
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // Delete user account
  Future<void> deleteAccount(BuildContext context) async {
    final user = _auth.currentUser;

    if (user == null) return;

    try {
      // Delete user document from Firestore
      await _firestore.collection("users").doc(user.uid).delete();

      // Delete user from Firebase Auth
      await user.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account deleted successfully")),
      );

      // Navigate to login screen after deletion
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      // Handle errors like recent login required
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete account: ${e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }
}
