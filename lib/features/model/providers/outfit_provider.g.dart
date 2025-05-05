// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outfit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$outfitNotifierHash() => r'c780e4099a194136c8ebe1e3b4f8fa185be21338';

/// See also [OutfitNotifier].
@ProviderFor(OutfitNotifier)
final outfitNotifierProvider = AutoDisposeAsyncNotifierProvider<OutfitNotifier,
    List<OutfitModel>>.internal(
  OutfitNotifier.new,
  name: r'outfitNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$outfitNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OutfitNotifier = AutoDisposeAsyncNotifier<List<OutfitModel>>;
String _$outfitEditorNotifierHash() =>
    r'0712eab19d76d6de44a09e5a351d9636f9cff8bd';

/// See also [OutfitEditorNotifier].
@ProviderFor(OutfitEditorNotifier)
final outfitEditorNotifierProvider =
    AutoDisposeNotifierProvider<OutfitEditorNotifier, OutfitModel>.internal(
  OutfitEditorNotifier.new,
  name: r'outfitEditorNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$outfitEditorNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OutfitEditorNotifier = AutoDisposeNotifier<OutfitModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
