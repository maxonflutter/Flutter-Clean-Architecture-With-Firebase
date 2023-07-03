import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/value_objects/email.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Email', () {
    test('valid email does not throw exception', () {
      expect(() => Email((b) => b.value = 'test@test.com'), returnsNormally);
    });

    test('invalid email throws ArgumentError', () {
      expect(() => Email((b) => b.value = 'invalidEmail'), throwsArgumentError);
    });

    test('value property is correctly set', () {
      final email = Email((b) => b.value = 'test@test.com');
      expect(email.value, equals('test@test.com'));
    });

    test('two Email instances with same values are equal', () {
      final email1 = Email((b) => b.value = 'test@test.com');
      final email2 = Email((b) => b.value = 'test@test.com');
      expect(email1, equals(email2));
    });

    test('two Email instances with different values are not equal', () {
      final email1 = Email((b) => b.value = 'test1@test.com');
      final email2 = Email((b) => b.value = 'test2@test.com');
      expect(email1, isNot(equals(email2)));
    });
  });
}
