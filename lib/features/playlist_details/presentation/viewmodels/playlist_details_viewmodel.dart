import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_music/features/playlist_details/data/datasources/playlist_details_local_datasource.dart';
import 'package:my_music/features/playlist_details/data/repositories/playlist_details_repository_impl.dart';
import 'package:my_music/features/playlist_details/domain/entities/playlist_details.dart';
import 'package:my_music/features/playlist_details/domain/usecases/get_playlist_details.dart';

part 'playlist_details_viewmodel.g.dart';

@riverpod
Future<PlaylistDetails> playlistDetailsViewModel(
     Ref ref,
    int playlistId,
    ) async {
  final localDataSource = PlaylistDetailsLocalDataSourceImpl();
  final repository =
  PlaylistDetailsRepositoryImpl(localDataSource: localDataSource);
  final getPlaylistDetails = GetPlaylistDetails(repository);
  return getPlaylistDetails(playlistId);
}