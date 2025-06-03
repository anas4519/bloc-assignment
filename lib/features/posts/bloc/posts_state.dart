part of 'posts_bloc.dart';

@immutable
sealed class PostsState {}

final class PostsInitial extends PostsState {}

final class PostsLoading extends PostsState {}

final class PostsLoaded extends PostsState {
  final List<LocalPost> posts;

  PostsLoaded(this.posts);
}

final class PostsError extends PostsState {
  final String message;

  PostsError(this.message);
}
