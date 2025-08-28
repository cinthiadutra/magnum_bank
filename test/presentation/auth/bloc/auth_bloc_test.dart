import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magnum_bank/data/repositories/auth_repository.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_bloc.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_event.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Mocks
class _MockIAuthRepository extends Mock implements IAuthRepository {}
class _MockUser extends Mock implements User {}

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late _MockIAuthRepository mockAuthRepository;
    late _MockUser mockUser;

    setUpAll(() {
      // Registrar fallback para eventos que precisam de valores padrões
      registerFallbackValue(const AuthLoginRequested(email: '', password: ''));
    });

    setUp(() {
      mockAuthRepository = _MockIAuthRepository();
      mockUser = _MockUser();

      // Configura o Stream antes do AuthBloc ser instanciado
      when(() => mockAuthRepository.authStateChanges)
          .thenAnswer((_) => Stream<User?>.empty());

      authBloc = AuthBloc(authRepository: mockAuthRepository);
    });

    tearDown(() {
      authBloc.close();
    });

    test('estado inicial deve ser AuthState.unauthenticated()', () {
      expect(authBloc.state, const AuthState.unauthenticated());
    });

    blocTest<AuthBloc, AuthState>(
      'emite AuthState.authenticated quando AuthStatusChanged é adicionado com um usuário',
      build: () => authBloc,
      act: (bloc) => bloc.add(AuthStatusChanged(mockUser)),
      expect: () => [
        AuthState.authenticated(mockUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emite AuthState.unauthenticated quando AuthStatusChanged é adicionado com null',
      build: () => authBloc,
      act: (bloc) => bloc.add(const AuthStatusChanged(null)),
      expect: () => [
        const AuthState.unauthenticated(),
      ],
    );
  });
}
