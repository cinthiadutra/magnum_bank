import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:magnum_bank/data/repositories/auth_repository.dart';
import 'package:magnum_bank/data/repositories/post_repository.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_bloc.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_event.dart';
import 'package:magnum_bank/presentation/auth/views/login_screen.dart';
import 'package:magnum_bank/presentation/home/bloc/post_bloc.dart';
import 'package:magnum_bank/presentation/home/post_screen.dart';
import 'package:magnum_bank/presentation/post_details/bloc/post_detail_bloc.dart';
import 'package:magnum_bank/presentation/post_details/post_detail_screen.dart';
import 'package:magnum_bank/presentation/profile/profile_screen.dart';

class App extends StatelessWidget {
  final IAuthRepository authRepository;
  final IPostRepository postRepository;
  const App({
    super.key,
    required this.authRepository,
    required this.postRepository,
  });

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/login',
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => BlocProvider<PostsBloc>(
            create: (_) => PostsBloc(postRepository: postRepository),
            child: const PostsScreen(),
          ),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(userProfile: null),
        ),
        GoRoute(
          path: '/post/:id',
          builder: (context, state) {
            final postId = int.parse(state.pathParameters['id']!);
            return BlocProvider<PostDetailBloc>(
              create: (_) => PostDetailBloc(postRepository: postRepository),
              child: PostDetailScreen(postId: postId),
            );
          },
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final authState = context.read<AuthBloc>().state;
        final isLoggedIn = authState.status == AuthStatus.authenticated;
        final isLoggingIn = state.fullPath == '/login';

        if (!isLoggedIn && !isLoggingIn) {
          return '/login';
        }
        if (isLoggedIn && isLoggingIn) {
          return '/';
        }
        return null;
      },
    );
    return MaterialApp.router(
      routerConfig: router,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
