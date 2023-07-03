import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/value_objects/email.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/value_objects/password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_in_use_case_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;
  late SignUpUseCase signUpUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signUpUseCase = SignUpUseCase(authRepository: mockAuthRepository);
  });

  final tEmail = Email((email) => email.value = 'test@test.com');
  final tPassword = Password((password) => password.value = 'password123');
  const tAuthUser = AuthUser(id: '123', email: 'test@test.com');
  final tSignUpParams = SignUpParams(email: tEmail, password: tPassword);

  test(
      'should call signUp method on the AuthRepository with correct parameters',
      () async {
    when(mockAuthRepository.signUp(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => tAuthUser);

    await signUpUseCase.call(tSignUpParams);

    verify(mockAuthRepository.signUp(
      email: tSignUpParams.email.value,
      password: tSignUpParams.password.value,
    ));
  });

  test(
      'should throw an exception when the signUp method on the AuthRepository throws an exception',
      () async {
    when(mockAuthRepository.signUp(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenThrow(Exception());

    expect(() async => await signUpUseCase.call(tSignUpParams),
        throwsA(isA<Exception>()));
  });

  test(
      'should return the correct AuthUser when the signUp method on the AuthRepository returns an AuthUser',
      () async {
    when(mockAuthRepository.signUp(
      email: anyNamed('email'),
      password: anyNamed('password'),
    )).thenAnswer((_) async => tAuthUser);

    final result = await signUpUseCase.call(tSignUpParams);

    expect(result, equals(tAuthUser));
  });
}
