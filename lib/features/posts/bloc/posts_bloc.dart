import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../models/post_model.dart';
import '../repos/posts_repo.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostsRepository repository;

  PostsBloc({required this.repository}) : super(PostsInitial()) {
    on<LoadLocalPosts>(_onLoadLocalPosts);
    on<AddLocalPost>(_onAddLocalPost);
  }

  Future<void> _onLoadLocalPosts(
      LoadLocalPosts event, Emitter<PostsState> emit) async {
    emit(PostsLoading());
    try {
      final posts = await repository.getLocalPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError('Failed to load posts.'));
    }
  }

  Future<void> _onAddLocalPost(
      AddLocalPost event, Emitter<PostsState> emit) async {
    try {
      final updatedPosts = await repository.addLocalPost(event.post);
      emit(PostsLoaded(updatedPosts));
    } catch (e) {
      emit(PostsError('Failed to add post.'));
    }
  }
}
