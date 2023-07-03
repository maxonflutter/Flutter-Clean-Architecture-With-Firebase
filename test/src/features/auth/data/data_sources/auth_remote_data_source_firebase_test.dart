import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/data/data_sources/auth_remote_data_source_firebase.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/data/models/auth_user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_remote_data_source_firebase_test.mocks.dart';

@GenerateMocks([
  firebase_auth.FirebaseAuth,
  firebase_auth.UserCredential,
  firebase_auth.User,
])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late AuthRemoteDataSourceFirebase authRemoteDataSource;
  late AuthUserModel authUserModel;

  const tEmail = 'test@test.com';
  const tPassword = 'password';

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    when(mockUser.uid).thenReturn('test_uid');
    when(mockUser.email).thenReturn('test_email');
    when(mockUser.displayName).thenReturn('test_username');
    when(mockUser.photoURL).thenReturn('test_photoURL');
    authUserModel = AuthUserModel.fromFirebaseAuthUser(mockUser);
    authRemoteDataSource = AuthRemoteDataSourceFirebase(
      firebaseAuth: mockFirebaseAuth,
    );
  });

  group('signUpWithEmailAndPassword', () {
    test(
        'should return AuthUserModel when signUpWithEmailAndPassword is successful',
        () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockUserCredential);
      when(mockUserCredential.user).thenReturn(mockUser);

      final result = await authRemoteDataSource.signUpWithEmailAndPassword(
        email: tEmail,
        password: tPassword,
      );

      expect(result, equals(authUserModel));
    });

    test('should throw Exception when signUpWithEmailAndPassword fails',
        () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(Exception());

      final call = authRemoteDataSource.signUpWithEmailAndPassword;

      expect(
        () => call(email: tEmail, password: tPassword),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('signInWithEmailAndPassword', () {
    test(
      'should call signInWithEmailAndPassword on FirebaseAuth with correct email and password',
      () async {
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockUser);

        final result = await authRemoteDataSource.signInWithEmailAndPassword(
          email: 'test@test.com',
          password: 'test_password',
        );

        expect(result, equals(authUserModel));

        verify(mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'test@test.com',
          password: 'test_password',
        ));
      },
    );

    test(
      'should throw an Exception when FirebaseAuth throws an exception',
      () async {
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(Exception('Sign in failed: test error'));

        final call = authRemoteDataSource.signInWithEmailAndPassword;

        expect(
          () => call(
            email: 'test@test.com',
            password: 'test_password',
          ),
          throwsA(isA<Exception>()),
        );
      },
    );
  });

  group('signOut', () {
    test(
      'should call signOut on FirebaseAuth',
      () async {
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        await authRemoteDataSource.signOut();

        verify(mockFirebaseAuth.signOut());
      },
    );

    test(
      'should throw an Exception when FirebaseAuth throws an exception',
      () async {
        when(mockFirebaseAuth.signOut())
            .thenThrow(Exception('Sign out failed: test error'));

        final call = authRemoteDataSource.signOut;

        expect(
          () => call(),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
