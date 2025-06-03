import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../models/post_model.dart';
import '../models/todo_model.dart';
import '../repos/user_details_repo.dart';

part 'user_details_event.dart';
part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final UserDetailsRepository repository;

  UserDetailsBloc({required this.repository}) : super(UserDetailsInitial()) {
    on<FetchUserDetails>(_handleFetchUserDetails);
  }

  Future<void> _handleFetchUserDetails(
    FetchUserDetails event,
    Emitter<UserDetailsState> emit,
  ) async {
    emit(UserDetailsLoading());

    try {
      final (posts, todos) = await repository.getUserDetails(event.userId);
      emit(UserDetailsLoaded(posts: posts, todos: todos));
    } catch (e) {
      emit(UserDetailsError(message: e.toString()));
    }
  }
}
