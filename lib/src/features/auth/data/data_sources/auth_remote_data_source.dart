import '../models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<AuthUserModel?> get user;

  Future<AuthUserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
