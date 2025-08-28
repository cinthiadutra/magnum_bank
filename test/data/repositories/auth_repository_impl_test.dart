import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magnum_bank/data/datasources/auth_datasource.dart';
import 'package:magnum_bank/data/repositories/auth_repository_impl.dart';
import 'package:magnum_bank/domain/entities/user.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthDataSource extends Mock implements AuthDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthDataSource();
    repository = AuthRepositoryImpl(authDataSource: mockDataSource);
  });

  final testEmail = 'test@example.com';
  final testPassword = '123456';
  final testUserCredential = MockUserCredential();
  final testUserProfile = UserProfile(
    nome: 'Cinthia',
    idade: 30,
    id: '123456789',
    imagem: '',
    hobbies: ['andar', 'chorar', 'dormir'],
    qntdPost: 10,
  );
  final testUserId = 'user123';

  group('AuthRepositoryImpl', () {
    test('signInWithEmail chama AuthDataSource', () async {
      when(
        () => mockDataSource.signInWithEmail(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => testUserCredential);

      final result = await repository.signInWithEmail(
        email: testEmail,
        password: testPassword,
      );

      expect(result, testUserCredential);
      verify(
        () => mockDataSource.signInWithEmail(
          email: testEmail,
          password: testPassword,
        ),
      ).called(1);
    });

    test('signOut chama AuthDataSource', () async {
      when(
        () => mockDataSource.signOut(),
      ).thenAnswer((_) async => Future.value());

      await repository.signOut();

      verify(() => mockDataSource.signOut()).called(1);
    });

    test('saveUserProfile chama AuthDataSource', () async {
      when(
        () => mockDataSource.saveUserProfile(
          userId: testUserId,
          profile: testUserProfile,
        ),
      ).thenAnswer((_) async => Future.value());

      await repository.saveUserProfile(
        userId: testUserId,
        profile: testUserProfile,
      );

      verify(
        () => mockDataSource.saveUserProfile(
          userId: testUserId,
          profile: testUserProfile,
        ),
      ).called(1);
    });

    test('getUserProfile retorna o perfil do AuthDataSource', () async {
      when(
        () => mockDataSource.getUserProfileById(testUserId),
      ).thenAnswer((_) async => testUserProfile);

      final result = await repository.getUserProfile(userId: testUserId);

      expect(result, testUserProfile);
      verify(() => mockDataSource.getUserProfileById(testUserId)).called(1);
    });

    test('authStateChanges delega para AuthDataSource', () {
      final mockStream = Stream<User?>.empty();
      when(() => mockDataSource.authStateChanges).thenAnswer((_) => mockStream);

      final stream = repository.authStateChanges;

      expect(stream, mockStream);
      verify(() => mockDataSource.authStateChanges).called(1);
    });
  });
}

// Mock de UserCredential
class MockUserCredential extends Mock implements UserCredential {}
