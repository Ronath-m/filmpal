import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  final String userId; // Unique identifier for the logged-in user

  const MovieDetailScreen({Key? key, required this.movie, required this.userId})
      : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool isWatched = false;
  bool addedWatch = false;
  late String? trailerVideoId;
  bool isMovie = true;

  @override
  void initState() {
    super.initState();
    if (widget.movie.media == false) {
      isMovie = false;
    }
    // Check if the movie is watched by the current user
    checkIfWatched();
    checkAddedWatch();
    fetchTrailerVideoId();
  }

// Method to check if the movie is watched by the current user
  void checkIfWatched() {
    print('User ID: ${widget.userId}');
    // Ensure the userId is not empty or null
    if (widget.userId.isNotEmpty) {
      // Define the collection name based on whether it's a movie or TV show
      String collectionName = isMovie ? 'watched_movies' : 'watched_tvshows';

      // Access Firestore collection for watched movies or TV shows
      FirebaseFirestore.instance
          .collection(collectionName)
          .doc(widget.userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          // Cast data to Map<String, dynamic>
          Map<String, dynamic>? data =
              documentSnapshot.data() as Map<String, dynamic>?;

          // Check if the movie or TV show ID exists in the watched movies list
          if (data != null && data.containsKey(widget.movie.id.toString())) {
            setState(() {
              isWatched = data[widget.movie.id.toString()] ?? false;
            });
          }
        }
      }).catchError((error) {
        print("Failed to load watched movies or TV shows: $error");
      });
    } else {
      print("User ID is empty or null");
    }
  }

  // Method to check if the movie is watched by the current user
  void checkAddedWatch() {
    print('User ID: ${widget.userId}');
    // Ensure the userId is not empty or null
    if (widget.userId.isNotEmpty) {
      String collectionName = isMovie ? 'watch_movies' : 'watch_tvshows';
      // Access Firestore collection for watched movies
      FirebaseFirestore.instance
          .collection(collectionName)
          .doc(widget.userId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          // Cast data to Map<String, dynamic>
          Map<String, dynamic>? data =
              documentSnapshot.data() as Map<String, dynamic>?;

          // Check if the movie ID exists in the watched movies list
          if (data != null && data.containsKey(widget.movie.id.toString())) {
            setState(() {
              isWatched = data[widget.movie.id.toString()] ?? false;
            });
          }
        }
      }).catchError((error) {
        print("Failed to load watched movies: $error");
      });
    } else {
      print("User ID is empty or null");
    }
  }

// Function to handle saving watched movies
  void saveWatchedMovie() {
    String collectionName = isMovie ? 'watched_movies' : 'watched_tvshows';
    // Access Firestore collection for watched movies
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(widget.userId) // Document ID is the user's UID
        .set({
      widget.movie.id.toString():
          true // Set the movie ID as key and true as value
    }, SetOptions(merge: true)) // Merge with existing data if document exists
        .then((_) {
      // Movie saved successfully
      setState(() {
        isWatched = true;
      });
      print('Movie saved as watched for user ${widget.userId}');
    }).catchError((error) {
      // Failed to save movie
      print("Failed to save movie: $error");
    });
  }

  // Function to handle saving watch movies
  void saveWatchMovie() {
    String collectionName = isMovie ? 'watch_movies' : 'watch_tvshows';
    // Access Firestore collection for watched movies
    FirebaseFirestore.instance
        .collection(collectionName)
        .doc(widget.userId) // Document ID is the user's UID
        .set({
      widget.movie.id.toString():
          true // Set the movie ID as key and true as value
    }, SetOptions(merge: true)) // Merge with existing data if document exists
        .then((_) {
      // Movie saved successfully
      setState(() {
        addedWatch = true;
      });
      print('Movie saved as watched for user ${widget.userId}');
    }).catchError((error) {
      // Failed to save movie
      print("Failed to save movie: $error");
    });
  }

  Future<void> fetchTrailerVideoId() async {
    final apiKey = 'ae4bef9cd906b358c4e43175b1ece0b6';
    final url = 'https://api.themoviedb.org/3/movie/${widget.movie.id}/videos';

    final response = await http.get(Uri.parse('$url?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      for (final result in results) {
        final String type = result['type'];
        if (type == 'Trailer') {
          setState(() {
            trailerVideoId = result['key'];
          });
          break;
        }
      }
    } else {
      print('Failed to fetch trailer video ID');
    }
  }

  void watchTrailer() {
    if (trailerVideoId != null) {
      // Open the YouTube app with the trailer video
      launch('https://www.youtube.com/watch?v=$trailerVideoId');
    } else {
      print('Trailer video ID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 23.5,
            right: 85, // Adjusted position for the trailer button
            child: Visibility(
              visible:
                  isMovie, // Assuming isMovie is a boolean indicating if it's a movie
              child: GestureDetector(
                onTap: watchTrailer,
                child: Icon(
                  Icons.play_circle_fill,
                  size: 24.0,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
          Positioned(
            top: 16.0,
            right:
                45, // Adjusted position for the watch and watched list buttons
            child: IconButton(
              icon: Icon(
                addedWatch ? Icons.access_time_filled : Icons.access_time,
                color: addedWatch ? Colors.green : Colors.white,
              ),
              onPressed: () {
                // Call function to save/watch movie
                saveWatchMovie();
              },
            ),
          ),
          Positioned(
            top: 16.0,
            right:
                10, // Adjusted position for the watch and watched list buttons
            child: IconButton(
              icon: Icon(
                isWatched ? Icons.visibility : Icons.visibility_off,
                color: isWatched ? Colors.green : Colors.white,
              ),
              onPressed: () {
                // Call function to save/watch movie
                saveWatchedMovie();
              },
            ),
          ),
          // Movie poster in pill shape
          Positioned(
            top: 80.0,
            left: MediaQuery.of(context).size.width / 2 - 120.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.network(
                widget.movie.posterURL(),
                width: 240.0,
                height: 360.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Circular back button...
          Positioned(
            top: 16.0,
            left: 16.0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.white.withOpacity(0.5),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Movie details
          Positioned(
            top: 450.0,
            left: 16.0,
            right: 16.0,
            bottom: 16.0, // Adjusted for scrolling
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating in yellow...
                  Container(
                    width: 40.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.yellow,
                    ),
                    child: Center(
                      child: Text(
                        '${widget.movie.rating ?? ''}',
                        style: TextStyle(fontSize: 12.0, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Movie title...
                  Text(
                    widget.movie.name ?? '',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Release date...
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey,
                    ),
                    child: Text(
                      'Release Date: ${widget.movie.releaseDate ?? ''}',
                      style: TextStyle(fontSize: 12.0, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Popularity...
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey,
                    ),
                    child: Text(
                      'Popularity: ${widget.movie.popularity ?? ''}',
                      style: TextStyle(fontSize: 12.0, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Vote count...
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey,
                    ),
                    child: Text(
                      'Vote Count: ${widget.movie.voteCount ?? ''}',
                      style: TextStyle(fontSize: 12.0, color: Colors.black),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Description...
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: Text(
                      widget.movie.description ?? '',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
