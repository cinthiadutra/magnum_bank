// ignore_for_file: subtype_of_sealed_class

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnum_bank/data/datasources/auth_datasource.dart';
import 'package:magnum_bank/domain/entities/user.dart';

// Mocks
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}
class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}
class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}
class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocRef;
  late AuthDataSource dataSource;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference();
    mockDocRef = MockDocumentReference();

    when(() => mockFirestore.collection(any())).thenReturn(mockCollection);
    when(() => mockCollection.doc(any())).thenReturn(mockDocRef);

    dataSource = AuthDataSource(auth: mockAuth, firestore: mockFirestore);
  });

  group('AuthDataSource', () {
    final testUserId = '123';
    final testUserProfile = UserProfile(
      id: testUserId,
      nome: 'Leanne Graham',
      imagem: 'https://url.com/image.jpg',
      idade: 45,
      hobbies: ['dançar', 'comer', 'fumar'],
      qntdPost: 10,
    );

    test('saveUserProfile calls Firestore set', () async {
      when(() => mockDocRef.set(testUserProfile.toMap()))
          .thenAnswer((_) async => Future.value());

      await dataSource.saveUserProfile(userId: testUserId, profile: testUserProfile);

      verify(() => mockFirestore.collection('users')).called(1);
      verify(() => mockCollection.doc(testUserId)).called(1);
      verify(() => mockDocRef.set(testUserProfile.toMap())).called(1);
    });

    test('getUserProfileById returns UserProfile if exists', () async {
      final mockSnapshot = MockDocumentSnapshot();
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(true);
      when(() => mockSnapshot.data()).thenReturn(testUserProfile.toMap());
      when(() => mockSnapshot.id).thenReturn(testUserId);

      final result = await dataSource.getUserProfileById(testUserId);

      expect(result.id, testUserId);
      expect(result.nome, 'Leanne Graham');
      expect(result.idade, 45);
      expect(result.hobbies.length, 3);
      expect(result.qntdPost, 10);
    });

    test('getUserProfileById throws exception if doc does not exist', () async {
      final mockSnapshot = MockDocumentSnapshot();
      when(() => mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(() => mockSnapshot.exists).thenReturn(false);

      expect(
          () async => await dataSource.getUserProfileById(testUserId),
          throwsA(isA<Exception>().having(
              (e) => e.toString(), 'message', contains('Usuário não encontrado'))));
    });
  });
}
