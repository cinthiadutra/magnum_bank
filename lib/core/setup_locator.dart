import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:magnum_bank/data/datasources/auth_datasource.dart';
import 'package:magnum_bank/data/datasources/post_datasource.dart';
import 'package:magnum_bank/data/repositories/auth_repository.dart';
import 'package:magnum_bank/data/repositories/auth_repository_impl.dart';
import 'package:magnum_bank/data/repositories/post_repository.dart';
import 'package:magnum_bank/data/repositories/post_repository_impl.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_bloc.dart';
import 'package:magnum_bank/presentation/home/bloc/post_bloc.dart';
import 'package:magnum_bank/presentation/post_details/bloc/post_detail_bloc.dart';
import 'package:magnum_bank/presentation/profile/bloc/profile_bloc.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AuthDataSource>(
    () => AuthDataSource(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ),
  );
  locator.registerLazySingleton<PostDataSource>(
    () => PostDataSource(dio: Dio()),
  );

  locator.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(authDataSource: locator<AuthDataSource>()),
  );
  locator.registerLazySingleton<IPostRepository>(
    () => PostRepositoryImpl(postDataSource: locator<PostDataSource>()),
  );

  locator.registerSingleton<AuthBloc>(
    AuthBloc(authRepository: locator<IAuthRepository>()),
  );
  locator.registerSingleton<PostsBloc>(
    PostsBloc(postRepository: locator<IPostRepository>()),
  );
  locator.registerSingleton<PostDetailBloc>(
    PostDetailBloc(postRepository: locator<IPostRepository>()),
  );
  locator.registerSingleton<ProfileBloc>(
    ProfileBloc(authRepository: locator<IAuthRepository>()),
  );
}
