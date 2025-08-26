// test/profile_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_event.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa a classe User do pacote correto

// Importe os arquivos necessários do seu projeto
import 'package:magnum_bank/core/setup_locator.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_bloc.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_state.dart';
import 'package:magnum_bank/presentation/profile/bloc/profile_bloc.dart';
import 'package:magnum_bank/presentation/profile/bloc/profile_event.dart';
import 'package:magnum_bank/presentation/profile/bloc/profile_state.dart';
import 'package:magnum_bank/presentation/profile/profile_screen.dart';

// Mocks para as classes que ProfileScreen depende
class MockAuthBloc extends Mock implements AuthBloc {}
class MockProfileBloc extends Mock implements ProfileBloc {}

// Classe de exemplo para a entidade de perfil, se ainda não existir
class UserProfile {
  final String name;
  final String email;
  final int age;
  final List<String> hobbies;
  final int postCount;

  const UserProfile({
    required this.name,
    required this.email,
    required this.age,
    required this.hobbies,
    required this.postCount,
  });
}

// A classe User duplicada foi removida daqui para evitar o conflito.

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockProfileBloc mockProfileBloc;

  // Antes de cada teste, inicializa os mocks
  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockProfileBloc = MockProfileBloc();

    // Garante que o `locator` está pronto para o teste
    if (locator.isRegistered<ProfileBloc>()) {
      locator.unregister<ProfileBloc>();
    }
    locator.registerFactory<ProfileBloc>(() => mockProfileBloc);
  });

  // O grupo de testes para a ProfileScreen
  group('ProfileScreen', () {
    testWidgets('mostra CircularProgressIndicator quando o estado é ProfileLoading', (WidgetTester tester) async {
      // Mock do estado do AuthBloc para fornecer um userId
      when(() => mockAuthBloc.state).thenReturn(const AuthState(
        status: AuthStatus.authenticated,
        user: User(uid: '12345'),
      ));

      // Mock do stream do ProfileBloc para emitir o estado de carregamento
      when(() => mockProfileBloc.state).thenReturn(ProfileLoading());
      when(() => mockProfileBloc.stream).thenAnswer((_) => Stream.value(ProfileLoading()));
      
      // Constrói o widget
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>.value(value: mockAuthBloc),
              BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
            ],
            child: const ProfileScreen(),
          ),
        ),
      );

      // Verifica se o CircularProgressIndicator é renderizado
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('mostra os dados do perfil quando o estado é ProfileSuccess', (WidgetTester tester) async {
      // Cria uma entidade de perfil de exemplo
      final userProfile = UserProfile(
        name: 'John Doe',
        email: 'john@example.com',
        age: 30,
        hobbies: ['coding', 'reading'],
        postCount: 5,
      );

      // Mock do estado do AuthBloc para fornecer um userId
      when(() => mockAuthBloc.state).thenReturn(const AuthState(
        status: AuthStatus.authenticated,
        user: User(uid: '12345'),
      ));

      // Mock do stream do ProfileBloc para emitir o estado de sucesso
      when(() => mockProfileBloc.state).thenReturn(ProfileSuccess(, profile: null));
      when(() => mockProfileBloc.stream).thenAnswer((_) => Stream.value(ProfileSuccess(userProfile)));

      // Constrói o widget
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>.value(value: mockAuthBloc),
              BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
            ],
            child: const ProfileScreen(),
          ),
        ),
      );

      // Verifica se todos os textos com os dados do perfil são renderizados
      expect(find.text('Nome: John Doe'), findsOneWidget);
      expect(find.text('Email: john@example.com'), findsOneWidget);
      expect(find.text('Idade: 30'), findsOneWidget);
      expect(find.text('Hobbies: coding, reading'), findsOneWidget);
      expect(find.text('Número de Posts: 5'), findsOneWidget);
    });

    testWidgets('mostra mensagem de erro quando o estado é ProfileFailure', (WidgetTester tester) async {
      const errorMessage = 'Falha ao carregar perfil';

      // Mock do estado do AuthBloc para fornecer um userId
      when(() => mockAuthBloc.state).thenReturn(const AuthState(
        status: AuthStatus.authenticated,
        user: User(uid: '12345'),
      ));

      // Mock do stream do ProfileBloc para emitir o estado de falha
      when(() => mockProfileBloc.state).thenReturn(const ProfileFailure(errorMessage));
      when(() => mockProfileBloc.stream).thenAnswer((_) => Stream.value(const ProfileFailure(errorMessage)));
      
      // Constrói o widget
      await tester.pumpWidget(
        MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>.value(value: mockAuthBloc),
              BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
            ],
            child: const ProfileScreen(),
          ),
        ),
      );

      // Verifica se a mensagem de erro é renderizada
      expect(find.text('Erro: $errorMessage'), findsOneWidget);
    });
  });
}
