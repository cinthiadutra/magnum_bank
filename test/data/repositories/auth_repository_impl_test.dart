import 'package:flutter_test/flutter_test.dart';
import 'package:magnum_bank/data/datasources/auth_datasource.dart';
import 'package:magnum_bank/data/repositories/auth_repository_impl.dart';
import 'package:magnum_bank/domain/entities/user.dart';
import 'package:mocktail/mocktail.dart';


class _MockAuthDataSource extends Mock implements AuthDataSource {}

void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl authRepository;
    late _MockAuthDataSource mockAuthDataSource;

    setUpAll(() {
      registerFallbackValue( UserProfile(
          name: '', email: '', age: 0, hobbies: [], postCount: 0));
    });

    setUp(() {
      mockAuthDataSource = _MockAuthDataSource();
      authRepository = AuthRepositoryImpl(authDataSource: mockAuthDataSource);
    });

    test('signInWithEmail deve chamar o método correspondente no data source', () async {
      when(() => mockAuthDataSource.signInWithEmail(email: 'test@example.com', password: 'password123'))
          .thenAnswer((_) async => Future.value());
      await authRepository.signInWithEmail(email: 'test@example.com', password: 'password123');
      verify(() => mockAuthDataSource.signInWithEmail(email: 'test@example.com', password: 'password123')).called(1);
    });

    test('saveUserProfile deve chamar o método correspondente no data source', () async {
      var profile = UserProfile(name: 'Test', email: 'test@example.com', age: 25, hobbies: [], postCount: 0);
      when(() => mockAuthDataSource.saveUserProfile(userId: '123', profile: profile))
          .thenAnswer((_) async => Future.value());
      await authRepository.saveUserProfile(userId: '123', profile: profile);
      verify(() => mockAuthDataSource.saveUserProfile(userId: '123', profile: profile)).called(1);
    });
  });
}