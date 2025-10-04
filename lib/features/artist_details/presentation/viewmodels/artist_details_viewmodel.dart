import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_music/core/providers/dio_provider.dart';
import '../../data/datasources/artist_details_remote_datasource.dart';
import '../../data/repositories/artist_details_repository_impl.dart';
import '../../domain/entities/artist_details.dart';
import '../../domain/usecases/get_artist_details.dart';

part 'artist_details_viewmodel.g.dart';

@riverpod
Future<ArtistDetails> artistDetailsViewModel(
    ArtistDetailsViewModelRef ref, int artistId) async {
  final dio = ref.watch(dioProvider);
  final dataSource = ArtistDetailsRemoteDataSourceImpl(dio: dio);
  final repository = ArtistDetailsRepositoryImpl(remoteDataSource: dataSource);
  final getArtistDetails = GetArtistDetails(repository);
  return getArtistDetails(artistId);
}