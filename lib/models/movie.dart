import 'package:get_it/get_it.dart';

import 'app_config.dart';

class Movie {
  final String? name;
  final String? language;
  final bool? isAdult;
  final String? description;
  final String? posterPath;
  final String? backdropPath;
  final num? rating;
  final String? releaseDate;
  final num? voteCount;
  final num? popularity;
  final num? id;
  final bool? media;

  Movie(
      {this.name,
      this.language,
      this.isAdult,
      this.description,
      this.posterPath,
      this.backdropPath,
      this.rating,
      this.releaseDate,
      this.voteCount,
      this.popularity,
      this.id,
      this.media});

  factory Movie.fromJson(Map<String, dynamic> json, {required bool isMovie}) {
    final mediaType = json['media_type'];

    // Determine if it's a movie, TV show, or person based on the media type
    bool isMediaMovie = mediaType != null ? mediaType == 'movie' : isMovie;
    bool isMediaTVShow = mediaType != null ? mediaType == 'tv' : false;
    bool isMediaPerson = mediaType != null ? mediaType == 'person' : false;
    if (isMediaTVShow == true) {
      isMovie = false;
    }

    // Extract title, release date, and other fields based on the media type
    String title = '';
    String releaseDate = '';
    String? backdropPath;
    String? description;
    int? id;
    double? rating;
    double? popularity;
    String? posterPath;
    bool media = isMovie;

    if (isMediaMovie || isMediaTVShow) {
      title = isMediaMovie ? json['title'] ?? '' : json['name'] ?? '';
      releaseDate = isMediaMovie
          ? json['release_date'] ?? ''
          : json['first_air_date'] ?? '';
      backdropPath = json['backdrop_path'] ?? '';
      description = json['overview'] ?? '';
      id = json['id'] ?? 0;
      rating = (json['vote_average'] ?? 0.0).toDouble();
      popularity = (json['popularity'] ?? 0.0).toDouble();
      posterPath = json['poster_path'] ?? '';
    } else if (isMediaPerson) {
      // If media_type is 'person', extract known movies or TV shows
      final knownFor = json['known_for'] as List<dynamic>? ?? [];
      if (knownFor.isNotEmpty) {
        // Iterate over each item in the known_for list
        for (final item in knownFor) {
          final itemType = item['media_type'];
          // Check if the item is a movie or TV show
          if (itemType == 'movie' || itemType == 'tv') {
            title =
                itemType == 'movie' ? item['title'] ?? '' : item['name'] ?? '';
            releaseDate = itemType == 'movie'
                ? item['release_date'] ?? ''
                : item['first_air_date'] ?? '';
            backdropPath = item['backdrop_path'] ?? '';
            description = item['overview'] ?? '';
            id = item['id'] ?? 0;
            rating = (item['vote_average'] ?? 0.0).toDouble();
            popularity = (item['popularity'] ?? 0.0).toDouble();
            posterPath = item['poster_path'] ?? '';
            // Exit the loop after processing the first valid item
            break;
          }
        }
      }
    }

    // If no suitable known media type is found, fall back to the default behavior
    if (title.isEmpty) {
      title = isMovie ? json['title'] ?? '' : json['name'] ?? '';
      releaseDate =
          isMovie ? json['release_date'] ?? '' : json['first_air_date'] ?? '';
      backdropPath = json['backdrop_path'] ?? '';
      description = json['overview'] ?? '';
      id = json['id'] ?? 0;
      rating = (json['vote_average'] ?? 0.0).toDouble();
      popularity = (json['popularity'] ?? 0.0).toDouble();
      posterPath = json['poster_path'] ?? '';
    }

    return Movie(
        name: title,
        language: json['original_language'] ?? '',
        isAdult: json['adult'] ?? false,
        description: description,
        posterPath: posterPath,
        backdropPath: backdropPath,
        rating: rating,
        releaseDate: releaseDate,
        voteCount: json['vote_count'] ?? 0,
        popularity: popularity,
        id: id,
        media: media);
  }
// Method to construct the poster URL for a movie/tv show
  String posterURL() {
    final AppConfig _appConfig = GetIt.instance.get<AppConfig>();
    return '${_appConfig.BASE_IMAGE_API_URL}${this.posterPath}';
  }
}
