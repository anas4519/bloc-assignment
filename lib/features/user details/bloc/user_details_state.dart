part of 'user_details_bloc.dart';

@immutable
sealed class UserDetailsState {}

final class UserDetailsInitial extends UserDetailsState {}

final class UserDetailsLoading extends UserDetailsState {}

final class UserDetailsError extends UserDetailsState {
  final String message;

  UserDetailsError({required this.message});
}

final class UserDetailsLoaded extends UserDetailsState {
  final List<Post> posts;
  final List<Todo> todos;

  UserDetailsLoaded({
    required this.posts,
    required this.todos,
  });
}
