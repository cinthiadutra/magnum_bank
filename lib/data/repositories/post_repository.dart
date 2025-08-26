import 'package:magnum_bank/domain/entities/post.dart';

abstract class IPostRepository {
  Future<List<Post>> getPosts({required int start, required int limit});
  Future<Post> getPostDetails({required int postId});}