import 'dart:ui';

import 'package:filmpal/models/filter_category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/main_page_data_controller.dart';
import '../models/main_page_data.dart';
import '../models/movie.dart';
import '../models/search _category.dart';
import '../widgets/filterdropdown.dart';
import '../widgets/movie_tile.dart';
import 'movie_detail_screen.dart';

// Provider for MainPageDataController
final mainPageDataControllerProvider =
    StateNotifierProvider<MainPageDataController, MainPageData>((ref) {
  return MainPageDataController();
});

// Provider for selected movie poster URL
final selectedMoviePosterURLProvider = StateProvider<String?>((ref) {
  final _movies = ref.watch(mainPageDataControllerProvider).movies!;
  return _movies.length != 0 ? _movies[0].posterURL() : null;
});

// MainPage widget
class MainPage extends ConsumerWidget {
  double? _deviceHeight;
  double? _deviceWidth;

  late var _selectedMoviePosterURL;

  late MainPageDataController _mainPageDataController;
  late MainPageData _mainPageData;

  TextEditingController? _searchTextFieldController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    _mainPageDataController =
        ref.watch(mainPageDataControllerProvider.notifier);
    _mainPageData = ref.watch(mainPageDataControllerProvider);
    _selectedMoviePosterURL = ref.watch(selectedMoviePosterURLProvider);

    _searchTextFieldController = TextEditingController();

    _searchTextFieldController!.text = _mainPageData.searchText!;

    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
        height: _deviceHeight,
        width: _deviceWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _backgroundWidget(),
            _foregroundWidgets(),
            _customDropdownWidget()
          ],
        ),
      ),
    );
  }

// Background widget
  Widget _backgroundWidget() {
    if (_selectedMoviePosterURL != null) {
      return Container(
        height: _deviceHeight,
        width: _deviceWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: NetworkImage(_selectedMoviePosterURL),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: _deviceHeight,
        width: _deviceWidth,
        color: Colors.black,
      );
    }
  }

// Foreground widgets
  Widget _foregroundWidgets() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, _deviceHeight! * 0.02, 0, 0),
        width: _deviceWidth! * 0.90,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.03),
              child: _topBarWidget(),
            ),
            Container(
              height: _deviceHeight! * 0.83,
              padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.008),
              child: _moviesListViewWidget(),
            )
          ],
        ),
      ),
    );
  }

// Top bar widget
  Widget _topBarWidget() {
    return Container(
      width: _deviceWidth! * 0.85,
      height: _deviceHeight! * 0.08,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _searchFieldWidget(),
          _categorySelectionWidget(),
        ],
      ),
    );
  }

// Search field widget
  Widget _searchFieldWidget() {
    final _border = InputBorder.none;
    return Container(
      width: _deviceWidth! * 0.20,
      height: _deviceHeight! * 0.05,
      child: TextField(
        controller: _searchTextFieldController,
        onSubmitted: (_input) =>
            _mainPageDataController.updateTextSearch(_input),
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            focusedBorder: _border,
            border: _border,
            prefixIcon: Icon(Icons.search, color: Colors.white24),
            hintStyle: TextStyle(color: Colors.white54),
            filled: false,
            fillColor: Colors.white24,
            hintText: 'Search....'),
      ),
    );
  }

// Category selection widget
  Widget _categorySelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black38,
      value: _mainPageData.searchCategory,
      icon: Icon(
        Icons.menu,
        color: Colors.white24,
      ),
      underline: Container(
        height: 1,
        color: Colors.white24,
      ),
      onChanged: (dynamic _value) => _value.toString().isNotEmpty
          ? _mainPageDataController.updateSearchCategory(_value)
          : null,
      items: [
        DropdownMenuItem(
          child: Text(
            SearchCategory.popular,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.popular,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.upcoming,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.upcoming,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.now_playing,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.now_playing,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.top_rated,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.top_rated,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.airing_today,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.airing_today,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.top_grossing,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.top_grossing,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.children_movies,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.children_movies,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.top_rated_24,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.top_rated_24,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.discover,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.discover,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.watched_list,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.watched_list,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.watch_list,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.watch_list,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.watched_tvlist,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.watched_tvlist,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.watch_tvlist,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.watch_tvlist,
        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.none,
            style: TextStyle(color: Colors.white),
          ),
          value: SearchCategory.none,
        ),
      ],
    );
  }

// Custom dropdown widget
  Widget _customDropdownWidget() {
    // Check if the selected category is 'discover'
    bool isDiscover = _mainPageData.searchCategory == SearchCategory.discover;

    if (isDiscover) {
      return FilterDropdown(); // Return the FilterDropdown widget
    } else {
      return SizedBox(); // Return an empty SizedBox if it's not 'discover'
    }
  }

// Movies list view widget
  Widget _moviesListViewWidget() {
    final List<Movie> _movies = _mainPageData.movies!;

    if (_movies.length != 0) {
      return NotificationListener(
        onNotification: (dynamic _onScrollNotification) {
          if (_onScrollNotification is ScrollEndNotification) {
            final before = _onScrollNotification.metrics.extentBefore;
            final max = _onScrollNotification.metrics.maxScrollExtent;
            if (before == max) {
              _mainPageDataController.getMovies();
              return true;
            }
            return false;
          }
          return false;
        },
        child: Container(
          height: _deviceHeight! * 0.8, // Adjust the height as needed
          child: ListView.builder(
            itemCount: _movies.length,
            itemBuilder: (BuildContext _context, int _count) {
              // Check if the user is authenticated
              User? user = FirebaseAuth.instance.currentUser;

              // Check if the user is not null
              if (user != null) {
                // Get the user ID
                String userId = user.uid;

                // Use the user ID when navigating to the MovieDetailScreen
                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: _deviceHeight! * 0.01,
                    horizontal: 0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        _context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(
                            movie: _movies[_count],
                            userId: userId,
                          ),
                        ),
                      );
                    },
                    child: MovieTile(
                      movie: _movies[_count],
                      height: _deviceHeight! * 0.20,
                      width: _deviceWidth! * 0.85,
                    ),
                  ),
                );
              } else {
                // User is not authenticated, handle this case accordingly
                return Text('User not authenticated');
              }
            },
          ),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    }
  }
}
