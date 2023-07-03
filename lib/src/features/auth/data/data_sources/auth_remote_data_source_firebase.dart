import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../models/auth_user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceFirebase implements AuthRemoteDataSource {
  AuthRemoteDataSourceFirebase({
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  @override
  Stream<AuthUserModel?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        return null;
      }
      return AuthUserModel.fromFirebaseAuthUser(firebaseUser);
    });
  }

  @override
  Future<AuthUserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      firebase_auth.UserCredential credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Sign up failed: The user is null after sign up.');
      }

      return AuthUserModel.fromFirebaseAuthUser(credential.user!);
    } catch (error) {
      throw Exception('Sign up failed: $error');
    }
  }

  @override
  Future<AuthUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      firebase_auth.UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Sign in failed: The user is null after sign in.');
      }

      return AuthUserModel.fromFirebaseAuthUser(credential.user!);
    } catch (error) {
      throw Exception('Sign in failed: $error');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (error) {
      throw Exception('Sign out failed: $error');
    }
  }
}
