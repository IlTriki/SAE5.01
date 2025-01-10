import 'package:flutter/material.dart';

Widget placeholder(
    BuildContext context, VoidCallback onTap, String text, IconData icon) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: const Color(0xfffff7fa))),
        IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    ),
  );
}
