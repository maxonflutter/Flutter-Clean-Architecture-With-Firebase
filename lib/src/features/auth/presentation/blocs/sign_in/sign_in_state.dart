part of 'sign_in_cubit.dart';

class SignInState extends Equatable {
  final Email? email;
  final Password? password;
  final EmailStatus emailStatus;
  final PasswordStatus passwordStatus;
  final FormStatus formStatus;

  const SignInState({
    this.email,
    this.password,
    this.emailStatus = EmailStatus.unknown,
    this.passwordStatus = PasswordStatus.unknown,
    this.formStatus = FormStatus.initial,
  });

  SignInState copyWith({
    Email? email,
    Password? password,
    EmailStatus? emailStatus,
    PasswordStatus? passwordStatus,
    FormStatus? formStatus,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailStatus: emailStatus ?? this.emailStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object?> get props => [
        email,
        password,
        emailStatus,
        passwordStatus,
        formStatus,
      ];
}
