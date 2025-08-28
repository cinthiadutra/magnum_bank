import 'package:dio/dio.dart';
import 'package:magnum_bank/domain/entities/post.dart';

class PostDataSource {
  final Dio _dio;
  final String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  PostDataSource({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://jsonplaceholder.typicode.com/',
              headers: {
                'Accept': 'application/json',
                'User-Agent':
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
                    '(KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36',
              },
            ),
          );
  Future<List<Post>> getPosts() async {
    try {
      final response = await _dio.get(_baseUrl);
      if (response.statusCode == 200) {
        final List<dynamic> postsJson = response.data;
        return postsJson.map((json) => Post.fromMap(json)).toList();
      } else {
        throw Exception('Falha ao carregar os posts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Erro de resposta da API: ${e.response?.statusMessage}',
        );
      } else {
        throw Exception('Erro de conexão: ${e.message}');
      }
    }
  }

  Future<Post> getPostDetails({required int postId}) async {
    try {
      final response = await _dio.get('$_baseUrl/$postId');
      if (response.statusCode == 200) {
        return Post.fromMap(response.data);
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
