import 'package:flutter_test/flutter_test.dart';
import 'package:green_leaf/core/utils/validators.dart';

void main() {
  group('LoginValidators Tests', () {
    test('Email empty', () {
      expect(
        LoginValidators.validateEmail(''),
        'Please enter your email address',
      );
    });

    test('Invalid email', () {
      expect(
        LoginValidators.validateEmail('wrong-email'),
        'Please enter a valid email address',
      );
    });

    test('Valid email', () {
      expect(LoginValidators.validateEmail('test@mail.com'), null);
    });

    test('Password empty', () {
      expect(
        LoginValidators.validatePassword(''),
        'Please enter your Password',
      );
    });

    test('Password valid', () {
      expect(LoginValidators.validatePassword('123456'), null);
    });
  });
}
