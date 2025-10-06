// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appThemeHash() => r'3da9f046c13e1e800b892b087be81c62bbdcfcc4';

/// See also [appTheme].
@ProviderFor(appTheme)
final appThemeProvider = AutoDisposeProvider<ThemeData>.internal(
  appTheme,
  name: r'appThemeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appThemeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppThemeRef = AutoDisposeProviderRef<ThemeData>;
String _$accentColorNotifierHash() =>
    r'93cad485e3335f48fe48be0627ba946d3b365fdc';

/// See also [AccentColorNotifier].
@ProviderFor(AccentColorNotifier)
final accentColorNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AccentColorNotifier, Color>.internal(
  AccentColorNotifier.new,
  name: r'accentColorNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$accentColorNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AccentColorNotifier = AutoDisposeAsyncNotifier<Color>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
