import '../entities/artist_details.dart';

abstract class ArtistDetailsRepository {
  Future<ArtistDetails> getArtistDetails(int artistId);
}