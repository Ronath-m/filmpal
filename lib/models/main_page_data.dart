import 'package:filmpal/models/filter_category.dart';

import 'movie.dart';
import 'search _category.dart';

class MainPageData {
  final List<Movie>? movies;
  final int? page;
  final String? searchCategory;
  final String? filterCategory;
  final String? searchText;

  MainPageData(
      {this.movies,
      this.page,
      this.searchCategory,
      this.filterCategory,
      this.searchText});

  MainPageData.inital()
      : movies = [],
        page = 1,
        searchCategory = SearchCategory.popular,
        filterCategory = FilterCategory.popularity_desc,
        searchText = '';

  MainPageData copyWith(
      {List<Movie>? movies,
      int? page,
      String? searchCategory,
      String? filterCategory,
      String? searchText}) {
    return MainPageData(
        movies: movies ?? this.movies,
        page: page ?? this.page,
        searchCategory: searchCategory ?? this.searchCategory,
        searchText: searchText ?? this.searchText);
  }
}
