import 'package:flutter/material.dart';

class FriendPlaceholder extends StatelessWidget {
  const FriendPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.person, color: Colors.grey),
      ),
      title: Container(
        width: 100,
        height: 10,
        color: Colors.grey.shade300,
      ),
      subtitle: Container(
        width: 150,
        height: 10,
        color: Colors.grey.shade300,
      ),
    );
  }
}
