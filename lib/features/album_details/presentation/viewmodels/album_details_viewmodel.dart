import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_music/core/providers/dio_provider.dart';
import '../../data/datasources/album_details_remote_datasource.dart';
import '../../data/repositories/album_details_repository_impl.dart';
import '../../domain/entities/album_details.dart';
import '../../domain/usecases/get_album_details.dart';

part 'album_details_viewmodel.g.dart';

@riverpod
Future<AlbumDetails> albumDetailsViewModel(
    AlbumDetailsViewModelRef ref, int albumId) async {
  final dio = ref.watch(dioProvider);
  final dataSource = AlbumDetailsRemoteDataSourceImpl(dio: dio);
  final repository = AlbumDetailsRepositoryImpl(remoteDataSource: dataSource);
  final getAlbumDetails = GetAlbumDetails(repository);
  return getAlbumDetails(albumId);
}