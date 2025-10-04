import '../entities/search_result.dart';
import '../repositories/search_repository.dart';

class GetSearchResults {
  final SearchRepository repository;

  GetSearchResults(this.repository);

  Future<SearchResult> call(String query) async {
    return repository.search(query);
  }
}