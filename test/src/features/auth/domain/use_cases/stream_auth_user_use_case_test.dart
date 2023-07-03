import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/use_cases/stream_auth_user_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'stream_auth_user_use_case_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late StreamAuthUserUseCase streamAuthUserUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    streamAuthUserUseCase =
        StreamAuthUserUseCase(authRepository: mockAuthRepository);
  });

  const tAuthUser = AuthUser(id: '123', email: 'test@test.com');

  test(
    'should call authUser getter on the AuthRepository',
    () async {
      when(mockAuthRepository.authUser).thenAnswer(
        (_) => Stream.value(tAuthUser),
      );

      streamAuthUserUseCase.call();

      verify(mockAuthRepository.authUser);
    },
  );

  test(
    'should throw an exception when the authUser getter on the AuthRepository throws an exception',
    () async {
      when(mockAuthRepository.authUser).thenThrow(Exception());

      final call = streamAuthUserUseCase.call;

      expect(() => call(), throwsA(isInstanceOf<Exception>()));
    },
  );

  test(
    'should return the correct AuthUser when the authUser getter on the AuthRepository returns an AuthUser',
    () async {
      when(mockAuthRepository.authUser)
          .thenAnswer((_) => Stream.value(tAuthUser));

      final result = streamAuthUserUseCase.call();
      final authUser = await result.first;
      expect(authUser, equals(tAuthUser));
    },
  );
}
