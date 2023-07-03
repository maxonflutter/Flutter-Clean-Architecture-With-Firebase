import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_in_use_case_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;
  late SignOutUseCase signOutUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signOutUseCase = SignOutUseCase(authRepository: mockAuthRepository);
  });

  test('should call signOut method on the AuthRepository', () async {
    when(mockAuthRepository.signOut()).thenAnswer((_) async => null);

    await signOutUseCase.call();

    verify(mockAuthRepository.signOut());
  });

  test(
      'should throw an exception when the signOut method on the AuthRepository throws an exception',
      () async {
    when(mockAuthRepository.signOut()).thenThrow(Exception());

    expect(() async => await signOutUseCase.call(), throwsA(isA<Exception>()));
  });
}
