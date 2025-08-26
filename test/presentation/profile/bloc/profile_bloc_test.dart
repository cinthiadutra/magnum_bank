import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magnum_bank/domain/entities/user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnum_bank/data/repositories/auth_repository.dart'; // O mesmo para IAuthRepository
import 'package:magnum_bank/presentation/profile/bloc/profile_bloc.dart';
import 'package:magnum_bank/presentation/profile/bloc/profile_event.dart';
import 'package:magnum_bank/presentation/profile/bloc/profile_state.dart';

// Cria a classe de mock para o IAuthRepository
class MockIAuthRepository extends Mock implements IAuthRepository {}

void main() {
  group('ProfileBloc', () {
    late ProfileBloc profileBloc;
    late MockIAuthRepository mockAuthRepository;

    // Configurações iniciais antes de cada teste
    setUp(() {
      mockAuthRepository = MockIAuthRepository();
      profileBloc = ProfileBloc(authRepository: mockAuthRepository);
    });

    // Limpeza após cada teste
    tearDown(() {
      profileBloc.close();
    });

    const testUserId = 'user_123';
    final testUserProfile = UserProfile(
      name: testUserId,
      age:33,
      postCount: 44,
      email: 'joao.silva@teste.com',
      hobbies:  const ['Nadar', "fumar", "Beber"],
    );

    // Teste para o estado inicial
    test('o estado inicial deve ser ProfileInitial', () {
      expect(profileBloc.state, isA<ProfileInitial>());
    });

    // --- Testes para o evento FetchUserProfile ---

    blocTest<ProfileBloc, ProfileState>(
      'emite [ProfileLoading, ProfileSuccess] quando o perfil é carregado com sucesso',
      build: () {
        // Simula o comportamento do repositório para retornar o perfil
        when(() => mockAuthRepository.getUserProfile(userId: testUserId))
            .thenAnswer((_) async => testUserProfile);
        return profileBloc;
      },
      act: (bloc) => bloc.add(const FetchUserProfile(userId: testUserId)),
      expect: () => [
        isA<ProfileLoading>(),
         ProfileSuccess(profile: testUserProfile),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emite [ProfileLoading, ProfileFailure] quando o perfil não é encontrado (retorna nulo)',
      build: () {
        // Simula o repositório retornando nulo (perfil não encontrado)
        when(() => mockAuthRepository.getUserProfile(userId: testUserId))
            .thenAnswer((_) async => null);
        return profileBloc;
      },
      act: (bloc) => bloc.add(const FetchUserProfile(userId: testUserId)),
      expect: () => [
        isA<ProfileLoading>(),
        const ProfileFailure(error: 'Perfil não encontrado.'),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emite [ProfileLoading, ProfileFailure] quando ocorre uma exceção',
      build: () {
        // Simula o repositório lançando uma exceção
        when(() => mockAuthRepository.getUserProfile(userId: testUserId))
            .thenThrow(Exception('Erro de conexão com a API'));
        return profileBloc;
      },
      act: (bloc) => bloc.add(const FetchUserProfile(userId: testUserId)),
      expect: () => [
        isA<ProfileLoading>(),
        isA<ProfileFailure>(),
      ],
    );
  });
}
