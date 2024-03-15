import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import 'movie_tile.dart';

class FilterDropdown extends StatefulWidget {
  const FilterDropdown({Key? key}) : super(key: key);

  @override
  FilterDropdownState createState() => FilterDropdownState();
}

class FilterDropdownState extends State<FilterDropdown> {
  String? _selectedCategory = 'popularity.desc'; // Initial category
  List<String> filterCategories = [
    'popularity.asc',
    'popularity.desc',
    'vote_average.asc',
    'vote_average.desc'
  ];
  List<Movie> fetchedMovies = [];
  double? _deviceHeight;
  double? _deviceWidth;
  bool _loading = false; // Initialize to false

// Method to fetch movies based on selected category
  Future<void> fetchMovies(String category) async {
    setState(() {
      _loading = false;
    });
    final apiKey = 'ae4bef9cd906b358c4e43175b1ece0b6';
    final url = 'https://api.themoviedb.org/3/discover/movie';

    try {
      final response = await http.get(
        Uri.parse('$url?api_key=$apiKey&sort_by=$category'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          fetchedMovies = List<Movie>.from(data['results']
              .map((movieData) => Movie.fromJson(movieData, isMovie: true)));
          _loading = false;
        });
      } else {
        throw Exception('Failed to fetch movies');
      }
    } catch (e) {
      print('Error fetching movies: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 200, // Adjust the height to create padding
            child: Container(
              // Black box in the middle
              color: Colors.black,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50 // Adjust height as needed
                ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: _deviceHeight! * 0.01,
                  horizontal: 25,
                ),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      dropdownColor: Colors.black38,
                      value: _selectedCategory,
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white24,
                      ),
                      underline: Container(
                        height: 1,
                        color: Colors.white24,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                        if (newValue != null) {
                          fetchMovies(newValue);
                        }
                      },
                      items: filterCategories
                          .map((category) => DropdownMenuItem(
                                child: Text(
                                  _getCategoryName(category),
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: category,
                              ))
                          .toList(),
                    ),
                    Expanded(
                      child: _loading
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            )
                          : fetchedMovies.isNotEmpty
                              ? ListView.builder(
                                  itemCount: fetchedMovies.length,
                                  itemBuilder: (context, index) {
                                    final movie = fetchedMovies[index];
                                    return MovieTile(
                                      movie: movie,
                                      height: _deviceHeight! * 0.20,
                                      width: _deviceWidth! * 0.85,
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    'No movies found.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

// Method to get display name for category
  String _getCategoryName(String category) {
    switch (category) {
      case 'popularity.asc':
        return 'Popularity Ascending';
      case 'popularity.desc':
        return 'Popularity Descending';
      case 'vote_average.asc':
        return 'Vote Average Ascending';
      case 'vote_average.desc':
        return 'Vote Average Descending';
      default:
        return '';
    }
  }
}
