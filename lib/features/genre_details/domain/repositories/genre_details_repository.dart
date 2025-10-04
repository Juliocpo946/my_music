import '../entities/genre_details_data.dart';

abstract class GenreDetailsRepository {
  Future<GenreDetailsData> getGenreDetails(String genreName);
}