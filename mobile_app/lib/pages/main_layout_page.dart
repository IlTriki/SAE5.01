import 'package:flutter/material.dart';
import 'package:ckoitgrol/pages/favorites/favorites_page.dart';
import 'package:ckoitgrol/pages/shared/shared_page.dart';
import 'package:ckoitgrol/pages/home/home_page.dart';
import 'package:ckoitgrol/pages/profile/profile_page.dart';
import 'package:ckoitgrol/utils/bottom_nav_bar/bottom_nav_bar.dart';

class MainLayoutPage extends StatefulWidget {
  const MainLayoutPage({super.key});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: const <Widget>[
              HomePage(),
              FavoritesPage(),
              SharedPage(),
              ProfilePage(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: Theme.of(context).primaryColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(
        pageController: _pageController,
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
