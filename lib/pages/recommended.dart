import 'package:filmpal/widgets/movie_corousel.dart';
import 'package:filmpal/widgets/tv_show_corousel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/main_page_data_controller.dart';
import '../models/main_page_data.dart';
import 'user_profile.dart';

final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>((ref) {
  return MainPageDataController();
});

class RecommendedPage extends ConsumerWidget {
  double? _deviceHeight;
  double? _deviceWidth;

  late MainPageDataController _mainPageDataController;
  late MainPageData _mainPageData;

  TextEditingController? _searchTextFieldController;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    _mainPageDataController =
        ref.watch(mainPageDataControllerProvider.notifier);
    _mainPageData = ref.watch(mainPageDataControllerProvider);

    _searchTextFieldController = TextEditingController();

    _searchTextFieldController!.text = _mainPageData.searchText!;

    return _buildUI(context);
  }

  Widget _buildUI(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent, // Make the background transparent
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: _deviceHeight,
            width: _deviceWidth,
            child: Stack(
              alignment: Alignment.topCenter, // Align items to the top center
              children: [
                // Background image
                Image.asset(
                  'assets/images/background1.png',
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Black bar at the top
                Container(
                  height: 60, // Adjust the height
                  color:
                      Colors.black.withOpacity(0.5), // Semi-transparent black
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: IconButton(
                          onPressed: signUserOut,
                          icon: Icon(Icons.logout, color: Colors.white),
                        ),
                      ),
                      // Your logo widget
                      Image.asset(
                        'assets/images/logo.png',
                        height: 40, // Adjust the logo size
                        width: 40,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: IconButton(
                          icon: Icon(Icons.account_circle_rounded,
                              color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Welcome message
                Positioned(
                  top: _deviceHeight! * 0.1,
                  child: Text(
                    'Welcome to Filmpal',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Position the MovieCarousel below the black bar
                Positioned(
                  top: _deviceHeight! * 0.15, // Adjust the top position
                  left: 0,
                  right: 0,
                  child: MovieCarousel(movies: _mainPageData.movies!),
                ),
                // Position the TVShowCarousel below the MovieCarousel
                Positioned(
                  top: _deviceHeight! * 0.1, // Adjust the position
                  left: 0,
                  right: 0,
                  child: TVShowCarousel(tvShows: _mainPageData.movies!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
