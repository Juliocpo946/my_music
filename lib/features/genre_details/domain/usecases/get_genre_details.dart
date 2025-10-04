import '../entities/genre_details_data.dart';
import '../repositories/genre_details_repository.dart';

class GetGenreDetails {
  final GenreDetailsRepository repository;

  GetGenreDetails(this.repository);

  Future<GenreDetailsData> call(String genreName) {
    return repository.getGenreDetails(genreName);
  }
}