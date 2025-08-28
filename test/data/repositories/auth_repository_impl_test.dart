import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnum_bank/data/datasources/auth_datasource.dart';
import 'package:magnum_bank/data/repositories/auth_repository_impl.dart';
import 'package:magnum_bank/domain/entities/user.dart';

// Mock do AuthDataSource
class MockAuthDataSource extends Mock implements AuthDataSource {}

// Mock do UserCredential
class MockUserCredential extends Mock implements UserCredential {}

// Mock do User (do Firebase)
class MockUser extends Mock implements User {}
void main() {
  late MockAuthDataSource mockDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockAuthDataSource();
    repository = AuthRepositoryImpl(authDataSource: mockDataSource);
  });

  final testUserId = '123';
  final testProfile = UserProfile(
    id: testUserId,
    nome: 'Leanne Graham',
    imagem: 'https://url.com/image.jpg',
    idade: 45,
    hobbies: ['dançar', 'comer', 'fumar'],
    qntdPost: 10,
  );

  final testEmail = 'test@example.com';
  final testPassword = '123456';
  final mockUserCredential = MockUserCredential();
  final mockUser = MockUser();

  group('AuthRepositoryImpl', () {
    test('signInWithEmail calls datasource', () async {
      when(() => mockDataSource.signInWithEmail(
              email: testEmail, password: testPassword))
          .thenAnswer((_) async => mockUserCredential);

      final result = await repository.signInWithEmail(
          email: testEmail, password: testPassword);

      expect(result, mockUserCredential);
      verify(() => mockDataSource.signInWithEmail(
          email: testEmail, password: testPassword)).called(1);
    });

    test('signOut calls datasource', () async {
      when(() => mockDataSource.signOut()).thenAnswer((_) async => Future.value());

      await repository.signOut();

      verify(() => mockDataSource.signOut()).called(1);
    });

    test('authStateChanges returns datasource stream', () {
      final controller = Stream<User?>.empty();
      when(() => mockDataSource.authStateChanges).thenReturn(controller);

      final result = repository.authStateChanges;

      expect(result, controller);
    });

    test('saveUserProfile calls datasource', () async {
      when(() => mockDataSource.saveUserProfile(userId: testUserId, profile: testProfile))
          .thenAnswer((_) async => Future.value());

      await repository.saveUserProfile(userId: testUserId, profile: testProfile);

      verify(() => mockDataSource.saveUserProfile(userId: testUserId, profile: testProfile))
          .called(1);
    });

    test('getUserProfile calls datasource and returns profile', () async {
      when(() => mockDataSource.getUserProfileById(testUserId))
          .thenAnswer((_) async => testProfile);

      final result = await repository.getUserProfile(userId: testUserId);

      expect(result, testProfile);
      verify(() => mockDataSource.getUserProfileById(testUserId)).called(1);
    });
  });
}
