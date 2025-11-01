import 'package:flutter_test/flutter_test.dart';
import 'package:green_leaf/core/utils/validators.dart';

void main() {
  group('RegisterValidators Tests', () {
    // Full Name
    test('Full name empty', () {
      expect(
        RegisterValidators.validateFullName(''),
        'Please enter your Full Name',
      );
    });

    test('Full name too short', () {
      expect(
        RegisterValidators.validateFullName('ab'),
        'Name Should Be at Least 3 Characters ',
      );
    });

    test('Full name too long', () {
      expect(
        RegisterValidators.validateFullName('a' * 31),
        'Name should not exceed 30 characters ',
      );
    });

    test('Full name invalid characters', () {
      expect(
        RegisterValidators.validateFullName('John123'),
        'Name should contain only alphabet characters ',
      );
    });

    test('Full name valid', () {
      expect(RegisterValidators.validateFullName('John Doe'), null);
    });

    // Email
    test('Email empty', () {
      expect(
        RegisterValidators.validateEmail(''),
        'Please enter your email address',
      );
    });

    test('Invalid email', () {
      expect(
        RegisterValidators.validateEmail('wrong-email'),
        'Please enter a valid email address',
      );
    });

    test('Email too long', () {
      expect(
        RegisterValidators.validateEmail('a' * 41 + '@mail.com'),
        'Email address is too long (max 40 characters)',
      );
    });

    test('Valid email', () {
      expect(RegisterValidators.validateEmail('test@mail.com'), null);
    });

    // Password
    test('Password empty', () {
      expect(
        RegisterValidators.validatePassword(''),
        'Please enter your password',
      );
    });

    test('Password too short', () {
      expect(
        RegisterValidators.validatePassword('12345'),
        'Password must be more than 8 characters long',
      );
    });

    test('Password missing requirements', () {
      expect(
        RegisterValidators.validatePassword('abcdefgh'),
        'Password must include letters, numbers, and special characters',
      );
    });

    test('Password valid', () {
      expect(RegisterValidators.validatePassword('Test@123'), null);
    });

    // Confirm Password
    test('Confirm password empty', () {
      expect(
        RegisterValidators.validateConfirmPassword('', '123'),
        'Please enter your confirm password',
      );
    });

    test('Confirm password mismatch', () {
      expect(
        RegisterValidators.validateConfirmPassword('123', '456'),
        'Passwords do not match',
      );
    });

    test('Confirm password matches', () {
      expect(RegisterValidators.validateConfirmPassword('123', '123'), null);
    });
  });
}
