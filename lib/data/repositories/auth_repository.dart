import 'package:firebase_auth/firebase_auth.dart';
import 'package:magnum_bank/domain/entities/user.dart';

abstract class IAuthRepository {
  Future<UserCredential> signInWithEmail(
      {required String email, required String password});
  Future<void> signOut();
  Stream<User?> get authStateChanges;
  Future<void> saveUserProfile(
      {required String userId, required UserProfile profile});
  Future<UserProfile?> getUserProfile({required String userId});
}