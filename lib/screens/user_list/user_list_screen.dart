import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user/user_event.dart';
import '../../../blocs/user/user_state.dart';
import '../../../models/user_model.dart';
import '../../../widgets/loading_indicator.dart';
import '../user_detail/user_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool isFetchingMore = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<UserBloc>();
    bloc.add(FetchUsers(limit: 20, skip: 0));

    _scrollController.addListener(_onScroll);

    _searchController.addListener(_onSearchChanged);
  }

  void _onScroll() {
    final bloc = context.read<UserBloc>();
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
        !isFetchingMore &&
        bloc.state is UserLoaded &&
        !(bloc.state as UserLoaded).hasReachedEnd) {
      isFetchingMore = true;
      bloc.add(FetchUsers(
        limit: 20,
        skip: (bloc.state as UserLoaded).users.length,
        query: (bloc.state as UserLoaded).query,
      ));
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      final query = _searchController.text.trim();
      context.read<UserBloc>().add(SearchUsers(query));
      _scrollController.jumpTo(0); // Reset scroll on new search
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search users...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserLoaded) {
                  isFetchingMore = false;
                }
              },
              builder: (context, state) {
                if (state is UserLoading) {
                  return const LoadingIndicator();
                } else if (state is UserError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else if (state is UserLoaded) {
                  if (state.users.isEmpty) {
                    return const Center(child: Text('No users found.'));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.users.length + (state.hasReachedEnd ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index >= state.users.length) {
                        // Bottom loading indicator while fetching more
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final user = state.users[index];
                      return ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(user.image)),
                        title: Text('${user.firstName} ${user.lastName}'),
                        subtitle: Text(user.email),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UserDetailScreen(user: user),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
