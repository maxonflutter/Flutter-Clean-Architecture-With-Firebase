import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/value_objects/password.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Password', () {
    test('valid password does not throw exception', () {
      expect(() => Password((b) => b.value = 'password123'), returnsNormally);
    });

    test('invalid password throws ArgumentError', () {
      expect(() => Password((b) => b.value = 'pass'), throwsArgumentError);
      expect(() => Password((b) => b.value = 'password!'), throwsArgumentError);
    });

    test('value property is correctly set', () {
      final password = Password((b) => b.value = 'password123');
      expect(password.value, equals('password123'));
    });

    test('two Password instances with same values are equal', () {
      final password1 = Password((b) => b.value = 'password123');
      final password2 = Password((b) => b.value = 'password123');
      expect(password1, equals(password2));
    });

    test('two Password instances with different values are not equal', () {
      final password1 = Password((b) => b.value = 'password123');
      final password2 = Password((b) => b.value = 'password456');
      expect(password1, isNot(equals(password2)));
    });
  });
}
