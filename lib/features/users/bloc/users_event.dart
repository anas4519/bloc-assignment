part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

class UsersInitialFetch extends UsersEvent {}

class UsersLoadMore extends UsersEvent {}

class UsersSearchEvent extends UsersEvent {
  final String searchQuery;

  UsersSearchEvent({required this.searchQuery});
}

class UsersClearSearchEvent extends UsersEvent {}
