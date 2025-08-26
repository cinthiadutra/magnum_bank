import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:magnum_bank/data/repositories/post_repository.dart';
import 'package:magnum_bank/domain/entities/post.dart';
import 'package:magnum_bank/presentation/post_details/bloc/post_detail_bloc.dart';
import 'package:magnum_bank/presentation/post_details/bloc/post_detail_event.dart';
import 'package:magnum_bank/presentation/post_details/bloc/post_detail_state.dart';
import 'package:mocktail/mocktail.dart';


class _MockIPostRepository extends Mock implements IPostRepository {}

void main() {
  group('PostDetailBloc', () {
    late PostDetailBloc postDetailBloc;
    late _MockIPostRepository mockPostRepository;

    setUp(() {
      mockPostRepository = _MockIPostRepository();
      postDetailBloc = PostDetailBloc(postRepository: mockPostRepository);
    });

    tearDown(() {
      postDetailBloc.close();
    });

    final mockPost =  Post(
        id: 1, userId: 1, title: 'Test Post', body: 'Test body');

    blocTest<PostDetailBloc, PostDetailState>(
      'emite [PostDetailLoading, PostDetailSuccess] quando FetchPostDetail é bem-sucedido',
      build: () {
        when(() => mockPostRepository.getPostDetails(postId: 1))
            .thenAnswer((_) async => mockPost);
        return postDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchPostDetail(postId: 1)),
      expect: () => [
        isA<PostDetailLoading>(),
        PostDetailSuccess(post: mockPost),
      ],
    );

    blocTest<PostDetailBloc, PostDetailState>(
      'emite [PostDetailLoading, PostDetailFailure] quando FetchPostDetail falha',
      build: () {
        when(() => mockPostRepository.getPostDetails(postId: 1))
            .thenThrow(Exception('Erro de teste'));
        return postDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchPostDetail(postId: 1)),
      expect: () => [
        isA<PostDetailLoading>(),
        isA<PostDetailFailure>(),
      ],
    );
  });
}
