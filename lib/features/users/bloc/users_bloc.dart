import 'dart:async';
import 'package:bloc_assignment/features/users/models/users_data_ui_model.dart';
import 'package:bloc_assignment/features/users/repos/users_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  List<User> allUsers = [];
  int currentSkip = 0;
  static const int limit = 10;
  int total = 0;

  UsersBloc() : super(UsersInitial()) {
    on<UsersInitialFetch>(usersInitialFetch);
    on<UsersLoadMore>(usersLoadMore);
    on<UsersSearchEvent>(usersSearchEvent);
    on<UsersClearSearchEvent>(usersClearSearchEvent);
  }

  FutureOr<void> usersInitialFetch(
      UsersInitialFetch event, Emitter<UsersState> emit) async {
    emit(UsersFetchingLoadingState());
    try {
      final result = await UsersRepo.fetchUsers(skip: 0, limit: limit);
      allUsers = result.users;
      total = result.total;
      currentSkip = limit;
      emit(UsersFetchingSuccessfulState(
        users: result.users,
        hasReachedMax: result.users.length >= total,
      ));
    } catch (e) {
      emit(UsersFetchingErrorState());
    }
  }

  FutureOr<void> usersLoadMore(
      UsersLoadMore event, Emitter<UsersState> emit) async {
    final currentState = state;
    if (currentState is UsersFetchingSuccessfulState) {
      if (currentState.hasReachedMax) return;

      emit(UsersFetchingSuccessfulState(
        users: currentState.users,
        isLoadingMore: true,
        hasReachedMax: currentState.hasReachedMax,
      ));

      try {
        final result = await UsersRepo.fetchUsers(
          skip: currentSkip,
          limit: limit,
        );
        currentSkip += limit;
        final updatedUsers = List<User>.from(currentState.users)
          ..addAll(result.users);
        emit(UsersFetchingSuccessfulState(
          users: updatedUsers,
          hasReachedMax: updatedUsers.length >= total,
        ));
      } catch (e) {
        emit(UsersFetchingSuccessfulState(
          users: currentState.users,
          hasReachedMax: currentState.hasReachedMax,
        ));
      }
    }
  }

  FutureOr<void> usersSearchEvent(
      UsersSearchEvent event, Emitter<UsersState> emit) async {
    emit(UsersFetchingLoadingState());
    try {
      final result = await UsersRepo.searchUsers(event.searchQuery);
      emit(UsersSearchState(filteredUsers: result.users));
    } catch (e) {
      emit(UsersFetchingErrorState());
    }
  }

  FutureOr<void> usersClearSearchEvent(
      UsersClearSearchEvent event, Emitter<UsersState> emit) async {
    emit(UsersFetchingSuccessfulState(users: allUsers));
  }
}
