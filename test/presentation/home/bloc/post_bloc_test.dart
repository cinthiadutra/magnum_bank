import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magnum_bank/presentation/home/bloc/post_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnum_bank/domain/entities/post.dart';
import 'package:magnum_bank/data/repositories/post_repository.dart';
import 'package:magnum_bank/presentation/home/bloc/post_state.dart';
import 'package:magnum_bank/presentation/home/bloc/post_events.dart';

// Mock do repositório
class MockPostRepository extends Mock implements IPostRepository {}

void main() {
  late PostsBloc postsBloc;
  late MockPostRepository mockPostRepository;

  setUp(() {
    mockPostRepository = MockPostRepository();
    postsBloc = PostsBloc(postRepository: mockPostRepository);
  });

  tearDown(() {
    postsBloc.close();
  });

  final fakePosts = List.generate(
    25,
    (index) => Post(
      id: index + 1,
      userId: 1,
      title: 'Test Post ${index + 1}',
      body: 'Body ${index + 1}',
    ),
  );

  blocTest<PostsBloc, PostsState>(
    'emite PostsLoading e PostsSuccess com posts carregados corretamente',
    build: () {
      when(
        () => mockPostRepository.getPosts(),
      ).thenAnswer((_) async => fakePosts);
      return postsBloc;
    },
    act: (bloc) => bloc.add(FetchPosts()),
    expect: () => [
      isA<PostsLoading>(),
      predicate<PostsSuccess>(
        (state) => state.posts.length == 10 && state.hasMore == true,
      ),
    ],
  );

  blocTest<PostsBloc, PostsState>(
    'emite PostsLoading e PostsSuccess vazio caso repositório retorne null',
    build: () {
      when(() => mockPostRepository.getPosts()).thenAnswer((_) async => []);
      return postsBloc;
    },
    act: (bloc) => bloc.add(FetchPosts()),
    expect: () => [
      isA<PostsLoading>(),
      predicate<PostsSuccess>(
        (state) => state.posts.isEmpty && state.hasMore == false,
      ),
    ],
  );

  blocTest<PostsBloc, PostsState>(
    'emite PostsFailure caso ocorra exceção',
    build: () {
      when(
        () => mockPostRepository.getPosts(),
      ).thenThrow(Exception('Erro na API'));
      return postsBloc;
    },
    act: (bloc) => bloc.add(FetchPosts()),
    expect: () => [isA<PostsLoading>(), isA<PostsFailure>()],
  );
}
