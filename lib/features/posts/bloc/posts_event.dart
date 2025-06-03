part of 'posts_bloc.dart';

@immutable
sealed class PostsEvent {}

final class LoadLocalPosts extends PostsEvent {}

final class AddLocalPost extends PostsEvent {
  final LocalPost post;

  AddLocalPost(this.post);
}
