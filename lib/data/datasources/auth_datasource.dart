import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:magnum_bank/domain/entities/user.dart';
class AuthDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthDataSource({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  Future<UserCredential> signInWithEmail(
      {required String email, required String password}) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> saveUserProfile(
      {required String userId, required UserProfile profile}) async {
    await _firestore.collection('profiles').doc(userId).set(profile.toMap());
  }

  Future<UserProfile?> getUserProfile({required String userId}) async {
    try {
      final doc = await _firestore.collection('profiles').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return UserProfile(
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          age: data['age'] ?? 0,
          hobbies: List<String>.from(data['hobbies'] ?? []),
          postCount: data['postCount'] ?? 0,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Erro ao buscar perfil: $e');
      return null;
    }
  }
}