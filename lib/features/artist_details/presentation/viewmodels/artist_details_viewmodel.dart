import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_music/core/providers/dio_provider.dart';
import 'package:my_music/features/library/data/datasources/library_local_datasource.dart';
import '../../data/datasources/artist_details_remote_datasource.dart';
import '../../data/repositories/artist_details_repository_impl.dart';
import '../../domain/entities/artist_details.dart';
import '../../domain/usecases/get_artist_details.dart';
import '../../../home/domain/entities/artist.dart';

part 'artist_details_viewmodel.g.dart';

@riverpod
Future<ArtistDetails> artistDetailsViewModel(
    ArtistDetailsViewModelRef ref, {
      required int artistId,
      String? localArtistName,
    }) async {
  final localDataSource = LibraryLocalDataSourceImpl();

  final localTracks = await localDataSource.getTracksByArtistName(localArtistName ?? '');

  try {
    final dio = ref.watch(dioProvider);
    final dataSource = ArtistDetailsRemoteDataSourceImpl(dio: dio);
    final repository = ArtistDetailsRepositoryImpl(remoteDataSource: dataSource);
    final getArtistDetails = GetArtistDetails(repository);

    final remoteDetails = await getArtistDetails(artistId);

    return ArtistDetails(
      artist: remoteDetails.artist,
      topTracks: remoteDetails.topTracks,
      albums: remoteDetails.albums,
      localTracks: localTracks,
    );
  } catch (e) {
    return ArtistDetails(
      artist: Artist(
        id: artistId,
        name: localArtistName ?? 'Artista Desconocido',
        pictureMedium: '',
      ),
      topTracks: const [],
      albums: const [],
      localTracks: localTracks,
    );
  }
}