// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hiddenTracksHash() => r'd1d9a7e1cc4021d5e5c535b2095ab4021e555534';

/// See also [hiddenTracks].
@ProviderFor(hiddenTracks)
final hiddenTracksProvider = AutoDisposeFutureProvider<List<Track>>.internal(
  hiddenTracks,
  name: r'hiddenTracksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$hiddenTracksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HiddenTracksRef = AutoDisposeFutureProviderRef<List<Track>>;
String _$libraryViewModelHash() => r'b518504f5652c5b5a0f1c630ed683df7305aa90f';

/// See also [LibraryViewModel].
@ProviderFor(LibraryViewModel)
final libraryViewModelProvider =
    AutoDisposeAsyncNotifierProvider<LibraryViewModel, LibraryState>.internal(
  LibraryViewModel.new,
  name: r'libraryViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$libraryViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LibraryViewModel = AutoDisposeAsyncNotifier<LibraryState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
