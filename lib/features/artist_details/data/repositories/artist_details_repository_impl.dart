import 'package:my_music/features/home/domain/entities/album.dart';
import 'package:my_music/features/home/domain/entities/artist.dart';
import 'package:my_music/features/home/domain/entities/track.dart';
import '../../domain/entities/artist_details.dart';
import '../../domain/repositories/artist_details_repository.dart';
import '../datasources/artist_details_remote_datasource.dart';

class ArtistDetailsRepositoryImpl implements ArtistDetailsRepository {
  final ArtistDetailsRemoteDataSource remoteDataSource;

  ArtistDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ArtistDetails> getArtistDetails(int artistId) async {
    try {
      final results = await Future.wait([
        remoteDataSource.getArtistInfo(artistId),
        remoteDataSource.getArtistTopTracks(artistId),
        remoteDataSource.getArtistAlbums(artistId),
      ]);

      return ArtistDetails(
        artist: results[0] as Artist,
        topTracks: results[1] as List<Track>,
        albums: results[2] as List<Album>,
        localTracks: const [],
      );
    } catch (e) {
      throw Exception('Failed to load artist details');
    }
  }
}