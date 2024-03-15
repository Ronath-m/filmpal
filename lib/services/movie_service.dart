import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie.dart';
import 'http_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieService {
  final GetIt getIt = GetIt.instance;

  late HTTPService _http;

  MovieService() {
    _http = getIt.get<HTTPService>();
  }
  // Methods to fetch movies

  Future<List<Movie>?> getPopularMovies({int? page}) async {
    Response? _response = await _http.get('/movie/popular', query: {
      'page': page,
    });
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie>? _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData, isMovie: true);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t load popular movies.');
    }
  }

  Future<List<Movie>?> getUpcomingMovies({int? page}) async {
    Response? _response = await _http.get('/movie/upcoming', query: {
      'page': page,
    });
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie>? _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData, isMovie: true);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t load upcoming movies.');
    }
  }

  Future<List<Movie>?> getNowPlayingMovies({int? page}) async {
    Response? _response = await _http.get('/movie/now_playing', query: {
      'page': page,
    });
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie>? _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData, isMovie: true);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t load upcoming movies.');
    }
  }

  Future<List<Movie>?> getTopRatedMovies({int? page}) async {
    Response? _response = await _http.get('/movie/top_rated', query: {
      'page': page,
    });
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie>? _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData, isMovie: true);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t load upcoming movies.');
    }
  }

  Future<List<Movie>?> searchMovies(String? _seachTerm, {int? page}) async {
    Response? _response = await _http.get('/search/multi', query: {
      'query': _seachTerm,
      'page': page,
    });
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie>? _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData, isMovie: true);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t perform movies search.');
    }
  }

  Future<List<Movie>?> getRecommendedMovies() async {
    try {
      Response? _response = await _http.get('/movie/popular', query: {
        'page': 1,
      });

      if (_response!.statusCode == 200) {
        Map _data = _response.data;
        List<Movie>? _movies = _data['results'].map<Movie>((_movieData) {
          return Movie.fromJson(_movieData, isMovie: true);
        }).toList();
        return _movies;
      } else {
        throw Exception('Couldn\'t load recommended movies.');
      }
    } catch (e) {
      print('Error fetching recommended movies: $e');
      return null;
    }
  }

  Future<List<Movie>?> getAiringToday({int? page}) async {
    Response? _response = await _http.get('/tv/airing_today', query: {
      'page': page,
    });
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie>? _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData, isMovie: false);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t load upcoming movies.');
    }
  }

  Future<List<Movie>?> getTopGrossing({int? page}) async {
    Response? _response = await _http.get('/discover/movie', query: {
      'page': page,
      'sort_by': 'revenue.desc',
    });
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie>? _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData, isMovie: true);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t load upcoming movies.');
    }
  }

  Future<List<Movie>?> getMovieDiscover({int? page, String? sortBy}) async {
    Response? _response = await _http.get('/discover/movie', query: {
      'page': page,
      'sort_by': sortBy,
    });

    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie>? _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData, isMovie: true);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t load top grossing movies.');
    }
  }

  Future<List<Movie>?> getChildrenMovies({int? page}) async {
    Response? _response = await _http.get('/discover/movie',
        query: {'page': page, 'include_adult': 'false', 'with_genres': 16});
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie>? _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData, isMovie: true);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t load upcoming movies.');
    }
  }

  Future<List<Movie>?> getTopRatedThisYear({int? page}) async {
    Response? _response = await _http.get('/discover/movie', query: {
      'page': page,
      'primary_release_year': 2024,
      'sort_by': 'vote_average.desc',
    });
    if (_response!.statusCode == 200) {
      Map _data = _response.data;
      List<Movie>? _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData, isMovie: true);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t load upcoming movies.');
    }
  }

  Future<List<Movie>> getWatchedMovies(String userId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('watched_movies')
          .doc(userId)
          .get();
      if (response.exists) {
        final data = response.data() as Map<String, dynamic>;
        final List<String> movieIds = data.keys.toList();
        return await fetchMoviesDetails(movieIds);
      } else {
        return []; // No watched movies found
      }
    } catch (e) {
      print('Error fetching watched movies: $e');
      return [];
    }
  }

  Future<List<Movie>> getWatchedTvshows(String userId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('watched_tvshows')
          .doc(userId)
          .get();
      if (response.exists) {
        final data = response.data() as Map<String, dynamic>;
        final List<String> movieIds = data.keys.toList();
        return await fetchTvDetails(movieIds);
      } else {
        return []; // No watched movies found
      }
    } catch (e) {
      print('Error fetching watched tvshows: $e');
      return [];
    }
  }

  Future<List<Movie>> getWatchMovies(String userId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('watch_movies')
          .doc(userId)
          .get();
      if (response.exists) {
        final data = response.data() as Map<String, dynamic>;
        final List<String> movieIds = data.keys.toList();
        return await fetchMoviesDetails(movieIds);
      } else {
        return []; // No watch movies found
      }
    } catch (e) {
      print('Error fetching watch movies: $e');
      return [];
    }
  }

  Future<List<Movie>> getWatchTvshows(String userId) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('watch_tvshows')
          .doc(userId)
          .get();
      if (response.exists) {
        final data = response.data() as Map<String, dynamic>;
        final List<String> movieIds = data.keys.toList();
        return await fetchTvDetails(movieIds);
      } else {
        return []; // No watch movies found
      }
    } catch (e) {
      print('Error fetching watch tvshows: $e');
      return [];
    }
  }

  Future<List<Movie>> fetchMoviesDetails(List<String> movieIds) async {
    final String apiKey = 'ae4bef9cd906b358c4e43175b1ece0b6';
    final List<Movie> movies = [];

    for (String movieId in movieIds) {
      final String url =
          'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        movies.add(Movie.fromJson(data, isMovie: true));
      } else {
        print('Failed to fetch movie details for ID: $movieId');
      }
    }

    return movies;
  }

  Future<List<Movie>> fetchTvDetails(List<String> movieIds) async {
    final String apiKey = 'ae4bef9cd906b358c4e43175b1ece0b6';
    final List<Movie> movies = [];

    for (String movieId in movieIds) {
      final String url =
          'https://api.themoviedb.org/3/tv/$movieId?api_key=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        movies.add(Movie.fromJson(data, isMovie: true));
      } else {
        print('Failed to fetch movie details for ID: $movieId');
      }
    }

    return movies;
  }
}
