import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_music/core/providers/dio_provider.dart';
import 'package:my_music/features/genre_details/data/datasources/genre_details_remote_datasource.dart';
import 'package:my_music/features/genre_details/data/repositories/genre_details_repository_impl.dart';
import 'package:my_music/features/genre_details/domain/entities/genre_details_data.dart';
import 'package:my_music/features/genre_details/domain/usecases/get_genre_details.dart';

part 'genre_details_viewmodel.g.dart';

@riverpod
Future<GenreDetailsData> genreDetailsViewModel(
    GenreDetailsViewModelRef ref,
    String genreName,
    ) async {
  final dio = ref.watch(dioProvider);
  final dataSource = GenreDetailsRemoteDataSourceImpl(dio: dio);
  final repository = GenreDetailsRepositoryImpl(remoteDataSource: dataSource);
  final getGenreDetails = GetGenreDetails(repository);

  return getGenreDetails(genreName);
}