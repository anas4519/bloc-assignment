import 'package:bloc_assignment/features/users/ui/users_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bloc Assignment',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const UsersPage());
  }
}
