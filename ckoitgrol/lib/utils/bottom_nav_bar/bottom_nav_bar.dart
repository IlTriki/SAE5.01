import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomNavBar extends StatelessWidget {
  final TabsRouter tabsRouter;

  const BottomNavBar({super.key, required this.tabsRouter});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent, // Disable the ripple splash
        highlightColor: Colors.transparent, // Disable the highlight effect
      ),
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            label: Translate.of(context).homeTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.chat_rounded),
            label: Translate.of(context).chatTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.groups_rounded),
            label: Translate.of(context).friendsTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_rounded),
            label: Translate.of(context).profileTitle,
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: tabsRouter.activeIndex,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        showUnselectedLabels: true,
        onTap: (index) => _handleTap(context, index),
      ),
    );
  }

  void _handleTap(BuildContext context, int index) {
    if (index == tabsRouter.activeIndex) {
      tabsRouter.stackRouterOfIndex(index)?.popUntilRoot();
      context.router.popUntilRoot();
    } else {
      tabsRouter.setActiveIndex(index);
    }
  }
}
