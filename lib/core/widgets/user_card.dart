import 'package:flutter/material.dart';
import '../../core/entities/user.dart';

/// Widget pour afficher une carte utilisateur
class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final Widget? trailing;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user.avatarUrl != null
              ? NetworkImage(user.avatarUrl!)
              : null,
          child: user.avatarUrl == null
              ? Text(
                  user.name[0].toUpperCase(),
                  style: const TextStyle(fontSize: 20),
                )
              : null,
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
