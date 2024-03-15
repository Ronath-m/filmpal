import 'package:filmpal/models/filter_category.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../models/main_page_data.dart';
import '../models/movie.dart';
import '../models/search _category.dart';
import '../services/movie_service.dart';

// Controller class for managing main page data
class MainPageDataController extends StateNotifier<MainPageData> {
  final MovieService _movieService;

  MainPageDataController({MovieService? movieService, MainPageData? state})
      : _movieService = movieService ?? GetIt.instance.get<MovieService>(),
        super(state ?? MainPageData.inital()) {
    getMovies();
  }

  // Method to fetch movies based on search and filter criteria
  Future<void> getMovies() async {
    try {
      List<Movie>? _movies = [];

      if (state.searchText!.isEmpty) {
        if (state.searchCategory == SearchCategory.popular) {
          _movies = await (_movieService.getPopularMovies(page: state.page));
        } else if (state.searchCategory == SearchCategory.upcoming) {
          _movies = await (_movieService.getUpcomingMovies(page: state.page));
        } else if (state.searchCategory == SearchCategory.none) {
          _movies = [];
        } else if (state.searchCategory == SearchCategory.now_playing) {
          _movies = await (_movieService.getNowPlayingMovies(page: state.page));
        } else if (state.searchCategory == SearchCategory.top_rated) {
          _movies = await (_movieService.getTopRatedMovies(page: state.page));
        } else if (state.searchCategory == SearchCategory.airing_today) {
          _movies = await (_movieService.getAiringToday(page: state.page));
        } else if (state.searchCategory == SearchCategory.top_grossing) {
          _movies = await (_movieService.getTopGrossing(page: state.page));
        } else if (state.searchCategory == SearchCategory.children_movies) {
          _movies = await (_movieService.getChildrenMovies(page: state.page));
        } else if (state.searchCategory == SearchCategory.top_rated_24) {
          _movies = await (_movieService.getTopRatedThisYear(page: state.page));
        } else if (state.searchCategory == SearchCategory.watched_list) {
          User? user = FirebaseAuth.instance.currentUser;
          String userId = user!.uid;
          _movies = await (_movieService.getWatchedMovies(userId));
        } else if (state.searchCategory == SearchCategory.watched_tvlist) {
          User? user = FirebaseAuth.instance.currentUser;
          String userId = user!.uid;
          _movies = await (_movieService.getWatchedTvshows(userId));
        } else if (state.searchCategory == SearchCategory.watch_tvlist) {
          User? user = FirebaseAuth.instance.currentUser;
          String userId = user!.uid;
          _movies = await (_movieService.getWatchTvshows(userId));
        } else if (state.searchCategory == SearchCategory.watch_list) {
          User? user = FirebaseAuth.instance.currentUser;
          String userId = user!.uid;
          _movies = await (_movieService.getWatchMovies(userId));
        }
      } else {
        _movies = await (_movieService.searchMovies(state.searchText,
            page: state.page));
      }
      // Updating state with fetched movies and incrementing page number
      state = state.copyWith(
          movies: [...state.movies!, ..._movies!], page: state.page! + 1);
    } catch (e) {
      print(e);
    }
  }

  // Method to update search category
  void updateSearchCategory(String? _category) {
    try {
      state = state.copyWith(
          movies: [], page: 1, searchCategory: _category, searchText: '');
      getMovies();
    } catch (e) {
      print(e);
    }
  }

// Method to update filter category
  void updateFilterCategory(String? _category) {
    try {
      state = state.copyWith(
          movies: [], page: 1, filterCategory: _category, searchText: '');
      getMovies();
    } catch (e) {
      print(e);
    }
  }

  // Method to update text search
  void updateTextSearch(String _searchText) {
    try {
      state = state.copyWith(
          movies: [],
          page: 1,
          searchCategory: SearchCategory.none,
          searchText: _searchText);
      getMovies();
    } catch (e) {
      print(e);
    }
  }
}
