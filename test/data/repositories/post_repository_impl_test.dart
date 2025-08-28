import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnum_bank/data/datasources/post_datasource.dart';
import 'package:magnum_bank/data/repositories/post_repository_impl.dart';
import 'package:magnum_bank/domain/entities/post.dart';

// Mock do PostDataSource
class MockPostDataSource extends Mock implements PostDataSource {}

void main() {
  late PostRepositoryImpl repository;
  late MockPostDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockPostDataSource();
    repository = PostRepositoryImpl(postDataSource: mockDataSource);
  });

  group('PostRepositoryImpl', () {
    final postList = [
      Post(userId: 1, id: 1, title: 'Title 1', body: 'Body 1'),
      Post(userId: 1, id: 2, title: 'Title 2', body: 'Body 2'),
    ];

    test('getPosts retorna lista de posts', () async {
      // Arrange
      when(() => mockDataSource.getPosts())
          .thenAnswer((_) async => postList);

      // Act
      final result = await repository.getPosts();

      // Assert
      expect(result, postList);
      verify(() => mockDataSource.getPosts()).called(1);
    });

    test('getPostDetails retorna post específico', () async {
      // Arrange
      final post = Post(userId: 1, id: 1, title: 'Title 1', body: 'Body 1');
      when(() => mockDataSource.getPostDetails(postId: 1))
          .thenAnswer((_) async => post);

      // Act
      final result = await repository.getPostDetails(postId: 1);

      // Assert
      expect(result, post);
      verify(() => mockDataSource.getPostDetails(postId: 1)).called(1);
    });

    test('getPostDetails lança exceção se datasource falhar', () async {
      // Arrange
      when(() => mockDataSource.getPostDetails(postId: 1))
          .thenThrow(Exception('Erro'));

      // Act & Assert
      expect(() => repository.getPostDetails(postId: 1), throwsException);
      verify(() => mockDataSource.getPostDetails(postId: 1)).called(1);
    });
  });
}
