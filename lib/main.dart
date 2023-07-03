import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';
import 'src/features/auth/data/data_sources/auth_local_data_source.dart';
import 'src/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'src/features/auth/data/data_sources/auth_remote_data_source_firebase.dart';
import 'src/features/auth/data/repositories/auth_repository_impl.dart';
import 'src/features/auth/domain/entities/auth_user.dart';
import 'src/features/auth/domain/repositories/auth_repository.dart';
import 'src/features/auth/presentation/screens/sign_in_screen.dart';

typedef AppBuilder = Future<Widget> Function();

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(await builder());
}

void main() {
  bootstrap(
    () async {
      AuthLocalDataSource authLocalDataSource = AuthLocalDataSource();
      AuthRemoteDataSource authRemoteDataSource =
          AuthRemoteDataSourceFirebase();

      AuthRepository authRepository = AuthRepositoryImpl(
        localDataSource: authLocalDataSource,
        remoteDataSource: authRemoteDataSource,
      );

      return App(
        authRepository: authRepository,
        authUser: await authRepository.authUser.first,
      );
    },
  );
}

class App extends StatelessWidget {
  const App({
    super.key,
    required this.authRepository,
    this.authUser,
  });

  final AuthRepository authRepository;
  final AuthUser? authUser;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
      ],
      child: MaterialApp(
        title: 'Clean Architecture',
        theme: ThemeData.light(useMaterial3: true),
        home: const SignInScreen(),
      ),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Clean Architecture')),
//       body: const Column(children: []),
//     );
//   }
// }
