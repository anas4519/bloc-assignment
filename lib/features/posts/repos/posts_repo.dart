import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';

class PostsRepository {
  static const String storageKey = 'local_posts';

  Future<List<LocalPost>> getLocalPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final storedList = prefs.getStringList(storageKey) ?? [];

    return storedList
        .map((json) => LocalPost.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<List<LocalPost>> addLocalPost(LocalPost post) async {
    final prefs = await SharedPreferences.getInstance();
    final storedList = prefs.getStringList(storageKey) ?? [];

    final newPostJson = jsonEncode(post.toJson());
    final updatedList = List<String>.from(storedList)..add(newPostJson);

    await prefs.setStringList(storageKey, updatedList);

    return updatedList
        .map((json) => LocalPost.fromJson(jsonDecode(json)))
        .toList();
  }
}