// lib/widgets/user_card.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../screens/user_detail/user_detail_screen.dart';

class UserCard extends StatelessWidget {
  final User user;
  const UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
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
        );      },
    );
  }
}
