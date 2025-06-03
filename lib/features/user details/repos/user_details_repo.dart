import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../models/todo_model.dart';

class UserDetailsRepository {
  Future<(List<Post>, List<Todo>)> getUserDetails(int userId) async {
    final postsResponse = await http.get(
      Uri.parse('https://dummyjson.com/posts/user/$userId'),
    );
    final todosResponse = await http.get(
      Uri.parse('https://dummyjson.com/todos/user/$userId'),
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

      return (posts, todos);
    } else {
      throw Exception('Failed to fetch user details');
    }
  }
}