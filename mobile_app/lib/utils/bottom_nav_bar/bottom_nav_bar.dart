import 'package:flutter/material.dart';
import 'package:ckoitgrol/utils/icon_button/icon_button.dart';

class BottomNavBar extends StatefulWidget {
  final PageController pageController;
  final int selectedIndex;

  const BottomNavBar({
    super.key,
    required this.pageController,
    required this.selectedIndex,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    List<IconData> icons = [
      Icons.home_outlined,
      Icons.favorite_border,
      Icons.share,
      Icons.person_outline,
    ];
    return BottomAppBar(
      notchMargin: 8.0,
      elevation: 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            for (int i = 0; i < icons.length; i++)
              CustomIconButton(
                icon: icons[i],
                onPressed: () {
                  widget.pageController.jumpToPage(i);
                },
                active: widget.selectedIndex == i,
              ),
          ],
        ),
      ),
    );
  }
}
