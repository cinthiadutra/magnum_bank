import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magnum_bank/core/app.dart';
import 'package:magnum_bank/core/setup_locator.dart';
import 'package:magnum_bank/data/datasources/auth_datasource.dart';
import 'package:magnum_bank/data/datasources/post_datasource.dart';
import 'package:magnum_bank/data/repositories/auth_repository.dart';
import 'package:magnum_bank/data/repositories/auth_repository_impl.dart';
import 'package:magnum_bank/data/repositories/post_repository.dart';
import 'package:magnum_bank/data/repositories/post_repository_impl.dart';
import 'package:magnum_bank/firebase_options.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_bloc.dart';
import 'package:magnum_bank/presentation/home/bloc/post_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupLocator();

  final dio = Dio();
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final authDataSource = AuthDataSource(
    auth: firebaseAuth,
    firestore: firestore,
  );
  final postDataSource = PostDataSource(dio: dio);

  final authRepository = AuthRepositoryImpl(authDataSource: authDataSource);
  final postRepository = PostRepositoryImpl(postDataSource: postDataSource);

  runApp(MyApp(authRepository: authRepository, postRepository: postRepository));
}

class MyApp extends StatelessWidget {
  final IAuthRepository authRepository;
  final IPostRepository postRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.postRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(authRepository: authRepository),
      child: App(
        authRepository: authRepository,
        postRepository: postRepository,
      ),
    );
  }
}
