// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appThemeHash() => r'06783ae11048fec8eb3f2f5848ed61a03a23a96a';

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
    r'1e6593a91893fc9454fbdc87c97270edada9153d';

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
