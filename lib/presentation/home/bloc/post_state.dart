import 'package:equatable/equatable.dart';
import 'package:magnum_bank/domain/entities/post.dart';

abstract class PostsState extends Equatable {
  const PostsState();
  @override
  List<Object> get props => [];
}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsSuccess extends PostsState {
  final List<Post> posts;
  final bool hasMore;
  const PostsSuccess({required this.posts, required this.hasMore});
  @override
  List<Object> get props => [posts, hasMore];
}
class PostsFailure extends PostsState {
  final String error;
  const PostsFailure({required this.error});
  @override
  List<Object> get props => [error];
}