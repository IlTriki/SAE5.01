import 'package:flutter/material.dart';

class TextArrowButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const TextArrowButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  _TextArrowButtonState createState() => _TextArrowButtonState();
}

class _TextArrowButtonState extends State<TextArrowButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.text,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: 51,
            height: 51,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_forward,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
