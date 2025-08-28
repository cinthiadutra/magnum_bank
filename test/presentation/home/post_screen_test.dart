import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:magnum_bank/data/repositories/post_repository.dart';
import 'package:magnum_bank/domain/entities/post.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_bloc.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_event.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_state.dart';
import 'package:magnum_bank/presentation/home/bloc/post_bloc.dart';
import 'package:magnum_bank/presentation/home/bloc/post_events.dart';
import 'package:magnum_bank/presentation/home/bloc/post_state.dart';
import 'package:magnum_bank/presentation/home/post_screen.dart';
import 'package:mocktail/mocktail.dart';

// Mocks para os BLoCs e Repositórios
class MockPostsBloc extends MockBloc<PostsEvent, PostsState>
    implements PostsBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockIPostRepository extends Mock implements IPostRepository {}

// Mock para o GoRouter, para simular a navegação
class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockPostsBloc mockPostsBloc;
  late MockAuthBloc mockAuthBloc;
  late GoRouter mockGoRouter;

  // Mock do PostModel para testes
  var mockPost = Post(
    id: 1,
    userId: 1,
    title: 'Post de Teste',
    body:
        'Corpo do post de teste. Este é um texto mais longo para verificar o truncamento.',
  );

  setUpAll(() {
    // Registra o fallback para o evento de posts
    registerFallbackValue(FetchPosts());
    registerFallbackValue(AuthLogoutRequested());
  });

  setUp(() {
    mockPostsBloc = MockPostsBloc();
    mockAuthBloc = MockAuthBloc();
    // Cria um GoRouter mockado
    mockGoRouter = GoRouter(
      routes: [GoRoute(path: '/', builder: (context, state) => Container())],
    );
  });

  tearDown(() {
    mockPostsBloc.close();
    mockAuthBloc.close();
  });

  Widget createPostsScreenTestWidget() {
    return MaterialApp.router(
      routerConfig: mockGoRouter,
      builder: (ctx, _) => MultiBlocProvider(
        providers: [
          BlocProvider<PostsBloc>(create: (context) => mockPostsBloc),
          BlocProvider<AuthBloc>(create: (context) => mockAuthBloc),
        ],
        child: const PostsScreen(),
      ),
    );
  }

  group('PostsScreen Widget Test', () {
    testWidgets('exibe CircularProgressIndicator no estado PostsInitial', (
      WidgetTester tester,
    ) async {
      // Define o comportamento inicial do BLoC
      when(() => mockPostsBloc.state).thenReturn(PostsInitial());

      await tester.pumpWidget(createPostsScreenTestWidget());

      // Verifica se o indicador de progresso é exibido
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('exibe mensagem de erro no estado PostsFailure', (
      WidgetTester tester,
    ) async {
      // Define o comportamento do BLoC para o estado de falha
      when(
        () => mockPostsBloc.state,
      ).thenReturn(const PostsFailure(error: 'Falha ao carregar posts'));

      await tester.pumpWidget(createPostsScreenTestWidget());
      await tester
          .pumpAndSettle(); // Aguarda a tela renderizar o estado de falha

      // Verifica se a mensagem de erro é exibida
      expect(find.text('Erro: Falha ao carregar posts'), findsOneWidget);
    });

   testWidgets('exibe lista de posts no estado PostsSuccess', (WidgetTester tester) async {
  when(() => mockPostsBloc.state).thenReturn(
    PostsSuccess(posts: [mockPost], hasMore: false),
  );

  await tester.pumpWidget(createPostsScreenTestWidget());
  await tester.pumpAndSettle();

  expect(find.byType(ListView), findsOneWidget);
  expect(find.text(mockPost.title), findsOneWidget);
  expect(find.textContaining('Corpo do post de teste'), findsOneWidget);
});

    testWidgets(
      'chama o evento AuthLogoutRequested quando o botão de logout é pressionado',
      (WidgetTester tester) async {
        // Define o estado inicial do BLoC para que a tela seja exibida
        when(
          () => mockPostsBloc.state,
        ).thenReturn(PostsSuccess(posts: [mockPost], hasMore: false));

        await tester.pumpWidget(createPostsScreenTestWidget());
        await tester.tap(find.byIcon(Icons.logout));
        await tester.pumpAndSettle();

        // Verifica se o evento de logout foi adicionado ao AuthBloc
        verify(() => mockAuthBloc.add(AuthLogoutRequested())).called(1);
      },
    );
  });
}
