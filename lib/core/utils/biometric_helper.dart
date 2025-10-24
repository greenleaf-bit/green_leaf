import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricHelper {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> canAuthenticate() async {
    return await _localAuth.canCheckBiometrics &&
        await _localAuth.isDeviceSupported();
  }

  Future<bool> authenticateUser() async {
    try {
      print("🔹 Fingerprint auth called");

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Use fingerprint to login',
        biometricOnly: true,                // require biometrics only
        persistAcrossBackgrounding: true,   // resume if app backgrounds
        // optionally: authMessages: <AuthMessages>[ ... ] // for custom text
      );
      print("✅ Fingerprint result: $didAuthenticate");

      return didAuthenticate;
    } on Exception catch (e) {
      // handle LocalAuthException or other errors
      debugPrint('Biometric auth failed: $e');
      return false;
    }
  }

  Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bio_email', email);
    await prefs.setString('bio_password', password);
    await prefs.setBool('bio_enabled', true);
  }

  Future<Map<String, String>?> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('bio_email');
    final pass = prefs.getString('bio_password');
    if (email != null && pass != null) {
      return {'email': email, 'password': pass};
    }
    return null;
  }

  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('bio_enabled') ?? false;
  }

  Future<void> disableBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bio_email');
    await prefs.remove('bio_password');
    await prefs.setBool('bio_enabled', false);
  }
}
