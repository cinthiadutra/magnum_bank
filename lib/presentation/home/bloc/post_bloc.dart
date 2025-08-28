import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:magnum_bank/data/repositories/post_repository.dart';
import 'package:magnum_bank/domain/entities/post.dart';
import 'package:magnum_bank/presentation/home/bloc/post_events.dart';
import 'package:magnum_bank/presentation/home/bloc/post_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final IPostRepository _postRepository;

  List<Post> _allPosts = []; 
  List<Post> _visiblePosts = []; 
  final int _pageSize = 10; 
  int _currentIndex = 0;

  PostsBloc({required IPostRepository postRepository})
      : _postRepository = postRepository,
        super(PostsInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<FetchMorePosts>(_onFetchMorePosts);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<PostsState> emit) async {
  emit(PostsLoading());
  try {
    
    final posts = await _postRepository.getPosts() ?? [];

    _allPosts = posts;
    _currentIndex = 0;
    _visiblePosts = _allPosts.take(_pageSize).toList();
    _currentIndex = _visiblePosts.length;

    emit(PostsSuccess(
      posts: _visiblePosts,
      hasMore: _currentIndex < _allPosts.length,
    ));
  } catch (e) {
    emit(PostsFailure(error: e.toString()));
  }
}

  Future<void> _onFetchMorePosts(FetchMorePosts event, Emitter<PostsState> emit) async {
    if (state is! PostsSuccess) return;
    final currentState = state as PostsSuccess;

    if (_currentIndex >= _allPosts.length) return;

    
    final nextIndex = (_currentIndex + _pageSize).clamp(0, _allPosts.length);
    final nextPosts = _allPosts.sublist(_currentIndex, nextIndex);

    _visiblePosts.addAll(nextPosts);
    _currentIndex = nextIndex;

    emit(PostsSuccess(
        posts: _visiblePosts,
        hasMore: _currentIndex < _allPosts.length));
  }
}
