import 'package:filmpal/pages/co_stars.dart';
import 'package:filmpal/pages/recommended.dart';
import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';
import 'main_page.dart'; // Import the MainPage widget

// HomePage widget definition
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// State class for managing HomePage state
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBodyWidget(_selectedIndex),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

// Method to return the appropriate body widget based on the selected tab index
  Widget _getBodyWidget(int index) {
    switch (index) {
      case 0:
        return RecommendedPage();
      case 1:
        return MainPage();
      case 2:
        return ActorSearchPage();
      default:
        return Container();
    }
  }
}
