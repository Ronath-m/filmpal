import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GNav(
      tabs: const [
        GButton(icon: Icons.home, text: 'Home'),
        GButton(icon: Icons.search, text: 'Search'),
        GButton(icon: Icons.group_add, text: 'Actors'),
      ],
      selectedIndex: selectedIndex,
      onTabChange: onTabChange,
    );
  }
}
