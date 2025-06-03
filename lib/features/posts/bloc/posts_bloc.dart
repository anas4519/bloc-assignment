import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/post_model.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  static const String storageKey = 'local_posts';

  PostsBloc() : super(PostsInitial()) {
    on<LoadLocalPosts>(_onLoadLocalPosts);
    on<AddLocalPost>(_onAddLocalPost);
  }

  FutureOr<void> _onLoadLocalPosts(
      LoadLocalPosts event, Emitter<PostsState> emit) async {
    emit(PostsLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedList = prefs.getStringList(storageKey) ?? [];

      final posts = storedList
          .map((json) => LocalPost.fromJson(jsonDecode(json)))
          .toList();

      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError('Failed to load posts.'));
    }
  }

  FutureOr<void> _onAddLocalPost(
      AddLocalPost event, Emitter<PostsState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedList = prefs.getStringList(storageKey) ?? [];

      final newPostJson = jsonEncode(event.post.toJson());
      final updatedList = List<String>.from(storedList)..add(newPostJson);

      await prefs.setStringList(storageKey, updatedList);

      final updatedPosts = updatedList
          .map((json) => LocalPost.fromJson(jsonDecode(json)))
          .toList();

      emit(PostsLoaded(updatedPosts));
    } catch (e) {
      emit(PostsError('Failed to add post.'));
    }
  }
}
