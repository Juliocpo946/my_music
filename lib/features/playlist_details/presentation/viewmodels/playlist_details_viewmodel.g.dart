// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_details_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playlistDetailsViewModelHash() =>
    r'35551e1a96647f09ec61d591a9532757a45db71c';

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

/// See also [playlistDetailsViewModel].
@ProviderFor(playlistDetailsViewModel)
const playlistDetailsViewModelProvider = PlaylistDetailsViewModelFamily();

/// See also [playlistDetailsViewModel].
class PlaylistDetailsViewModelFamily
    extends Family<AsyncValue<PlaylistDetails>> {
  /// See also [playlistDetailsViewModel].
  const PlaylistDetailsViewModelFamily();

  /// See also [playlistDetailsViewModel].
  PlaylistDetailsViewModelProvider call(
    int playlistId,
  ) {
    return PlaylistDetailsViewModelProvider(
      playlistId,
    );
  }

  @override
  PlaylistDetailsViewModelProvider getProviderOverride(
    covariant PlaylistDetailsViewModelProvider provider,
  ) {
    return call(
      provider.playlistId,
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
  String? get name => r'playlistDetailsViewModelProvider';
}

/// See also [playlistDetailsViewModel].
class PlaylistDetailsViewModelProvider
    extends AutoDisposeFutureProvider<PlaylistDetails> {
  /// See also [playlistDetailsViewModel].
  PlaylistDetailsViewModelProvider(
    int playlistId,
  ) : this._internal(
          (ref) => playlistDetailsViewModel(
            ref as PlaylistDetailsViewModelRef,
            playlistId,
          ),
          from: playlistDetailsViewModelProvider,
          name: r'playlistDetailsViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$playlistDetailsViewModelHash,
          dependencies: PlaylistDetailsViewModelFamily._dependencies,
          allTransitiveDependencies:
              PlaylistDetailsViewModelFamily._allTransitiveDependencies,
          playlistId: playlistId,
        );

  PlaylistDetailsViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.playlistId,
  }) : super.internal();

  final int playlistId;

  @override
  Override overrideWith(
    FutureOr<PlaylistDetails> Function(PlaylistDetailsViewModelRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlaylistDetailsViewModelProvider._internal(
        (ref) => create(ref as PlaylistDetailsViewModelRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        playlistId: playlistId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PlaylistDetails> createElement() {
    return _PlaylistDetailsViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistDetailsViewModelProvider &&
        other.playlistId == playlistId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, playlistId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlaylistDetailsViewModelRef
    on AutoDisposeFutureProviderRef<PlaylistDetails> {
  /// The parameter `playlistId` of this provider.
  int get playlistId;
}

class _PlaylistDetailsViewModelProviderElement
    extends AutoDisposeFutureProviderElement<PlaylistDetails>
    with PlaylistDetailsViewModelRef {
  _PlaylistDetailsViewModelProviderElement(super.provider);

  @override
  int get playlistId => (origin as PlaylistDetailsViewModelProvider).playlistId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
