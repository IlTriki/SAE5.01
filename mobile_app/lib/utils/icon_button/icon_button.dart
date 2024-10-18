import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool active;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.active = false,
  });

  @override
  _CustomIconButtonState createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(widget.icon),
      iconSize: 30,
      color: widget.active
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).iconTheme.color,
      highlightColor: Colors.transparent,
      onPressed: () {
        widget.onPressed();
      },
    );
  }
}
