import 'package:flutter_clean_architecture_with_firebase/src/features/auth/data/models/auth_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_user_model_test.mocks.dart';

@GenerateMocks([firebase_auth.User])
void main() {
  late MockUser mockUser;

  setUp(() {
    mockUser = MockUser();

    when(mockUser.uid).thenReturn('testId');
    when(mockUser.email).thenReturn('test@test.com');
    when(mockUser.displayName).thenReturn('Test User');
    when(mockUser.photoURL).thenReturn('http://example.com/photo.jpg');
  });

  const id = 'testId';
  const email = 'test@test.com';
  const name = 'Test User';
  const photoURL = 'http://example.com/photo.jpg';

  const authUserModel = AuthUserModel(
    id: id,
    email: email,
    name: name,
    photoURL: photoURL,
  );

  group('AuthUserModel', () {
    test('properties are correctly assigned on creation', () {
      expect(authUserModel.id, equals(id));
      expect(authUserModel.email, equals(email));
      expect(authUserModel.name, equals(name));
      expect(authUserModel.photoURL, equals(photoURL));
    });

    test('creates AuthUserModel from FirebaseUser', () {
      final authUserModel = AuthUserModel.fromFirebaseAuthUser(mockUser);

      expect(authUserModel.id, equals(mockUser.uid));
      expect(authUserModel.email, equals(mockUser.email));
      expect(authUserModel.name, equals(mockUser.displayName));
      expect(authUserModel.photoURL, equals(mockUser.photoURL));
    });

    test('converts to entity correctly', () {
      final authUser = authUserModel.toEntity();

      expect(authUser.id, equals(id));
      expect(authUser.email, equals(email));
      expect(authUser.name, equals(name));
      expect(authUser.photoURL, equals(photoURL));
    });

    test('get props returns a list with all properties', () {
      final props = authUserModel.props;

      expect(props, containsAll([id, email, name, photoURL]));
    });

    test('handles null values in firebase user correctly', () {
      when(mockUser.email).thenReturn('');
      when(mockUser.displayName).thenReturn(null);
      when(mockUser.photoURL).thenReturn(null);

      final authUserModel = AuthUserModel.fromFirebaseAuthUser(mockUser);

      expect(authUserModel.email, equals(''));
      expect(authUserModel.name, isNull);
      expect(authUserModel.photoURL, isNull);
    });
  });
}
