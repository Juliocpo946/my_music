import 'package:my_music/features/home/domain/entities/album.dart';
import 'package:my_music/features/home/domain/entities/artist.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import '../../domain/entities/genre_details_data.dart';
import '../../domain/repositories/genre_details_repository.dart';
import '../datasources/genre_details_remote_datasource.dart';

class GenreDetailsRepositoryImpl implements GenreDetailsRepository {
  final GenreDetailsRemoteDataSource remoteDataSource;

  GenreDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GenreDetailsData> getGenreDetails(String genreName) async {
    try {
      final results = await Future.wait([
        remoteDataSource.searchTracksByGenre(genreName),
        remoteDataSource.searchArtistsByGenre(genreName),
        remoteDataSource.searchAlbumsByGenre(genreName),
      ]);

      return GenreDetailsData(
        tracks: results[0] as List<Track>,
        artists: results[1] as List<Artist>,
        albums: results[2] as List<Album>,
      );
    } catch (e) {
      throw Exception('Failed to load genre details');
    }
  }
}