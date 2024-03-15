import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/movie.dart';

class MovieCarousel extends StatefulWidget {
  final List<Movie> movies;

  MovieCarousel({required this.movies});

  @override
  _MovieCarouselState createState() => _MovieCarouselState();
}

class _MovieCarouselState extends State<MovieCarousel> {
  int _currentCarouselIndex = 0;
  double? _deviceHeight;
  double? _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return widget.movies.isNotEmpty
        ? Container(
            margin: EdgeInsets.only(
                top: 20.0), // Adjust the value to add more space
            child: Column(
              children: [
                CarouselSlider.builder(
                  itemCount: widget.movies.length,
                  options: CarouselOptions(
                    height: _deviceHeight! * 0.5,
                    aspectRatio: 16 / 9, // Adjust the aspect ratio
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 2),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.easeInOutCirc,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentCarouselIndex = index;
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIndex) {
                    Movie movie = widget.movies[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.network(
                          movie.posterURL(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10), // Adjust the spacing as needed
                _buildMovieTitle(widget.movies[_currentCarouselIndex]),
              ],
            ),
          )
        : SizedBox.shrink(); // Return an empty widget if movies list is empty
  }

//To show the title of current movie
  Widget _buildMovieTitle(Movie movie) {
    return Text(
      movie.name ?? '',
      style: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.white, // Adjust the text color
      ),
    );
  }
}
