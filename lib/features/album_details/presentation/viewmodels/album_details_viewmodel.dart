import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_music/core/providers/dio_provider.dart';
import 'package:my_music/features/library/data/datasources/library_local_datasource.dart';
import '../../data/datasources/album_details_remote_datasource.dart';
import '../../data/repositories/album_details_repository_impl.dart';
import '../../domain/entities/album_details.dart';
import '../../domain/usecases/get_album_details.dart';

part 'album_details_viewmodel.g.dart';

@riverpod
Future<AlbumDetails> albumDetailsViewModel(
    AlbumDetailsViewModelRef ref, {
      required int albumId,
      String? localAlbumTitle,
    }) async {
  final localDataSource = LibraryLocalDataSourceImpl();

  final localTracks = await localDataSource.getTracksByAlbumTitle(localAlbumTitle ?? '');

  try {
    final dio = ref.watch(dioProvider);
    final dataSource = AlbumDetailsRemoteDataSourceImpl(dio: dio);
    final repository = AlbumDetailsRepositoryImpl(remoteDataSource: dataSource);
    final getAlbumDetails = GetAlbumDetails(repository);

    final remoteDetails = await getAlbumDetails(albumId);

    return AlbumDetails(
        id: remoteDetails.id,
        title: remoteDetails.title,
        coverBig: remoteDetails.coverBig,
        artistName: remoteDetails.artistName,
        tracks: remoteDetails.tracks,
        localTracks: localTracks);

  } catch (e) {
    if (localTracks.isNotEmpty) {
      final representativeTrack = localTracks.first;
      return AlbumDetails(
        id: representativeTrack.albumId,
        title: representativeTrack.albumTitle,
        coverBig: '',
        artistName: representativeTrack.artist.name,
        tracks: const [],
        localTracks: localTracks,
      );
    }
    throw Exception('Failed to load album details');
  }
}