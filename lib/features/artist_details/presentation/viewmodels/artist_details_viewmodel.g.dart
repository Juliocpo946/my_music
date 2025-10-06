// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_details_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$artistDetailsViewModelHash() =>
    r'05cabe03265856f1da6cb416b9b3e8732b95a038';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [artistDetailsViewModel].
@ProviderFor(artistDetailsViewModel)
const artistDetailsViewModelProvider = ArtistDetailsViewModelFamily();

/// See also [artistDetailsViewModel].
class ArtistDetailsViewModelFamily extends Family<AsyncValue<ArtistDetails>> {
  /// See also [artistDetailsViewModel].
  const ArtistDetailsViewModelFamily();

  /// See also [artistDetailsViewModel].
  ArtistDetailsViewModelProvider call({
    required int artistId,
    String? localArtistName,
  }) {
    return ArtistDetailsViewModelProvider(
      artistId: artistId,
      localArtistName: localArtistName,
    );
  }

  @override
  ArtistDetailsViewModelProvider getProviderOverride(
    covariant ArtistDetailsViewModelProvider provider,
  ) {
    return call(
      artistId: provider.artistId,
      localArtistName: provider.localArtistName,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'artistDetailsViewModelProvider';
}

/// See also [artistDetailsViewModel].
class ArtistDetailsViewModelProvider
    extends AutoDisposeFutureProvider<ArtistDetails> {
  /// See also [artistDetailsViewModel].
  ArtistDetailsViewModelProvider({
    required int artistId,
    String? localArtistName,
  }) : this._internal(
          (ref) => artistDetailsViewModel(
            ref as ArtistDetailsViewModelRef,
            artistId: artistId,
            localArtistName: localArtistName,
          ),
          from: artistDetailsViewModelProvider,
          name: r'artistDetailsViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$artistDetailsViewModelHash,
          dependencies: ArtistDetailsViewModelFamily._dependencies,
          allTransitiveDependencies:
              ArtistDetailsViewModelFamily._allTransitiveDependencies,
          artistId: artistId,
          localArtistName: localArtistName,
        );

  ArtistDetailsViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.artistId,
    required this.localArtistName,
  }) : super.internal();

  final int artistId;
  final String? localArtistName;

  @override
  Override overrideWith(
    FutureOr<ArtistDetails> Function(ArtistDetailsViewModelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ArtistDetailsViewModelProvider._internal(
        (ref) => create(ref as ArtistDetailsViewModelRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        artistId: artistId,
        localArtistName: localArtistName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ArtistDetails> createElement() {
    return _ArtistDetailsViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ArtistDetailsViewModelProvider &&
        other.artistId == artistId &&
        other.localArtistName == localArtistName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, artistId.hashCode);
    hash = _SystemHash.combine(hash, localArtistName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ArtistDetailsViewModelRef on AutoDisposeFutureProviderRef<ArtistDetails> {
  /// The parameter `artistId` of this provider.
  int get artistId;

  /// The parameter `localArtistName` of this provider.
  String? get localArtistName;
}

class _ArtistDetailsViewModelProviderElement
    extends AutoDisposeFutureProviderElement<ArtistDetails>
    with ArtistDetailsViewModelRef {
  _ArtistDetailsViewModelProviderElement(super.provider);

  @override
  int get artistId => (origin as ArtistDetailsViewModelProvider).artistId;
  @override
  String? get localArtistName =>
      (origin as ArtistDetailsViewModelProvider).localArtistName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
