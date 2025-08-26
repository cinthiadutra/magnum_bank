// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:magnum_bank/core/setup_locator.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_bloc.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_event.dart';
import 'package:magnum_bank/presentation/home/bloc/post_bloc.dart';
import 'package:magnum_bank/presentation/home/bloc/post_events.dart';
import 'package:magnum_bank/presentation/home/bloc/post_state.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final ScrollController _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  bool _isPostsFetched = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isPostsFetched) {
      context.read<PostsBloc>().add(FetchPosts());
      _isPostsFetched = true;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      context.read<PostsBloc>().add(FetchMorePosts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.go('/profile');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state is PostsInitial || state is PostsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PostsFailure) {
            return Center(child: Text('Erro: ${state.error}'));
          }
          if (state is PostsSuccess) {
            final posts = state.posts;
            return ListView.builder(
              controller: _scrollController,
              itemCount: posts.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= posts.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final post = posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(
                    post.body.length > 100
                        ? '${post.body.substring(0, 100)}...'
                        : post.body,
                  ),
                  onTap: () {
                    context.go('/post/${post.id}');
                  },
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
