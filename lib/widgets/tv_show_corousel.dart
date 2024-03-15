import 'package:flutter/material.dart';
import '../models/movie.dart';

class TVShowCarousel extends StatelessWidget {
  final List<Movie> tvShows;
  double? _deviceHeight;
  double? _deviceWidth;

  TVShowCarousel({required this.tvShows});

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(
          top: _deviceHeight! * 0.65), // Add margin to push it down
      child: SizedBox(
        height: _deviceHeight! * 0.3, // Adjust the height of the carousel
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // Make it horizontally scrollable
          itemCount: tvShows.length,
          itemBuilder: (context, index) {
            Movie tvShow = tvShows[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      tvShow.posterURL() ?? '', // Handle null poster URL
                      fit: BoxFit.cover,
                      width: 120.0, // Adjust the width of each tile
                      height: 180.0, // Adjust the height of each tile
                    ),
                  ),
                  SizedBox(height: 4.0),
                  //_buildTVShowTitle(tvShow),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
