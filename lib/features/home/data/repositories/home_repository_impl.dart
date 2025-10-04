import '../../domain/entities/home_data.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import '../../domain/entities/album.dart';
import '../../domain/entities/artist.dart';
import '../../domain/entities/track.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<HomeData> getHomeData() async {
    try {
      final results = await Future.wait([
        remoteDataSource.getNewReleases(),
        remoteDataSource.getTopTracks(),
        remoteDataSource.getTopArtists(),
        remoteDataSource.getGenres(),
      ]);

      return HomeData(
        newReleases: results[0] as List<Album>,
        topTracks: (results[1] as List<Track>).take(5).toList(),
        topArtists: results[2] as List<Artist>,
        genres: results[3] as List<String>,
      );
    } catch (e) {
      throw Exception('Failed to load home data');
    }
  }
}