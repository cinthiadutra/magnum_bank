import 'package:flutter_test/flutter_test.dart';
import 'package:magnum_bank/data/datasources/post_datasource.dart';
import 'package:magnum_bank/domain/entities/post.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  group('PostDataSource', () {
    late PostDataSource postDataSource;
    late _MockDio mockDio;

    setUp(() {
      mockDio = _MockDio();
      postDataSource = PostDataSource(dio: mockDio);
    });

    test('getPosts deve retornar uma lista de Posts em caso de sucesso', () async {
      final responseData = [
        {'id': 1, 'userId': 1, 'title': 'Post 1', 'body': 'Body 1'},
        {'id': 2, 'userId': 1, 'title': 'Post 2', 'body': 'Body 2'},
      ];
      final response = Response(
        data: responseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      );

      when(() => mockDio.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
      )).thenAnswer((_) async => response);

      final posts = await postDataSource.getPosts(start: 0, limit: 10);
      expect(posts.length, 2);
      expect(posts[0], isA<Post>());
    });

    test('getPosts deve lançar uma exceção em caso de falha', () async {
      when(() => mockDio.get(
        any(),
        queryParameters: any(named: 'queryParameters'),
      )).thenThrow(DioException(
        response: Response(statusCode: 404, requestOptions: RequestOptions(path: '')),
        requestOptions: RequestOptions(path: ''),
      ));

      expect(() => postDataSource.getPosts(start: 0, limit: 10), throwsException);
    });
  });
}