import '../repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository authRepository;

  SignOutUseCase({required this.authRepository});

  Future<void> call() async {
    try {
      await authRepository.signOut();
    } catch (error) {
      throw Exception(error);
    }
  }
}
