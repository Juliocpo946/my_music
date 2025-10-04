import 'package:equatable/equatable.dart';
import '../../domain/entities/search_result.dart';

class SearchState extends Equatable {
  final String query;
  final bool isLoading;
  final SearchResult? results;
  final String? error;

  const SearchState({
    this.query = '',
    this.isLoading = false,
    this.results,
    this.error,
  });

  SearchState copyWith({
    String? query,
    bool? isLoading,
    SearchResult? results,
    String? error,
    bool clearResults = false,
  }) {
    return SearchState(
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      results: clearResults ? null : results ?? this.results,
      error: error,
    );
  }

  @override
  List<Object?> get props => [query, isLoading, results, error];
}