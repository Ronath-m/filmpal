import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActorSearchPage extends StatefulWidget {
  @override
  ActorSearchPageState createState() => ActorSearchPageState();
}

class ActorSearchPageState extends State<ActorSearchPage> {
  TextEditingController _searchController = TextEditingController();
  bool _loading = false;
  List<Map<String, dynamic>> _actors = [];

  Future<void> searchActors(String query) async {
    setState(() {
      _loading = true;
      _actors.clear();
    });

    // Make API call to search actors
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/search/person?query=$query&api_key=ae4bef9cd906b358c4e43175b1ece0b6'),
    );

    if (response.statusCode == 200) {
      final results = json.decode(response.body)['results'] as List<dynamic>;

      // Iterate over the search results
      for (final result in results) {
        final actorId = result['id'];

        // Get movie credits for the actor
        final movieCreditsResponse = await http.get(
          Uri.parse(
              'https://api.themoviedb.org/3/person/$actorId/movie_credits?api_key=ae4bef9cd906b358c4e43175b1ece0b6'),
        );

        if (movieCreditsResponse.statusCode == 200) {
          final movieCredits =
              json.decode(movieCreditsResponse.body)['cast'] as List<dynamic>;

          // Iterate over the movies the actor appeared in
          int movieCount = 0;
          for (final movieCredit in movieCredits) {
            if (movieCount >= 5)
              break; // Exit loop if 10 movies have been processed
            final movieId = movieCredit['id'];

            // Get credits for the movie
            final creditsResponse = await http.get(
              Uri.parse(
                  'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=ae4bef9cd906b358c4e43175b1ece0b6'),
            );

            if (creditsResponse.statusCode == 200) {
              final crew =
                  json.decode(creditsResponse.body)['cast'] as List<dynamic>;

              // Iterate over the crew to find other actors
              for (final member in crew) {
                final actorName = member['name'] as String?;
                final knownForDepartment =
                    member['known_for_department'] as String?;
                final profilePath = member['profile_path'] as String?;
                final popularity = member['popularity'] as double?;

                // Check if the crew member is an actor and add them to the list
                if (knownForDepartment == 'Acting' &&
                    actorName != null &&
                    actorName != query &&
                    !_actors.contains(actorName)) {
                  _actors.add({
                    'name': actorName,
                    'profile_path': profilePath,
                    'popularity': popularity ?? 0.0,
                    'known_for_department': knownForDepartment ?? 'Unknown',
                  });
                }
              }
            }
            movieCount++; //Increment the movie counter
          }
        }
      }
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actor Search'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1C1C1C), Color(0xFF0D0D0D)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: Colors.white), // White text color
                decoration: InputDecoration(
                  labelText: 'Search Actors',
                  prefixIcon: Icon(Icons.search,
                      color: Colors.white), // White search icon
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0), // Curved edges
                    borderSide: BorderSide.none, // No border
                  ),
                  filled: true,
                  fillColor: Colors.white
                      .withOpacity(0.3), // Transparent white background
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear,
                        color: Colors.white), // White clear icon
                    onPressed: () {
                      _searchController.clear();
                      _actors.clear();
                      setState(() {});
                    },
                  ),
                  labelStyle:
                      TextStyle(color: Colors.white), // White label text color
                ),
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    searchActors(query);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: Text(
                'Search for actors to get relevant starred actors',
                style: TextStyle(color: Colors.white),
              ),
            ),
            _loading
                ? Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: _actors.length,
                      itemBuilder: (context, index) {
                        final actor = _actors[index];
                        return InkWell(
                          onTap: () {
                            // On tap to get the effect
                          },
                          child: ListTile(
                            leading: actor['profile_path'] != null
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://image.tmdb.org/t/p/w200${actor['profile_path']}'),
                                  )
                                : Icon(Icons.person),
                            title: Text(actor['name'] ?? 'Unknown',
                                style: TextStyle(
                                    color: Colors.white)), // White text color
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Popularity: ${actor['popularity'] ?? 0.0}',
                                    style: TextStyle(
                                        color:
                                            Colors.white)), // White text color
                                Text(
                                    'Known For: ${actor['known_for_department'] ?? 'Unknown'}',
                                    style: TextStyle(
                                        color:
                                            Colors.white)), // White text color
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
