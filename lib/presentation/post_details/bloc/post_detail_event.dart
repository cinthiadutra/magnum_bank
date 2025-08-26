import 'package:equatable/equatable.dart';

abstract class PostDetailEvent extends Equatable {
  const PostDetailEvent();
  @override
  List<Object> get props => [];
}

class FetchPostDetail extends PostDetailEvent {
  final int postId;
  const FetchPostDetail({required this.postId});
  @override
  List<Object> get props => [postId];
}