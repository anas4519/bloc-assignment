part of 'users_bloc.dart';

@immutable
sealed class UsersState {}

sealed class UsersActionState {}

final class UsersInitial extends UsersState {}

class UsersFetchingLoadingState extends UsersState {}

class UsersFetchingErrorState extends UsersState {}

class UsersFetchingSuccessfulState extends UsersState {
  final List<User> users;
  final bool hasReachedMax;
  final bool isLoadingMore;

  UsersFetchingSuccessfulState({
    required this.users,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });
}

class UsersSearchState extends UsersState {
  final List<User> filteredUsers;

  UsersSearchState({required this.filteredUsers});
}
