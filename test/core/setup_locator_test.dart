import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:magnum_bank/data/repositories/auth_repository.dart';
import 'package:magnum_bank/data/repositories/auth_repository_impl.dart';
import 'package:magnum_bank/data/repositories/post_repository.dart';
import 'package:magnum_bank/data/repositories/post_repository_impl.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_event.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnum_bank/core/setup_locator.dart';
import 'package:magnum_bank/data/datasources/auth_datasource.dart';
import 'package:magnum_bank/data/datasources/post_datasource.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_bloc.dart';
import 'package:magnum_bank/presentation/home/bloc/post_bloc.dart';
import 'package:magnum_bank/presentation/post_details/bloc/post_detail_bloc.dart';
import 'package:magnum_bank/presentation/profile/bloc/profile_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import '../data/datasources/auth_datasource_test.dart';
import '../data/repositories/auth_repository_impl_test.dart'
    hide MockUserCredential;

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockDio mockDio;
  late MockUser mockUser;

  setUp(() {
    GetIt.I.reset();

    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockDio = MockDio();
    mockUser = MockUser();

    when(() => mockUser.uid).thenReturn('123');
    when(
      () => mockAuth.authStateChanges(),
    ).thenAnswer((_) => Stream.value(mockUser));
    when(
      () => mockAuth.signInWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => MockUserCredential());

    GetIt.I.registerLazySingleton<AuthDataSource>(
      () => AuthDataSource(auth: mockAuth, firestore: mockFirestore),
    );
    GetIt.I.registerLazySingleton<PostDataSource>(
      () => PostDataSource(dio: mockDio),
    );

    GetIt.I.registerLazySingleton<IAuthRepository>(
      () => AuthRepositoryImpl(authDataSource: GetIt.I<AuthDataSource>()),
    );
    GetIt.I.registerLazySingleton<IPostRepository>(
      () => PostRepositoryImpl(postDataSource: GetIt.I<PostDataSource>()),
    );

    GetIt.I.registerSingleton<AuthBloc>(
      AuthBloc(authRepository: GetIt.I<IAuthRepository>()),
    );
    GetIt.I.registerSingleton<PostsBloc>(
      PostsBloc(postRepository: GetIt.I<IPostRepository>()),
    );
    GetIt.I.registerSingleton<PostDetailBloc>(
      PostDetailBloc(postRepository: GetIt.I<IPostRepository>()),
    );
    GetIt.I.registerSingleton<ProfileBloc>(
      ProfileBloc(authRepository: GetIt.I<IAuthRepository>()),
    );
  });

  test('Locator should register all dependencies', () {
    expect(GetIt.I<AuthDataSource>(), isA<AuthDataSource>());
    expect(GetIt.I<PostDataSource>(), isA<PostDataSource>());
    expect(GetIt.I<AuthBloc>(), isA<AuthBloc>());
    expect(GetIt.I<PostsBloc>(), isA<PostsBloc>());
    expect(GetIt.I<PostDetailBloc>(), isA<PostDetailBloc>());
    expect(GetIt.I<ProfileBloc>(), isA<ProfileBloc>());
  });

  test('AuthBloc emits initial state', () {
    final authBloc = GetIt.I<AuthBloc>();
    expect(authBloc.state.runtimeType.toString(), equals('AuthState'));
  });

  test('AuthBloc login emits authenticated state', () async {
    final authBloc = GetIt.I<AuthBloc>();

    authBloc.add(
      AuthLoginRequested(email: 'test@test.com', password: '123456'),
    );

    await expectLater(
      authBloc.stream,
      emitsInOrder([
        isA<AuthState>().having(
          (s) => s.status,
          'status',
          AuthStatus.authenticated,
        ),
      ]),
    );
  });
}
