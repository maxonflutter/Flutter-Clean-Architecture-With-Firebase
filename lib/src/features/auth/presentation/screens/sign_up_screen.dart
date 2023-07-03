import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/sign_up_use_case.dart';
import '../blocs/email_status.dart';
import '../blocs/form_status.dart';
import '../blocs/password_status.dart';
import '../blocs/sign_up/sign_up_cubit.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(
        signUpUseCase: SignUpUseCase(
          authRepository: context.read<AuthRepository>(),
        ),
      ),
      child: const SignUpView(),
    );
  }
}

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state.formStatus == FormStatus.invalid) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Invalid form: please fill in all fields'),
                ),
              );
          }
          if (state.formStatus == FormStatus.submissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text(
                    'There was an error with the sign up process. Try again.',
                  ),
                ),
              );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  key: const Key('signUp_emailInput_textField'),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: state.emailStatus == EmailStatus.invalid
                        ? 'Invalid email'
                        : null,
                  ),
                  onChanged: (String value) {
                    if (debounce?.isActive ?? false) debounce?.cancel();
                    debounce = Timer(const Duration(milliseconds: 500), () {
                      context.read<SignUpCubit>().emailChanged(value);
                    });
                  },
                ),
                TextFormField(
                  key: const Key('signUp_passwordInput_textField'),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: state.passwordStatus == PasswordStatus.invalid
                        ? 'Invalid password'
                        : null,
                  ),
                  onChanged: (String value) {
                    context.read<SignUpCubit>().passwordChanged(value);
                  },
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  key: const Key('signUp_continue_elevatedButton'),
                  onPressed: context.read<SignUpCubit>().state.formStatus ==
                          FormStatus.submissionInProgress
                      ? null
                      : () {
                          context.read<SignUpCubit>().signUp();
                        },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
