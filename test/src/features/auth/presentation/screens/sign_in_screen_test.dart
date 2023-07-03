import 'package:flutter_clean_architecture_with_firebase/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/email_status.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/form_status.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/password_status.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/blocs/sign_in/sign_in_cubit.dart';
import 'package:flutter_clean_architecture_with_firebase/src/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

import 'sign_in_screen_test.mocks.dart';

@GenerateMocks([SignInCubit, AuthRepository])
void main() {
  const emailInputKey = Key('signIn_emailInput_textField');
  const passwordInputKey = Key('signIn_passwordInput_textField');
  const signInButtonKey = Key('signIn_continue_elevatedButton');

  const tEmail = 'test@gmail.com';
  const tPassword = 'password12345';

  late MockSignInCubit mockSignInCubit;
  late MockAuthRepository mockAuthRepository;

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<SignInCubit>(
        create: (_) => mockSignInCubit,
        child: const SignInView(),
      ),
    );
  }

  setUp(() {
    mockSignInCubit = MockSignInCubit();
    mockAuthRepository = MockAuthRepository();
    when(mockSignInCubit.state).thenReturn(const SignInState());
    // Stub the state stream.
    when(mockSignInCubit.stream).thenAnswer(
      (_) => Stream.fromIterable([const SignInState()]),
    );
  });

  testWidgets('renders a SignInScreen', (tester) async {
    await tester.pumpWidget(
      RepositoryProvider<AuthRepository>(
        create: (_) => mockAuthRepository,
        child: const MaterialApp(home: SignInScreen()),
      ),
    );

    expect(find.byType(SignInView), findsOneWidget);
  });

  testWidgets('emailChanged when email changes with 500 milliseconds debounce',
      (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    await tester.enterText(find.byKey(emailInputKey), tEmail);
    await tester.pump(const Duration(milliseconds: 500));
    verify(mockSignInCubit.emailChanged(tEmail)).called(1);
  });

  testWidgets(
      'passwordChanged when email changes with 500 milliseconds debounce',
      (tester) async {
    await tester.pumpWidget(makeTestableWidget());

    await tester.enterText(find.byKey(passwordInputKey), tPassword);
    await tester.pump(const Duration(milliseconds: 500));
    verify(mockSignInCubit.passwordChanged(tPassword)).called(1);
  });

  testWidgets('AppBar & ElevatedButton are present with correct text',
      (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Sign In'), findsWidgets);
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
      const SignInState(formStatus: FormStatus.initial),
      const SignInState(formStatus: FormStatus.invalid),
    ];

    when(mockSignInCubit.stream).thenAnswer(
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
    const text = 'There was an error with the sign in process. Try again.';
    final expectedStates = [
      const SignInState(formStatus: FormStatus.initial),
      const SignInState(formStatus: FormStatus.submissionFailure),
    ];

    when(mockSignInCubit.stream).thenAnswer(
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
    when(mockSignInCubit.state).thenReturn(
      const SignInState(
        emailStatus: EmailStatus.invalid,
      ),
    );
    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Invalid email'), findsOneWidget);
  });

  testWidgets('Password field shows error for invalid password',
      (tester) async {
    when(mockSignInCubit.state)
        .thenReturn(const SignInState(passwordStatus: PasswordStatus.invalid));
    await tester.pumpWidget(makeTestableWidget());

    expect(find.text('Invalid password'), findsOneWidget);
  });

  testWidgets('SignIn function is called when button is pressed',
      (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    await tester.tap(find.byType(ElevatedButton));
    verify(mockSignInCubit.signIn()).called(1);
  });

  testWidgets(
      'SignIn button is disabled when formStatus is submissionInProgress',
      (tester) async {
    when(mockSignInCubit.state).thenReturn(
      const SignInState(
        formStatus: FormStatus.submissionInProgress,
      ),
    );
    await tester.pumpWidget(makeTestableWidget());
    expect(
      // tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled,
      tester.widget<ElevatedButton>(find.byKey(signInButtonKey)).enabled,
      isFalse,
    );
  });
}
