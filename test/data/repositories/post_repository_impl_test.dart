import 'package:flutter_test/flutter_test.dart';
import 'package:magnum_bank/data/datasources/post_datasource.dart';
import 'package:magnum_bank/data/repositories/post_repository_impl.dart';
import 'package:magnum_bank/domain/entities/post.dart';
import 'package:mocktail/mocktail.dart';

class _MockPostDataSource extends Mock implements PostDataSource {}

void main() {
  group('PostRepositoryImpl', () {
    late PostRepositoryImpl postRepository;
    late _MockPostDataSource mockPostDataSource;

    setUp(() {
      mockPostDataSource = _MockPostDataSource();
      postRepository = PostRepositoryImpl(postDataSource: mockPostDataSource);
    });

    test('getPosts deve chamar o método correspondente no data source', () async {
      final mockPosts = [ Post(id: 1, userId: 1, title: 'Test', body: 'Body')];
      when(() => mockPostDataSource.getPosts(start: 0, limit: 10))
          .thenAnswer((_) async => mockPosts);
      await postRepository.getPosts(start: 0, limit: 10);
      verify(() => mockPostDataSource.getPosts(start: 0, limit: 10)).called(1);
    });

    test('getPostDetails deve chamar o método correspondente no data source', () async {
      var mockPost = Post(id: 1, userId: 1, title: 'Test', body: 'Body');
      when(() => mockPostDataSource.getPostDetails(postId: 1))
          .thenAnswer((_) async => mockPost);
      await postRepository.getPostDetails(postId: 1);
      verify(() => mockPostDataSource.getPostDetails(postId: 1)).called(1);
    });
  });
}
