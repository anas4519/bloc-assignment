import 'package:bloc_assignment/features/user%20details/ui/posts_lists.dart';
import 'package:bloc_assignment/features/user%20details/ui/todos_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_assignment/features/users/models/users_data_ui_model.dart';
import '../bloc/user_details_bloc.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key, required this.user});
  final User user;

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late final UserDetailsBloc _userDetailsBloc;

  @override
  void initState() {
    super.initState();
    _userDetailsBloc = UserDetailsBloc();
    _userDetailsBloc.add(FetchUserDetails(userId: widget.user.id));
  }

  @override
  void dispose() {
    _userDetailsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.user.firstName} ${widget.user.lastName}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocBuilder<UserDetailsBloc, UserDetailsState>(
        bloc: _userDetailsBloc,
        builder: (context, state) {
          return switch (state) {
            UserDetailsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            UserDetailsError() => Center(
                child: Text(state.message),
              ),
            UserDetailsLoaded() => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserInfo(),
                      const SizedBox(height: 24),
                      PostsLists(posts: state.posts),
                      const SizedBox(height: 24),
                      TodosList(todos: state.todos)
                    ],
                  ),
                ),
              ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'User Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.user.image),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                    'Name', '${widget.user.firstName} ${widget.user.lastName}'),
                _buildInfoRow('Username', widget.user.username),
                _buildInfoRow('Email', widget.user.email),
                _buildInfoRow('Phone', widget.user.phone),
                _buildInfoRow('Birth Date', widget.user.birthDate),
                _buildInfoRow('Age', widget.user.age.toString()),
                _buildInfoRow('Gender', widget.user.gender),
                _buildInfoRow('Blood Group', widget.user.bloodGroup),
                _buildInfoRow('Height', '${widget.user.height} cm'),
                _buildInfoRow('Weight', '${widget.user.weight} kg'),
                _buildInfoRow('Eye Color', widget.user.eyeColor),
                _buildInfoRow('Hair',
                    '${widget.user.hair.color} ${widget.user.hair.type}'),
                const Divider(),
                _buildInfoRow('University', widget.user.university),
                const Divider(),
                const Text(
                  'Address',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildInfoRow('Street', widget.user.address.address),
                _buildInfoRow('City', widget.user.address.city),
                _buildInfoRow('State',
                    '${widget.user.address.state} (${widget.user.address.stateCode})'),
                _buildInfoRow('Country', widget.user.address.country),
                _buildInfoRow('Postal Code', widget.user.address.postalCode),
                const Divider(),
                const Text(
                  'Company',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildInfoRow('Name', widget.user.company.name),
                _buildInfoRow('Department', widget.user.company.department),
                _buildInfoRow('Title', widget.user.company.title),
                const Divider(),
                const Text(
                  'Bank Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildInfoRow('Card Type', widget.user.bank.cardType),
                _buildInfoRow('Currency', widget.user.bank.currency),
                const Divider(),
                const Text(
                  'Crypto',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildInfoRow('Coin', widget.user.crypto.coin),
                _buildInfoRow('Network', widget.user.crypto.network),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
