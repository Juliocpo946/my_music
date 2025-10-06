// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_details_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$albumDetailsViewModelHash() =>
    r'eb155dad4c493ca11f49b2b75e808d74125546e4';

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

/// See also [albumDetailsViewModel].
@ProviderFor(albumDetailsViewModel)
const albumDetailsViewModelProvider = AlbumDetailsViewModelFamily();

/// See also [albumDetailsViewModel].
class AlbumDetailsViewModelFamily extends Family<AsyncValue<AlbumDetails>> {
  /// See also [albumDetailsViewModel].
  const AlbumDetailsViewModelFamily();

  /// See also [albumDetailsViewModel].
  AlbumDetailsViewModelProvider call(
    int albumId,
  ) {
    return AlbumDetailsViewModelProvider(
      albumId,
    );
  }

  @override
  AlbumDetailsViewModelProvider getProviderOverride(
    covariant AlbumDetailsViewModelProvider provider,
  ) {
    return call(
      provider.albumId,
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
  String? get name => r'albumDetailsViewModelProvider';
}

/// See also [albumDetailsViewModel].
class AlbumDetailsViewModelProvider
    extends AutoDisposeFutureProvider<AlbumDetails> {
  /// See also [albumDetailsViewModel].
  AlbumDetailsViewModelProvider(
    int albumId,
  ) : this._internal(
          (ref) => albumDetailsViewModel(
            ref as AlbumDetailsViewModelRef,
            albumId,
          ),
          from: albumDetailsViewModelProvider,
          name: r'albumDetailsViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$albumDetailsViewModelHash,
          dependencies: AlbumDetailsViewModelFamily._dependencies,
          allTransitiveDependencies:
              AlbumDetailsViewModelFamily._allTransitiveDependencies,
          albumId: albumId,
        );

  AlbumDetailsViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.albumId,
  }) : super.internal();

  final int albumId;

  @override
  Override overrideWith(
    FutureOr<AlbumDetails> Function(AlbumDetailsViewModelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AlbumDetailsViewModelProvider._internal(
        (ref) => create(ref as AlbumDetailsViewModelRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        albumId: albumId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AlbumDetails> createElement() {
    return _AlbumDetailsViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumDetailsViewModelProvider && other.albumId == albumId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, albumId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AlbumDetailsViewModelRef on AutoDisposeFutureProviderRef<AlbumDetails> {
  /// The parameter `albumId` of this provider.
  int get albumId;
}

class _AlbumDetailsViewModelProviderElement
    extends AutoDisposeFutureProviderElement<AlbumDetails>
    with AlbumDetailsViewModelRef {
  _AlbumDetailsViewModelProviderElement(super.provider);

  @override
  int get albumId => (origin as AlbumDetailsViewModelProvider).albumId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
