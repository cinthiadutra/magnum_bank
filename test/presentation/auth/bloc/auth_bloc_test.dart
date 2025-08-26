import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magnum_bank/data/repositories/auth_repository.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_bloc.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_event.dart';
import 'package:magnum_bank/presentation/auth/bloc/auth_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';

class _MockIAuthRepository extends Mock implements IAuthRepository {}

class _MockUser extends Mock implements User {}

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late _MockIAuthRepository mockAuthRepository;
    late _MockUser mockUser;

    setUpAll(() {
      registerFallbackValue(const AuthLoginRequested(email: '', password: ''));
    });

    setUp(() {
      mockAuthRepository = _MockIAuthRepository();
      authBloc = AuthBloc(authRepository: mockAuthRepository);
      mockUser = _MockUser();
    });

    tearDown(() {
      authBloc.close();
    });

    test('o estado inicial deve ser AuthState.unauthenticated()', () {
      expect(authBloc.state, const AuthState.unauthenticated());
    });

    blocTest<AuthBloc, AuthState>(
      'emite AuthState.authenticated quando AuthStatusChanged é adicionado com um usuário',
      build: () {
        when(() => mockAuthRepository.authStateChanges)
            .thenAnswer((_) => Stream.value(mockUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthStatusChanged(mockUser)),
      expect: () => [
        AuthState.authenticated(mockUser),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emite AuthState.unauthenticated quando AuthStatusChanged é adicionado com null',
      build: () {
        when(() => mockAuthRepository.authStateChanges)
            .thenAnswer((_) => Stream.value(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthStatusChanged(null)),
      expect: () => [
        const AuthState.unauthenticated(),
      ],
    );
  });
}
