import 'package:magnum_bank/domain/entities/post.dart';

abstract class IPostRepository {
  Future<List<Post>> getPosts();
  Future<Post> getPostDetails({required int postId});}