import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/value_objects/email.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/value_objects/password.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/email_status.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/form_status.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/password_status.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/sign_in/sign_in_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_in_cubit_test.mocks.dart';

@GenerateMocks([SignInUseCase])
void main() {
  late MockSignInUseCase mockSignInUseCase;

  setUp(() {
    mockSignInUseCase = MockSignInUseCase();
  });

  group('SignInCubit', () {
    blocTest<SignInCubit, SignInState>(
      'emits [] when nothing is added',
      build: () => SignInCubit(signInUseCase: mockSignInUseCase),
      expect: () => [],
    );

    blocTest<SignInCubit, SignInState>(
      'emits [valid email state] when valid email is added',
      build: () => SignInCubit(signInUseCase: mockSignInUseCase),
      act: (cubit) => cubit.emailChanged('test@test.com'),
      expect: () => [
        SignInState(
          email: Email((e) => e..value = 'test@test.com'),
          emailStatus: EmailStatus.valid,
        ),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'emits [invalid email state] when invalid email is added',
      build: () => SignInCubit(signInUseCase: mockSignInUseCase),
      act: (cubit) => cubit.emailChanged('invalid_email'),
      expect: () => [
        const SignInState(emailStatus: EmailStatus.invalid),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'emits [valid password state] when valid password is added',
      build: () => SignInCubit(signInUseCase: mockSignInUseCase),
      act: (cubit) => cubit.passwordChanged('password'),
      expect: () => [
        SignInState(
          password: Password((p) => p..value = 'password'),
          passwordStatus: PasswordStatus.valid,
        ),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'emits [invalid password state] when invalid password is added',
      build: () => SignInCubit(signInUseCase: mockSignInUseCase),
      act: (cubit) => cubit.passwordChanged('pass'),
      expect: () => [
        const SignInState(passwordStatus: PasswordStatus.invalid),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'emits formStatus [invalid, initial] when the form is not validated',
      build: () => SignInCubit(signInUseCase: mockSignInUseCase),
      seed: () => const SignInState(
        passwordStatus: PasswordStatus.unknown,
        emailStatus: EmailStatus.unknown,
      ),
      act: (cubit) => cubit.signIn(),
      expect: () => const [
        SignInState(
          passwordStatus: PasswordStatus.unknown,
          emailStatus: EmailStatus.unknown,
          formStatus: FormStatus.invalid,
        ),
        SignInState(
          passwordStatus: PasswordStatus.unknown,
          emailStatus: EmailStatus.unknown,
          formStatus: FormStatus.initial,
        ),
      ],
    );

    blocTest<SignInCubit, SignInState>(
      'emits [submissionInProgress, submissionSuccess] when signIn is successful',
      setUp: () {
        when(mockSignInUseCase(any)).thenAnswer(
          (_) => Future.value(
            const AuthUser(id: 'id', email: 'test@test.com'),
          ),
        );
      },
      build: () => SignInCubit(signInUseCase: mockSignInUseCase),
      seed: () => SignInState(
        email: Email((e) => e..value = 'test@test.com'),
        password: Password((p) => p..value = 'password123'),
        passwordStatus: PasswordStatus.valid,
        emailStatus: EmailStatus.valid,
      ),
      act: (cubit) => cubit.signIn(),
      expect: () => [
        SignInState(
          email: Email((e) => e..value = 'test@test.com'),
          password: Password((p) => p..value = 'password123'),
          passwordStatus: PasswordStatus.valid,
          emailStatus: EmailStatus.valid,
          formStatus: FormStatus.submissionInProgress,
        ),
        SignInState(
          email: Email((e) => e..value = 'test@test.com'),
          password: Password((p) => p..value = 'password123'),
          passwordStatus: PasswordStatus.valid,
          emailStatus: EmailStatus.valid,
          formStatus: FormStatus.submissionSuccess,
        ),
      ],
      verify: (bloc) {
        verify(mockSignInUseCase(any)).called(1);
      },
    );
  });
}
