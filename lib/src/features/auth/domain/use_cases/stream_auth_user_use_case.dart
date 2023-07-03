import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class StreamAuthUserUseCase {
  final AuthRepository authRepository;

  StreamAuthUserUseCase({required this.authRepository});

  Stream<AuthUser> call() {
    try {
      return authRepository.authUser;
    } catch (error) {
      throw Exception(error);
    }
  }
}
