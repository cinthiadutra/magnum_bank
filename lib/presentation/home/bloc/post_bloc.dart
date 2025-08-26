import 'package:bloc/bloc.dart';
import 'package:magnum_bank/data/repositories/post_repository.dart';
import 'package:magnum_bank/domain/entities/post.dart';
import 'package:magnum_bank/presentation/home/bloc/post_events.dart';
import 'package:magnum_bank/presentation/home/bloc/post_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final IPostRepository _postRepository;
  List<Post> _posts = [];
  int _page = 0;
  final int _limit = 10;
  bool _isLoadingMore = false;

  PostsBloc({required IPostRepository postRepository})
      : _postRepository = postRepository,
        super(PostsInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<FetchMorePosts>(_onFetchMorePosts);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostsState> emit) async {
    emit(PostsLoading());
    try {
      _posts = await _postRepository.getPosts(start: 0, limit: _limit);
      _page = 1;
      emit(PostsSuccess(posts: _posts, hasMore: _posts.length == _limit));
    } catch (e) {
      emit(PostsFailure(error: e.toString()));
    }
  }

  Future<void> _onFetchMorePosts(
      FetchMorePosts event, Emitter<PostsState> emit) async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    try {
      final newPosts =
          await _postRepository.getPosts(start: _page * _limit, limit: _limit);
      _posts.addAll(newPosts);
      _page++;
      emit(PostsSuccess(posts: _posts, hasMore: newPosts.length == _limit));
    } catch (e) {
      emit(PostsFailure(error: e.toString()));
    } finally {
      _isLoadingMore = false;
    }
  }
}
