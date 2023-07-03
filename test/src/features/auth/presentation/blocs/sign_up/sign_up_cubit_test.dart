import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/value_objects/email.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/value_objects/password.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/email_status.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/form_status.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/password_status.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/sign_up/sign_up_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_up_cubit_test.mocks.dart';

@GenerateMocks([SignUpUseCase])
void main() {
  late MockSignUpUseCase mockSignUpUseCase;

  setUp(() {
    mockSignUpUseCase = MockSignUpUseCase();
  });

  group('SignUpCubit', () {
    blocTest<SignUpCubit, SignUpState>(
      'emits [] when nothing is added',
      build: () => SignUpCubit(signUpUseCase: mockSignUpUseCase),
      expect: () => [],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits [valid email state] when valid email is added',
      build: () => SignUpCubit(signUpUseCase: mockSignUpUseCase),
      act: (cubit) => cubit.emailChanged('test@test.com'),
      expect: () => [
        SignUpState(
          email: Email((e) => e..value = 'test@test.com'),
          emailStatus: EmailStatus.valid,
        ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits [invalid email state] when invalid email is added',
      build: () => SignUpCubit(signUpUseCase: mockSignUpUseCase),
      act: (cubit) => cubit.emailChanged('invalid_email'),
      expect: () => [
        const SignUpState(emailStatus: EmailStatus.invalid),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits [valid password state] when valid password is added',
      build: () => SignUpCubit(signUpUseCase: mockSignUpUseCase),
      act: (cubit) => cubit.passwordChanged('password'),
      expect: () => [
        SignUpState(
          password: Password((p) => p..value = 'password'),
          passwordStatus: PasswordStatus.valid,
        ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits [invalid password state] when invalid password is added',
      build: () => SignUpCubit(signUpUseCase: mockSignUpUseCase),
      act: (cubit) => cubit.passwordChanged('pass'),
      expect: () => [
        const SignUpState(passwordStatus: PasswordStatus.invalid),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits formStatus [invalid, initial] when the form is not validated',
      build: () => SignUpCubit(signUpUseCase: mockSignUpUseCase),
      seed: () => const SignUpState(
        passwordStatus: PasswordStatus.unknown,
        emailStatus: EmailStatus.unknown,
      ),
      act: (cubit) => cubit.signUp(),
      expect: () => const [
        SignUpState(
          passwordStatus: PasswordStatus.unknown,
          emailStatus: EmailStatus.unknown,
          formStatus: FormStatus.invalid,
        ),
        SignUpState(
          passwordStatus: PasswordStatus.unknown,
          emailStatus: EmailStatus.unknown,
          formStatus: FormStatus.initial,
        ),
      ],
    );

    blocTest<SignUpCubit, SignUpState>(
      'emits [submissionInProgress, submissionSuccess] when signUp is successful',
      setUp: () {
        when(mockSignUpUseCase(any)).thenAnswer(
          (_) => Future.value(
            const AuthUser(id: 'id', email: 'test@test.com'),
          ),
        );
      },
      build: () => SignUpCubit(signUpUseCase: mockSignUpUseCase),
      seed: () => SignUpState(
        email: Email((e) => e..value = 'test@test.com'),
        password: Password((p) => p..value = 'password123'),
        passwordStatus: PasswordStatus.valid,
        emailStatus: EmailStatus.valid,
      ),
      act: (cubit) => cubit.signUp(),
      expect: () => [
        SignUpState(
          email: Email((e) => e..value = 'test@test.com'),
          password: Password((p) => p..value = 'password123'),
          passwordStatus: PasswordStatus.valid,
          emailStatus: EmailStatus.valid,
          formStatus: FormStatus.submissionInProgress,
        ),
        SignUpState(
          email: Email((e) => e..value = 'test@test.com'),
          password: Password((p) => p..value = 'password123'),
          passwordStatus: PasswordStatus.valid,
          emailStatus: EmailStatus.valid,
          formStatus: FormStatus.submissionSuccess,
        ),
      ],
      verify: (bloc) {
        verify(mockSignUpUseCase(any)).called(1);
      },
    );
  });
}
