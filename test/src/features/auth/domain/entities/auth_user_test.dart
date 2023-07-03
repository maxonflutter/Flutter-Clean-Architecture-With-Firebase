import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('empty AuthUser has correct default values', () {
    expect(AuthUser.empty.id, equals(''));
    expect(AuthUser.empty.email, equals(''));
    expect(AuthUser.empty.name, equals(''));
    expect(AuthUser.empty.photoURL, equals(''));
  });

  test('two AuthUser instances with same values are equal', () {
    const user1 = AuthUser(
      id: 'id',
      email: 'email',
      name: 'name',
      photoURL: 'photoURL',
    );
    const user2 = AuthUser(
      id: 'id',
      email: 'email',
      name: 'name',
      photoURL: 'photoURL',
    );
    expect(user1, equals(user2));
  });

  test('two AuthUser instances with different values are not equal', () {
    const user1 = AuthUser(
      id: 'id1',
      email: 'email',
      name: 'name',
      photoURL: 'photoURL',
    );
    const user2 = AuthUser(
      id: 'id2',
      email: 'email',
      name: 'name',
      photoURL: 'photoURL',
    );
    expect(user1, isNot(equals(user2)));
  });

  test('props returns correct properties', () {
    const user = AuthUser(
      id: 'id',
      email: 'email',
      name: 'name',
      photoURL: 'photoURL',
    );
    expect(user.props, equals(['id', 'name', 'email', 'photoURL']));
  });

  test('name and photoURL can be null', () {
    const user = AuthUser(id: 'id', email: 'email');
    expect(user.name, isNull);
    expect(user.photoURL, isNull);
  });
}
