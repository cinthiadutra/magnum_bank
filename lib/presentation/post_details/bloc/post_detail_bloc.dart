import 'package:bloc/bloc.dart';
import 'package:magnum_bank/data/repositories/post_repository.dart';
import 'package:magnum_bank/presentation/post_details/bloc/post_detail_event.dart';
import 'package:magnum_bank/presentation/post_details/bloc/post_detail_state.dart';


class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  final IPostRepository _postRepository;
  PostDetailBloc({required IPostRepository postRepository})
      : _postRepository = postRepository,
        super(PostDetailInitial()) {
    on<FetchPostDetail>(_onFetchPostDetail);
  }

  Future<void> _onFetchPostDetail(
      FetchPostDetail event, Emitter<PostDetailState> emit) async {
    emit(PostDetailLoading());
    try {
      final post = await _postRepository.getPostDetails(postId: event.postId);
      emit(PostDetailSuccess(post: post));
    } catch (e) {
      emit(PostDetailFailure(error: e.toString()));
    }
  }
}
