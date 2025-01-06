import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AltAuthButton extends StatelessWidget {
  final String imgUrl;
  final VoidCallback onPressed;
  const AltAuthButton(
      {super.key, required this.imgUrl, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          minimumSize: Size(
            MediaQuery.of(context).size.width / 4,
            MediaQuery.of(context).size.width / 8,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          shadowColor: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: onPressed,
        child: SvgPicture.asset(
          imgUrl,
          width: MediaQuery.of(context).size.width / 16,
          height: MediaQuery.of(context).size.width / 16,
        ),
      ),
    );
  }
}
