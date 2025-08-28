import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magnum_bank/data/repositories/auth_repository.dart';
import 'package:magnum_bank/domain/entities/user.dart';
import 'package:magnum_bank/presentation/profile/bloc/profile_bloc.dart';
import 'package:magnum_bank/presentation/profile/bloc/profile_event.dart';
import 'package:magnum_bank/presentation/profile/bloc/profile_state.dart';
import 'package:mocktail/mocktail.dart';

// Mock do repositório
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late ProfileBloc profileBloc;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    profileBloc = ProfileBloc(authRepository: mockAuthRepository);
  });

  tearDown(() {
    profileBloc.close();
  });

  final mockUserProfile = UserProfile(
    id: '1',
    nome: 'Leanne Graham',
    imagem: 'https://www.example.com/avatar.jpg',
    idade: 45,
    hobbies: ['dançar', 'comer', 'fumar'],
    qntdPost: 10,
  );

  group('ProfileBloc', () {
    blocTest<ProfileBloc, ProfileState>(
      'emite [ProfileLoading, ProfileSuccess] quando o perfil é carregado com sucesso',
      build: () {
        when(() => mockAuthRepository.getUserProfile(userId: '1'))
            .thenAnswer((_) async => mockUserProfile);
        return profileBloc;
      },
      act: (bloc) => bloc.add(const FetchUserProfile(userId: '1')),
      expect: () => [
        ProfileLoading(),
        ProfileSuccess(profile: mockUserProfile),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emite [ProfileLoading, ProfileFailure] quando o perfil não é encontrado',
      build: () {
        when(() => mockAuthRepository.getUserProfile(userId: '2'))
            .thenAnswer((_) async => null);
        return profileBloc;
      },
      act: (bloc) => bloc.add(const FetchUserProfile(userId: '2')),
      expect: () => [
        ProfileLoading(),
        const ProfileFailure(error: 'Perfil não encontrado.'),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emite [ProfileLoading, ProfileFailure] quando ocorre uma exceção',
      build: () {
        when(() => mockAuthRepository.getUserProfile(userId: '3'))
            .thenThrow(Exception('Erro ao buscar perfil'));
        return profileBloc;
      },
      act: (bloc) => bloc.add(const FetchUserProfile(userId: '3')),
      expect: () => [
        ProfileLoading(),
        ProfileFailure(error: 'Exception: Erro ao buscar perfil'),
      ],
    );
  });
}
