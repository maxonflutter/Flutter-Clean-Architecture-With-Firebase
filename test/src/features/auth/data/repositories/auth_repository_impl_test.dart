import 'package:flutter_clean_architecture_with_firebase/src/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/data/models/auth_user_model.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([
  AuthRemoteDataSource,
  AuthLocalDataSource,
])
void main() {
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;
  late AuthRepositoryImpl authRepository;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    authRepository = AuthRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const email = 'test@gmail.com';
  const password = 'password12345';
  const authUserModel = AuthUserModel(id: '123', email: 'test@test.com');

  group('authUser', () {
    test(
        'emits AuthUser.empty when remoteDataSource.user emits null'
        'and clear the local user data', () async {
      when(mockRemoteDataSource.user).thenAnswer((_) => Stream.value(null));

      final result = await authRepository.authUser.first;

      expect(result, AuthUser.empty);

      verify(mockLocalDataSource.write(key: 'user', value: null)).called(1);
    });

    test(
        'emits an AuthUser when remoteDataSource.user emits non-null value'
        'and stores the user data locally', () async {
      when(mockRemoteDataSource.user).thenAnswer(
        (_) => Stream.value(authUserModel),
      );

      final result = await authRepository.authUser.first;

      expect(result, authUserModel.toEntity());

      verify(mockLocalDataSource.write(key: 'user', value: authUserModel))
          .called(1);
    });
  });

  group('signUp', () {
    test(
        'calls [signUpWithEmailAndPassword] and [write] with correct arguments',
        () async {
      when(
        mockRemoteDataSource.signUpWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => authUserModel);

      await authRepository.signUp(email: email, password: password);

      verify(
        mockRemoteDataSource.signUpWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).called(1);

      verify(mockLocalDataSource.write(key: 'user', value: authUserModel))
          .called(1);
    });

    test(
        'returns an AuthUser when remoteDataSource.signUpWithEmailAndPassword returns an AuthUserModel successfully',
        () async {
      when(
        mockRemoteDataSource.signUpWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => authUserModel);
      final results =
          await authRepository.signUp(email: email, password: password);

      expect(results, equals(authUserModel.toEntity()));
    });
  });

  group('signIn', () {
    test('calls signInWithEmailAndPassword with correct arguments', () async {
      when(mockRemoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).thenAnswer((_) async => authUserModel);

      await authRepository.signIn(email: email, password: password);

      verify(mockRemoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      )).called(1);

      verify(mockLocalDataSource.write(key: 'user', value: authUserModel))
          .called(1);
    });

    test(
        'returns an AuthUser when remoteDataSource.signInWithEmailAndPassword returns an AuthUserModel successfully',
        () async {
      when(
        mockRemoteDataSource.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => authUserModel);

      final results =
          await authRepository.signIn(email: email, password: password);

      expect(results, equals(authUserModel.toEntity()));
    });
  });

  group('signOut', () {
    test('calls signOut and clears local user data', () async {
      when(mockRemoteDataSource.signOut()).thenAnswer((_) async {});

      await authRepository.signOut();

      verify(mockRemoteDataSource.signOut()).called(1);
      verify(mockLocalDataSource.write(key: 'user', value: null)).called(1);
    });
  });
}
