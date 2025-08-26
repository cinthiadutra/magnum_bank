import 'package:dio/dio.dart';
import 'package:magnum_bank/domain/entities/post.dart';

class PostDataSource {
  final Dio _dio;
  final String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  PostDataSource({required Dio dio}) : _dio = dio;

  Future<List<Post>> getPosts({required int start, required int limit}) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          '_start': start,
          '_limit': limit,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> postsJson = response.data;
        return postsJson.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar os posts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Erro de resposta da API: ${e.response?.statusCode}');
      } else {
        throw Exception('Erro de conexão: ${e.message}');
      }
    }
  }
   Future<Post> getPostDetails({required int postId}) async {
    try {
      final response = await _dio.get('$_baseUrl/$postId');
      if (response.statusCode == 200) {
        return Post.fromJson(response.data);
      } else {
        throw Exception('Falha ao carregar o post: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Erro de resposta da API: ${e.response?.statusCode}');
      } else {
        throw Exception('Erro de conexão: ${e.message}');
      }
    }
  }
}