import 'package:magnum_bank/data/datasources/post_datasource.dart';
import 'package:magnum_bank/data/repositories/post_repository.dart';
import 'package:magnum_bank/domain/entities/post.dart';

class PostRepositoryImpl implements IPostRepository {
  final PostDataSource _postDataSource;

  PostRepositoryImpl({required PostDataSource postDataSource})
      : _postDataSource = postDataSource;

  @override
  Future<List<Post>> getPosts() {
    return _postDataSource.getPosts();
  }
   @override
  Future<Post> getPostDetails({required int postId}) {
    return _postDataSource.getPostDetails(postId: postId);
  }
}