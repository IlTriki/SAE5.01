import 'package:flutter/material.dart';

class SharedPage extends StatelessWidget {
  const SharedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Shared Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
