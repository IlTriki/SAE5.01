import 'package:ckoitgrol/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    String _email = AuthService().currentUser!.email!;
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome $_email',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
