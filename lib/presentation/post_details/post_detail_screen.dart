import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magnum_bank/core/setup_locator.dart';
import 'package:magnum_bank/presentation/post_details/bloc/post_detail_bloc.dart';
import 'package:magnum_bank/presentation/post_details/bloc/post_detail_event.dart';
import 'package:magnum_bank/presentation/post_details/bloc/post_detail_state.dart';

class PostDetailScreen extends StatelessWidget {
  final int postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostDetailBloc>(
      create: (context) => locator<PostDetailBloc>()..add(FetchPostDetail(postId: postId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Detalhes do Post #$postId'),
        ),
        body: BlocBuilder<PostDetailBloc, PostDetailState>(
          builder: (context, state) {
            if (state is PostDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PostDetailSuccess) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.post.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(state.post.body),
                  ],
                ),
              );
            }
            if (state is PostDetailFailure) {
              return Center(child: Text('Erro: ${state.error}'));
            }
            return Container();
          },
        ),
      ),
    );
  }
}