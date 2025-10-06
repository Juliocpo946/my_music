// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lyricsHash() => r'5a5d4b6ea9ec0ee401c4dba70b00d9445f862026';

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

/// See also [lyrics].
@ProviderFor(lyrics)
const lyricsProvider = LyricsFamily();

/// See also [lyrics].
class LyricsFamily extends Family<AsyncValue<String>> {
  /// See also [lyrics].
  const LyricsFamily();

  /// See also [lyrics].
  LyricsProvider call({
    required String artist,
    required String track,
  }) {
    return LyricsProvider(
      artist: artist,
      track: track,
    );
  }

  @override
  LyricsProvider getProviderOverride(
    covariant LyricsProvider provider,
  ) {
    return call(
      artist: provider.artist,
      track: provider.track,
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
  String? get name => r'lyricsProvider';
}

/// See also [lyrics].
class LyricsProvider extends AutoDisposeFutureProvider<String> {
  /// See also [lyrics].
  LyricsProvider({
    required String artist,
    required String track,
  }) : this._internal(
          (ref) => lyrics(
            ref as LyricsRef,
            artist: artist,
            track: track,
          ),
          from: lyricsProvider,
          name: r'lyricsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lyricsHash,
          dependencies: LyricsFamily._dependencies,
          allTransitiveDependencies: LyricsFamily._allTransitiveDependencies,
          artist: artist,
          track: track,
        );

  LyricsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.artist,
    required this.track,
  }) : super.internal();

  final String artist;
  final String track;

  @override
  Override overrideWith(
    FutureOr<String> Function(LyricsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LyricsProvider._internal(
        (ref) => create(ref as LyricsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        artist: artist,
        track: track,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _LyricsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LyricsProvider &&
        other.artist == artist &&
        other.track == track;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, artist.hashCode);
    hash = _SystemHash.combine(hash, track.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LyricsRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `artist` of this provider.
  String get artist;

  /// The parameter `track` of this provider.
  String get track;
}

class _LyricsProviderElement extends AutoDisposeFutureProviderElement<String>
    with LyricsRef {
  _LyricsProviderElement(super.provider);

  @override
  String get artist => (origin as LyricsProvider).artist;
  @override
  String get track => (origin as LyricsProvider).track;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
