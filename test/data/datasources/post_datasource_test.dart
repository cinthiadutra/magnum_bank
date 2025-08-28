import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:magnum_bank/data/datasources/post_datasource.dart';
import 'package:magnum_bank/domain/entities/post.dart';

// Mock do Dio
class MockDio extends Mock implements Dio {}

void main() {
  late PostDataSource postDataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    postDataSource = PostDataSource(dio: mockDio);
  });

  test('getPosts deve lançar uma exceção em caso de falha', () async {
    // Simula erro do Dio
    when(() => mockDio.get(any())).thenThrow(
      DioException(requestOptions: RequestOptions(path: '')),
    );

    // Verifica se getPosts lança Exception
    expect(
      () async => await postDataSource.getPosts(),
      throwsA(isA<Exception>()),
    );
  });

  test('getPosts deve retornar lista de posts em caso de sucesso', () async {
    // Simula resposta bem-sucedida do Dio
    final mockResponse = Response(
      requestOptions: RequestOptions(path: ''),
      data: [
        {
          "userId": 1,
          "id": 1,
          "title": "Teste",
          "body": "Corpo do post"
        },
      ],
      statusCode: 200,
    );

    when(() => mockDio.get(any())).thenAnswer((_) async => mockResponse);

    final result = await postDataSource.getPosts();

    expect(result, isA<List<Post>>());
    expect(result.length, 1);
    expect(result.first.title, 'Teste');
  });
}
