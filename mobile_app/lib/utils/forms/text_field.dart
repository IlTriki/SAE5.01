import 'package:flutter/material.dart';

class CustomAuthTextField extends StatefulWidget {
  final IconData? icon;
  final TextEditingController controller;
  final String hintText;
  final IconData? onPressedIcon;
  final Function()? onPressedIconFunction;
  final bool obscureText;

  const CustomAuthTextField({
    super.key,
    this.icon,
    required this.controller,
    required this.hintText,
    this.onPressedIcon,
    this.obscureText = false,
    this.onPressedIconFunction,
  });

  @override
  _CustomAuthTextFieldState createState() => _CustomAuthTextFieldState();
}

class _CustomAuthTextFieldState extends State<CustomAuthTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: Theme.of(context).colorScheme.tertiary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: widget.icon == null
            ? null
            : IconButton(
                icon: Icon(
                  widget.onPressedIcon == null
                      ? widget.icon
                      : widget.obscureText
                          ? widget.icon
                          : widget.onPressedIcon,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: widget.onPressedIconFunction,
              ),
      ),
    );
  }
}
