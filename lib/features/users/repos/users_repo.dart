import 'dart:async';
import 'dart:convert';

import 'package:bloc_assignment/features/users/models/users_data_ui_model.dart';
import 'package:http/http.dart' as http;

class UsersRepo {
  static Future<UsersDataUiModel> fetchUsers({int skip = 0, int limit = 10}) async {
    try {
      var client = http.Client();
      var response = await client.get(
        Uri.parse('https://dummyjson.com/users?limit=$limit&skip=$skip')
      );

      Map<String, dynamic> responseBody = jsonDecode(response.body);
      return UsersDataUiModel.fromJson(responseBody);
    } catch (e) {
      print(e.toString());
      return UsersDataUiModel(users: [], total: 0, skip: skip, limit: limit);
    }
  }
}
