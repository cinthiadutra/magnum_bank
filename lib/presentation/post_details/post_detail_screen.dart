import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:magnum_bank/core/setup_locator.dart';
import 'package:magnum_bank/data/datasources/auth_datasource.dart';
import 'package:magnum_bank/domain/entities/user.dart';
import 'package:magnum_bank/presentation/post_details/bloc/post_detail_bloc.dart';
import 'package:magnum_bank/presentation/post_details/bloc/post_detail_event.dart';
import 'package:magnum_bank/presentation/post_details/bloc/post_detail_state.dart';
import 'package:magnum_bank/presentation/profile/profile_screen.dart';

class PostDetailScreen extends StatelessWidget {
  final int postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PostDetailBloc>();
    bloc.add(FetchPostDetail(postId: postId));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Detalhes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyActions: true,
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
      ),
      body: BlocBuilder<PostDetailBloc, PostDetailState>(
        builder: (context, state) {
          if (state is PostDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is PostDetailSuccess) {
            final post = state.post;
            return FutureBuilder<UserProfile>(
              future: locator<AuthDataSource>().getUserProfileById(
                post.userId.toString(),
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final author = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(userProfile: author),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 41,
                              backgroundColor: Colors.red,

                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(author.imagem),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text('Autor: ', style: TextStyle(fontSize: 16)),
                            Text(
                              '${author.nome}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        post.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 20),
                      Text(post.body),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            );
          }
          if (state is PostDetailFailure) {
            return Center(child: Text('Erro: ${state.error}'));
          }
          return Container();
        },
      ),
    );
  }
}
