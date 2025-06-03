import 'package:bloc_assignment/features/posts/bloc/posts_bloc.dart';
import 'package:bloc_assignment/features/posts/ui/create_post_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostsBloc>().add(LoadLocalPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Local Posts")),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          return switch (state) {
            PostsInitial() => const Center(
                child: Text("Initialize posts..."),
              ),
            PostsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            PostsLoaded() => state.posts.isEmpty
                ? const Center(child: Text("No posts yet."))
                : ListView.builder(
                    itemCount: state.posts.length,
                    itemBuilder: (context, index) {
                      final post = state.posts[index];
                      return ListTile(
                        title: Text(post.title),
                        subtitle: Text(post.body),
                      );
                    },
                  ),
            PostsError() => Center(
                child: Text(state.message),
              ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePostPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
