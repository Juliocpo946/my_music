// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_details_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$genreDetailsViewModelHash() =>
    r'702a7323220bc9f7d1198365419e7380ef2c4cc2';

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

/// See also [genreDetailsViewModel].
@ProviderFor(genreDetailsViewModel)
const genreDetailsViewModelProvider = GenreDetailsViewModelFamily();

/// See also [genreDetailsViewModel].
class GenreDetailsViewModelFamily extends Family<AsyncValue<GenreDetailsData>> {
  /// See also [genreDetailsViewModel].
  const GenreDetailsViewModelFamily();

  /// See also [genreDetailsViewModel].
  GenreDetailsViewModelProvider call(
    String genreName,
  ) {
    return GenreDetailsViewModelProvider(
      genreName,
    );
  }

  @override
  GenreDetailsViewModelProvider getProviderOverride(
    covariant GenreDetailsViewModelProvider provider,
  ) {
    return call(
      provider.genreName,
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
  String? get name => r'genreDetailsViewModelProvider';
}

/// See also [genreDetailsViewModel].
class GenreDetailsViewModelProvider
    extends AutoDisposeFutureProvider<GenreDetailsData> {
  /// See also [genreDetailsViewModel].
  GenreDetailsViewModelProvider(
    String genreName,
  ) : this._internal(
          (ref) => genreDetailsViewModel(
            ref as GenreDetailsViewModelRef,
            genreName,
          ),
          from: genreDetailsViewModelProvider,
          name: r'genreDetailsViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genreDetailsViewModelHash,
          dependencies: GenreDetailsViewModelFamily._dependencies,
          allTransitiveDependencies:
              GenreDetailsViewModelFamily._allTransitiveDependencies,
          genreName: genreName,
        );

  GenreDetailsViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.genreName,
  }) : super.internal();

  final String genreName;

  @override
  Override overrideWith(
    FutureOr<GenreDetailsData> Function(GenreDetailsViewModelRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GenreDetailsViewModelProvider._internal(
        (ref) => create(ref as GenreDetailsViewModelRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        genreName: genreName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<GenreDetailsData> createElement() {
    return _GenreDetailsViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GenreDetailsViewModelProvider &&
        other.genreName == genreName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, genreName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GenreDetailsViewModelRef
    on AutoDisposeFutureProviderRef<GenreDetailsData> {
  /// The parameter `genreName` of this provider.
  String get genreName;
}

class _GenreDetailsViewModelProviderElement
    extends AutoDisposeFutureProviderElement<GenreDetailsData>
    with GenreDetailsViewModelRef {
  _GenreDetailsViewModelProviderElement(super.provider);

  @override
  String get genreName => (origin as GenreDetailsViewModelProvider).genreName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
