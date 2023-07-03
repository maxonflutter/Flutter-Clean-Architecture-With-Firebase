import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/value_objects/email.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/value_objects/password.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/email_status.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/form_status.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/password_status.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/sign_in/sign_in_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignInState', () {
    test('should correctly copy state with new email', () {
      const initialState = SignInState();
      final email = Email((email) => email..value = 'test@test.com');

      final newState = initialState.copyWith(
        email: email,
        emailStatus: EmailStatus.valid,
      );

      expect(newState.email, equals(email));
      expect(newState.emailStatus, equals(EmailStatus.valid));
      expect(newState.password, equals(initialState.password));
      expect(newState.passwordStatus, equals(PasswordStatus.unknown));
    });

    test('should not update the email if the new value is invalid', () {
      const initialState = SignInState();

      try {
        final email = Email((email) => email..value = 'testtest');
        // ignore: unused_local_variable
        final newState = initialState.copyWith(email: email);

        // If the above line did not throw an error, fail the test
        fail('Should have thrown an ArgumentError');
      } on ArgumentError {
        // If an ArgumentError was thrown, continue the test
        expect(initialState.email, isNull);
      }
    });

    test('should correctly copy state with new password', () {
      const initialState = SignInState();
      final password = Password((password) => password..value = 'password1234');

      final newState = initialState.copyWith(
        password: password,
        passwordStatus: PasswordStatus.valid,
      );

      expect(newState.password, equals(password));
      expect(newState.passwordStatus, equals(PasswordStatus.valid));
      expect(newState.email, equals(initialState.email));
      expect(newState.emailStatus, equals(EmailStatus.unknown));
    });

    test('should not update the password if the new value is invalid', () {
      const initialState = SignInState();

      try {
        final password = Password((password) => password..value = 'test');
        // ignore: unused_local_variable
        final newState = initialState.copyWith(password: password);

        // If the above line did not throw an error, fail the test
        fail('Should have thrown an ArgumentError');
      } on ArgumentError {
        // If an ArgumentError was thrown, continue the test
        expect(initialState.password, isNull);
      }
    });

    test('should correctly copy state with new formStatus', () {
      const initialState = SignInState();
      final newState = initialState.copyWith(
        formStatus: FormStatus.submissionInProgress,
      );

      expect(
        newState.formStatus,
        equals(FormStatus.submissionInProgress),
      );

      // The other fields do not change
      expect(newState.email, equals(initialState.email));
      expect(newState.password, equals(initialState.password));
      expect(newState.emailStatus, equals(initialState.emailStatus));
      expect(newState.passwordStatus, equals(initialState.passwordStatus));
    });
  });
}
