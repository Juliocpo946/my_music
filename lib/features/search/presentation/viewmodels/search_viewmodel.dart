import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_music/core/providers/dio_provider.dart';
import '../../data/datasources/search_remote_datasource.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/usecases/get_search_results.dart';
import 'search_state.dart';

part 'search_viewmodel.g.dart';

@riverpod
class SearchViewModel extends _$SearchViewModel {
  Timer? _debounce;
  late GetSearchResults _getSearchResults;

  @override
  SearchState build() {
    final dio = ref.watch(dioProvider);
    final dataSource = SearchRemoteDataSourceImpl(dio: dio);
    final repository = SearchRepositoryImpl(remoteDataSource: dataSource);
    _getSearchResults = GetSearchResults(repository);
    return const SearchState();
  }

  Future<void> search(String query) async {
    state = state.copyWith(query: query);

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.isEmpty) {
      state = state.copyWith(isLoading: false, clearResults: true);
      return;
    }

    state = state.copyWith(isLoading: true);

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final results = await _getSearchResults(query);
        if (state.query == query) {
          state = state.copyWith(isLoading: false, results: results);
        }
      } catch (e) {
        if (state.query == query) {
          state =
              state.copyWith(isLoading: false, error: 'Failed to get results');
        }
      }
    });
  }

  void clearSearch() {
    state = const SearchState();
  }
}