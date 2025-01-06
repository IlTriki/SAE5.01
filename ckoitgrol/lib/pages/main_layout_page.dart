import 'package:auto_route/auto_route.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';

import '../route/router.dart';
import '../utils/bottom_nav_bar/bottom_nav_bar.dart';

@RoutePage()
class MainLayoutPage extends StatefulWidget {
  const MainLayoutPage({super.key});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      routes: const [
        HomeRoute(),
        FriendsChatRoute(),
        FriendsRouter(),
        ProfileRouter(),
      ],
      builder: (context, child, _) {
        final tabsRouter = AutoTabsRouter.of(context);
        return ColorfulSafeArea(
          color: Theme.of(context).colorScheme.surface,
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            resizeToAvoidBottomInset: false,
            body: child,
            bottomNavigationBar: BottomNavBar(tabsRouter: tabsRouter),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.router.push(const CreatePostRoute());
              },
              shape: const CircleBorder(),
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.add_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          ),
        );
      },
    );
  }
}
