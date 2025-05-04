// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dummy_assets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dummyAssetsByCategoryHash() =>
    r'861d22d22aff4528ce27e64c7ed77c1b2c8356bf';

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

/// See also [dummyAssetsByCategory].
@ProviderFor(dummyAssetsByCategory)
const dummyAssetsByCategoryProvider = DummyAssetsByCategoryFamily();

/// See also [dummyAssetsByCategory].
class DummyAssetsByCategoryFamily extends Family<List<String>> {
  /// See also [dummyAssetsByCategory].
  const DummyAssetsByCategoryFamily();

  /// See also [dummyAssetsByCategory].
  DummyAssetsByCategoryProvider call(
    String category,
  ) {
    return DummyAssetsByCategoryProvider(
      category,
    );
  }

  @override
  DummyAssetsByCategoryProvider getProviderOverride(
    covariant DummyAssetsByCategoryProvider provider,
  ) {
    return call(
      provider.category,
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
  String? get name => r'dummyAssetsByCategoryProvider';
}

/// See also [dummyAssetsByCategory].
class DummyAssetsByCategoryProvider extends AutoDisposeProvider<List<String>> {
  /// See also [dummyAssetsByCategory].
  DummyAssetsByCategoryProvider(
    String category,
  ) : this._internal(
          (ref) => dummyAssetsByCategory(
            ref as DummyAssetsByCategoryRef,
            category,
          ),
          from: dummyAssetsByCategoryProvider,
          name: r'dummyAssetsByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dummyAssetsByCategoryHash,
          dependencies: DummyAssetsByCategoryFamily._dependencies,
          allTransitiveDependencies:
              DummyAssetsByCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  DummyAssetsByCategoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.category,
  }) : super.internal();

  final String category;

  @override
  Override overrideWith(
    List<String> Function(DummyAssetsByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DummyAssetsByCategoryProvider._internal(
        (ref) => create(ref as DummyAssetsByCategoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        category: category,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<String>> createElement() {
    return _DummyAssetsByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DummyAssetsByCategoryProvider && other.category == category;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, category.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DummyAssetsByCategoryRef on AutoDisposeProviderRef<List<String>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _DummyAssetsByCategoryProviderElement
    extends AutoDisposeProviderElement<List<String>>
    with DummyAssetsByCategoryRef {
  _DummyAssetsByCategoryProviderElement(super.provider);

  @override
  String get category => (origin as DummyAssetsByCategoryProvider).category;
}

String _$dummyAssetsNotifierHash() =>
    r'1764e7901e26de7b2286745d074175a11459950b';

/// See also [DummyAssetsNotifier].
@ProviderFor(DummyAssetsNotifier)
final dummyAssetsNotifierProvider = AutoDisposeNotifierProvider<
    DummyAssetsNotifier, Map<String, List<String>>>.internal(
  DummyAssetsNotifier.new,
  name: r'dummyAssetsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dummyAssetsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DummyAssetsNotifier = AutoDisposeNotifier<Map<String, List<String>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
