import 'package:filmpal/utilities/password_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthenticationUtils', () {
    test('doPasswordsMatch returns true when passwords match', () {
      // Arrange
      final password = 'password';
      final password2 = 'password';

      // Act
      final result = doPasswordsMatch(password, password2);

      // Assert
      expect(result, true, reason: 'Passwords should match');
      if (result) {
        print('Test passed: Passwords match');
      }
    });

    test('doPasswordsMatch returns false when passwords do not match', () {
      // Arrange
      final password = 'password';
      final password2 = 'differentpassword';

      // Act
      final result = doPasswordsMatch(password, password2);

      // Assert
      expect(result, false, reason: 'Passwords should not match');
      if (!result) {
        print('Test passed: Passwords do not match');
      }
    });
  });
}
