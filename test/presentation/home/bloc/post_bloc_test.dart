import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magnum_bank/data/repositories/post_repository.dart';
import 'package:magnum_bank/domain/entities/post.dart';
import 'package:magnum_bank/presentation/home/bloc/post_bloc.dart';
import 'package:magnum_bank/presentation/home/bloc/post_events.dart';
import 'package:magnum_bank/presentation/home/bloc/post_state.dart';
import 'package:mocktail/mocktail.dart';


class _MockIPostRepository extends Mock implements IPostRepository {}

void main() {
  group('PostsBloc', () {
    late PostsBloc postsBloc;
    late _MockIPostRepository mockPostRepository;

    setUp(() {
      mockPostRepository = _MockIPostRepository();
      postsBloc = PostsBloc(postRepository: mockPostRepository);
    });

    tearDown(() {
      postsBloc.close();
    });

    final mockPosts = [
       Post(id: 1, userId: 1, title: 'Test Post 1', body: 'Body 1'),
       Post(id: 2, userId: 1, title: 'Test Post 2', body: 'Body 2'),
    ];

    blocTest<PostsBloc, PostsState>(
      'emite [PostsLoading, PostsSuccess] quando FetchPosts é bem-sucedido',
      build: () {
        when(() => mockPostRepository.getPosts(start: 0, limit: 10))
            .thenAnswer((_) async => mockPosts);
        return postsBloc;
      },
      act: (bloc) => bloc.add(FetchPosts()),
      expect: () => [
        isA<PostsLoading>(),
        PostsSuccess(posts: mockPosts, hasMore: true),
      ],
    );

    blocTest<PostsBloc, PostsState>(
      'emite [PostsLoading, PostsFailure] quando FetchPosts falha',
      build: () {
        when(() => mockPostRepository.getPosts(start: 0, limit: 10))
            .thenThrow(Exception('Erro de teste'));
        return postsBloc;
      },
      act: (bloc) => bloc.add(FetchPosts()),
      expect: () => [
        isA<PostsLoading>(),
        isA<PostsFailure>(),
      ],
    );
  });
}