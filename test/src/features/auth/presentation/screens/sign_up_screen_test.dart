import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/email_status.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/form_status.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/password_status.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/sign_up/sign_up_cubit.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_up_screen_test.mocks.dart';

@GenerateMocks([SignUpCubit, AuthRepository])
void main() {
  const emailInputKey = Key('signUp_emailInput_textField');
  const passwordInputKey = Key('signUp_passwordInput_textField');
  const signUpButtonKey = Key('signUp_continue_elevatedButton');

  const tEmail = 'test@gmail.com';
  const tPassword = 'password12345';

  late MockSignUpCubit mockSignUpCubit;
  late MockAuthRepository mockAuthRepository;

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<SignUpCubit>(
        create: (_) => mockSignUpCubit,
        child: const SignUpView(),
      ),
    );
  }

  setUp(() {
    mockSignUpCubit = MockSignUpCubit();
    mockAuthRepository = MockAuthRepository();
    when(mockSignUpCubit.state).thenReturn(const SignUpState());
    // Stub the state stream.
    when(mockSignUpCubit.stream).thenAnswer(
      (_) => Stream.fromIterable([const SignUpState()]),
    );
  });

  testWidgets('renders a SignUpScreen', (tester) async {
    await tester.pumpWidget(
      RepositoryProvider<AuthRepository>(
        create: (_) => mockAuthRepository,
        child: const MaterialApp(home: SignUpScreen()),
      ),
    );

    expect(find.byType(SignUpView), findsOneWidget);
  });

  testWidgets('emailChanged when email changes with 500 milliseconds debounce',
      (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    await tester.enterText(find.byKey(emailInputKey), tEmail);
    await tester.pump(const Duration(milliseconds: 500));
    verify(mockSignUpCubit.emailChanged(tEmail)).called(1);
  });

  testWidgets(
      'passwordChanged when email changes with 500 milliseconds debounce',
      (tester) async {
    await tester.pumpWidget(makeTestableWidget());

    await tester.enterText(find.byKey(passwordInputKey), tPassword);
    await tester.pump(const Duration(milliseconds: 500));
    verify(mockSignUpCubit.passwordChanged(tPassword)).called(1);
  });

  testWidgets('AppBar & ElevatedButton are present with correct text',
      (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Sign Up'), findsWidgets);
  });

  testWidgets('Two TextFormFields are present', (tester) async {
    await tester.pumpWidget(makeTestableWidget());

    expect(find.byType(TextFormField), findsNWidgets(2));
  });
  testWidgets('Show snack bar when the form status is invalid',
      (WidgetTester tester) async {
    //Arrange
    const text = 'Invalid form: please fill in all fields';
    final expectedStates = [
      const SignUpState(formStatus: FormStatus.initial),
      const SignUpState(formStatus: FormStatus.invalid),
    ];

    when(mockSignUpCubit.stream).thenAnswer(
      (_) => Stream.fromIterable(expectedStates),
    );

    //Act
    await tester.pumpWidget(makeTestableWidget());
    expect(find.text(text), findsNothing);
    await tester.pump();

    //Assert
    expect(find.text(text), findsOneWidget);
  });

  testWidgets('Show snack bar when the form status is submissionFailure',
      (WidgetTester tester) async {
    //Arrange
    const text = 'There was an error with the sign up process. Try again.';
    final expectedStates = [
      const SignUpState(formStatus: FormStatus.initial),
      const SignUpState(formStatus: FormStatus.submissionFailure),
    ];

    when(mockSignUpCubit.stream).thenAnswer(
      (_) => Stream.fromIterable(expectedStates),
    );

    //Act
    await tester.pumpWidget(makeTestableWidget());
    expect(find.text(text), findsNothing);
    await tester.pump();

    //Assert
    expect(find.text(text), findsOneWidget);
  });

  testWidgets('Email field shows error for invalid email', (tester) async {
    when(mockSignUpCubit.state).thenReturn(
      const SignUpState(
        emailStatus: EmailStatus.invalid,
      ),
    );
    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Invalid email'), findsOneWidget);
  });

  testWidgets('Password field shows error for invalid password',
      (tester) async {
    when(mockSignUpCubit.state)
        .thenReturn(const SignUpState(passwordStatus: PasswordStatus.invalid));
    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Invalid password'), findsOneWidget);
  });

  testWidgets('SignUp function is called when button is pressed',
      (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    await tester.tap(find.byType(ElevatedButton));
    verify(mockSignUpCubit.signUp()).called(1);
  });

  testWidgets(
      'SignUp button is disabled when formStatus is submissionInProgress',
      (tester) async {
    when(mockSignUpCubit.state).thenReturn(
      const SignUpState(
        formStatus: FormStatus.submissionInProgress,
      ),
    );
    await tester.pumpWidget(makeTestableWidget());
    expect(
      // tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled,
      tester.widget<ElevatedButton>(find.byKey(signUpButtonKey)).enabled,
      isFalse,
    );
  });
}
