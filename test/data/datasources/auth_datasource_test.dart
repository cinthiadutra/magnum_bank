// ignore_for_file: subtype_of_sealed_class

import 'package:flutter_test/flutter_test.dart';
import 'package:magnum_bank/data/datasources/auth_datasource.dart';
import 'package:magnum_bank/domain/entities/user.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}
class _MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class _MockCollectionReference extends Mock implements CollectionReference {}
class _MockDocumentReference extends Mock implements DocumentReference {}
class _MockDocumentSnapshot extends Mock implements DocumentSnapshot {}
class _MockUserCredential extends Mock implements UserCredential {}
class _MockUser extends Mock implements User {}

void main() {
  group('AuthDataSource', () {
    late AuthDataSource authDataSource;
    late _MockFirebaseAuth mockAuth;
    late _MockFirebaseFirestore mockFirestore;
    late _MockCollectionReference mockCollection;
    late _MockDocumentReference mockDocument;
    late _MockDocumentSnapshot mockSnapshot;
    late _MockUserCredential mockUserCredential;

    setUp(() {
      mockAuth = _MockFirebaseAuth();
      mockFirestore = _MockFirebaseFirestore();
      mockCollection = _MockCollectionReference();
      mockDocument = _MockDocumentReference();
      mockSnapshot = _MockDocumentSnapshot();
      mockUserCredential = _MockUserCredential();

      when(() => mockFirestore.collection('profiles')).thenReturn(mockCollection as CollectionReference<Map<String, dynamic>>);
      when(() => mockCollection.doc(any())).thenReturn(mockDocument);

      authDataSource = AuthDataSource(auth: mockAuth, firestore: mockFirestore);
    });

    test('signInWithEmail deve retornar UserCredential em caso de sucesso', () async {
      when(() => mockAuth.signInWithEmailAndPassword(email: 'test@example.com', password: 'password'))
          .thenAnswer((_) async => mockUserCredential);
      final result = await authDataSource.signInWithEmail(email: 'test@example.com', password: 'password');
      expect(result, equals(mockUserCredential));
    });

    test('saveUserProfile deve chamar o método set no Firestore', () async {
      var profile = UserProfile(name: 'Test', email: 'test@example.com', age: 25, hobbies: [], postCount: 0);
      when(() => mockDocument.set(profile.toMap())).thenAnswer((_) async => Future.value());
      await authDataSource.saveUserProfile(userId: '123', profile: profile);
      verify(() => mockDocument.set(profile.toMap())).called(1);
    });

    test('getUserProfile deve retornar UserProfile em caso de sucesso', () async {
      final mockData = {'name': 'Test', 'email': 'test@example.com', 'age': 25, 'hobbies': [], 'postCount': 0};
      when(() => mockSnapshot.exists).thenReturn(true);
      when(() => mockSnapshot.data()).thenReturn(mockData);
      when(() => mockDocument.get()).thenAnswer((_) async => mockSnapshot);

      final result = await authDataSource.getUserProfile(userId: '123');
      expect(result, isA<UserProfile>());
      expect(result!.name, 'Test');
    });

    test('getUserProfile deve retornar null se o documento não existir', () async {
      when(() => mockSnapshot.exists).thenReturn(false);
      when(() => mockDocument.get()).thenAnswer((_) async => mockSnapshot);

      final result = await authDataSource.getUserProfile(userId: '123');
      expect(result, isNull);
    });
  });
}
