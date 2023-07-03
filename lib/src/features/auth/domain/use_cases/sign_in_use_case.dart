import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';
import '../value_objects/email.dart';
import '../value_objects/password.dart';

// Each Use Case should have a single responsibility. It should represent
// one and only one action that a user can perform.
class SignInUseCase {
  // Use cases don't know anything about the underlying data sources.
  final AuthRepository authRepository;

  SignInUseCase({required this.authRepository});

  // The primary role of a use case is to orchestrate the execution of
  // a specific business operation. They coordinate the flow of data
  // to and from entities by interacting with repositories.
  Future<AuthUser> call(SignInParams params) async {
    try {
      return await authRepository.signIn(
        email: params.email.value,
        password: params.password.value,
      );
    } on ArgumentError catch (error) {
      throw Exception(error);
    } catch (error) {
      throw Exception(error);
    }
  }
}

// You can bundle several parameters into one object
// that can be easily passed around.
class SignInParams {
  final Email email;
  final Password password;

  SignInParams({
    required this.email,
    required this.password,
  });
}
