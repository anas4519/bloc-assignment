import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../models/todo_model.dart';

part 'user_details_event.dart';
part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  UserDetailsBloc() : super(UserDetailsInitial()) {
    on<FetchUserDetails>(_handleFetchUserDetails);
  }

  Future<void> _handleFetchUserDetails(
    FetchUserDetails event,
    Emitter<UserDetailsState> emit,
  ) async {
    emit(UserDetailsLoading());

    try {
      final postsResponse = await http.get(
        Uri.parse('https://dummyjson.com/posts/user/${event.userId}'),
      );
      final todosResponse = await http.get(
        Uri.parse('https://dummyjson.com/todos/user/${event.userId}'),
      );

      if (postsResponse.statusCode == 200 && todosResponse.statusCode == 200) {
        final postsJson = json.decode(postsResponse.body);
        final todosJson = json.decode(todosResponse.body);

        final posts = (postsJson['posts'] as List)
            .map((post) => Post.fromJson(post))
            .toList();
        final todos = (todosJson['todos'] as List)
            .map((todo) => Todo.fromJson(todo))
            .toList();

        emit(UserDetailsLoaded(posts: posts, todos: todos));
      } else {
        emit(UserDetailsError(message: 'Failed to fetch user details'));
      }
    } catch (e) {
      emit(UserDetailsError(message: e.toString()));
    }
  }
}
