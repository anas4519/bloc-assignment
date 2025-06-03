part of 'user_details_bloc.dart';

@immutable
sealed class UserDetailsEvent {}

class FetchUserDetails extends UserDetailsEvent {
  final int userId;

  FetchUserDetails({required this.userId});
}
