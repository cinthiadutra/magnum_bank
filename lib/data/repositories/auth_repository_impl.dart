import 'package:firebase_auth/firebase_auth.dart';
import 'package:magnum_bank/data/datasources/auth_datasource.dart';
import 'package:magnum_bank/data/repositories/auth_repository.dart';
import 'package:magnum_bank/domain/entities/user.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl({required AuthDataSource authDataSource})
      : _authDataSource = authDataSource;

  @override
  Future<UserCredential> signInWithEmail(
      {required String email, required String password}) {
    return _authDataSource.signInWithEmail(email: email, password: password);
  }

  @override
  Future<void> signOut() {
    return _authDataSource.signOut();
  }

  @override
  Stream<User?> get authStateChanges => _authDataSource.authStateChanges;

  @override
  Future<void> saveUserProfile(
      {required String userId, required UserProfile profile}) {
    return _authDataSource.saveUserProfile(userId: userId, profile: profile);
  }

  @override
  Future<UserProfile?> getUserProfile({required String userId}) {
    return _authDataSource.getUserProfile(userId: userId);
  }
}