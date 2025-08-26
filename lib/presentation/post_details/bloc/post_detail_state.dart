import 'package:equatable/equatable.dart';
import 'package:magnum_bank/domain/entities/post.dart';

abstract class PostDetailState extends Equatable {
  const PostDetailState();
  @override
  List<Object> get props => [];
}

class PostDetailInitial extends PostDetailState {}

class PostDetailLoading extends PostDetailState {}

class PostDetailSuccess extends PostDetailState {
  final Post post;
  const PostDetailSuccess({required this.post});
  @override
  List<Object> get props => [post];
}

class PostDetailFailure extends PostDetailState {
  final String error;
  const PostDetailFailure({required this.error});
  @override
  List<Object> get props => [error];
}