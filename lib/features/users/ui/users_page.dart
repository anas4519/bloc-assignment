import 'package:bloc_assignment/features/users/bloc/users_bloc.dart';
import 'package:bloc_assignment/features/users/models/users_data_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final UsersBloc usersBloc = UsersBloc();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    usersBloc.add(UsersInitialFetch());
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    usersBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          usersBloc.add(UsersClearSearchEvent());
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {});
                usersBloc.add(UsersSearchEvent(searchQuery: value));
              },
            ),
          ),
          Expanded(
            child: BlocConsumer<UsersBloc, UsersState>(
              bloc: usersBloc,
              listenWhen: (previous, current) => current is UsersActionState,
              buildWhen: (previous, current) => current is! UsersActionState,
              listener: (context, state) {
                // Handle action states if needed
              },
              builder: (context, state) {
                switch (state.runtimeType) {
                  case UsersFetchingLoadingState:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case UsersFetchingErrorState:
                    return const Center(
                      child: Text('Failed to load users'),
                    );
                  case UsersFetchingSuccessfulState:
                    final successState = state as UsersFetchingSuccessfulState;
                    return _buildUsersList(successState.users, state);
                  case UsersSearchState:
                    final searchState = state as UsersSearchState;
                    return _buildUsersList(searchState.filteredUsers, state);
                  default:
                    return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(List<User> users, UsersState state) {
    if (users.isEmpty) {
      return const Center(
        child: Text('No users found'),
      );
    }

    return ListView.builder(
      itemCount: users.length + 1,
      itemBuilder: (context, index) {
        if (index == users.length) {
          if (state is UsersFetchingSuccessfulState) {
            final successState = state;
            if (successState.hasReachedMax) {
              return const SizedBox();
            }
            if (successState.isLoadingMore) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            usersBloc.add(UsersLoadMore());
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const SizedBox();
        }

        final user = users[index];
        String fullName = '${user.firstName} ${user.lastName}';
        return ListTile(
          title: Text(fullName),
          subtitle: Text(user.email),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.image),
            onBackgroundImageError: (exception, stackTrace) {
              // Handle image loading error
            },
          ),
        );
      },
    );
  }
}
