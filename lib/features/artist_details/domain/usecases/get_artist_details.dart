import '../entities/artist_details.dart';
import '../repositories/artist_details_repository.dart';

class GetArtistDetails {
  final ArtistDetailsRepository repository;

  GetArtistDetails(this.repository);

  Future<ArtistDetails> call(int artistId) async {
    return repository.getArtistDetails(artistId);
  }
}