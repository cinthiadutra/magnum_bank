import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magnum_bank/data/repositories/auth_repository.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_bloc.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_event.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_state.dart';
import 'package:magnum_bank/presentation/auth/login_screen.dart'; // O caminho para a sua tela de login

// Cria uma classe de mock para o AuthBloc
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

// Cria uma classe de mock para o IAuthRepository, necessária para o AuthBloc
class MockIAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUpAll(() {
    // Registra o fallback para o evento de login, caso seja necessário
    registerFallbackValue(const AuthLoginRequested(email: '', password: ''));
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  tearDown(() {
    mockAuthBloc.close();
  });

  Widget createLoginScreenTestWidget() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>(
        create: (context) => mockAuthBloc,
        child: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget Test', () {
    testWidgets('exibe os campos de email e senha e o botão de login', (WidgetTester tester) async {
      // Constrói a tela de login
      await tester.pumpWidget(createLoginScreenTestWidget());

      // Verifica se os widgets estão na tela
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Entrar'), findsOneWidget);
    });

    testWidgets('dispara o evento AuthLoginRequested ao pressionar o botão de login', (WidgetTester tester) async {
      // Constrói a tela
      await tester.pumpWidget(createLoginScreenTestWidget());

      // Define o comportamento do mock
      when(() => mockAuthBloc.state).thenReturn(const AuthState.unauthenticated());

      // Insere texto nos campos
      await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@example.com');
      await tester.enterText(find.widgetWithText(TextField, 'Senha'), 'password123');

      // Pressiona o botão
      await tester.tap(find.byType(ElevatedButton));

      // Espera as animações terminarem
      await tester.pumpAndSettle();

      // Verifica se o evento correto foi adicionado ao BLoC
      verify(() => mockAuthBloc.add(const AuthLoginRequested(
            email: 'test@example.com',
            password: 'password123',
          ))).called(1);
    });
  });
}