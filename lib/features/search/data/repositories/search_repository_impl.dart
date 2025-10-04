import 'package:my_music/features/home/domain/entities/album.dart';
import 'package:my_music/features/home/domain/entities/artist.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import '../../domain/entities/search_result.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SearchResult> search(String query) async {
    try {
      if (query.isEmpty) {
        return SearchResult(tracks: [], artists: [], albums: []);
      }

      final results = await Future.wait([
        remoteDataSource.searchTracks(query),
        remoteDataSource.searchArtists(query),
        remoteDataSource.searchAlbums(query),
      ]);

      return SearchResult(
        tracks: results[0] as List<Track>,
        artists: results[1] as List<Artist>,
        albums: results[2] as List<Album>,
      );
    } catch (e) {
      throw Exception('Failed to perform search');
    }
  }
}