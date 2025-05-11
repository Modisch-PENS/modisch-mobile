// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wardrobe_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clothingByCategoryHash() =>
    r'27a7d80f68b487d45d7f824caa313e451dbf6256';

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

/// See also [clothingByCategory].
@ProviderFor(clothingByCategory)
const clothingByCategoryProvider = ClothingByCategoryFamily();

/// See also [clothingByCategory].
class ClothingByCategoryFamily extends Family<List<ClothingModel>> {
  /// See also [clothingByCategory].
  const ClothingByCategoryFamily();

  /// See also [clothingByCategory].
  ClothingByCategoryProvider call(
    String category,
  ) {
    return ClothingByCategoryProvider(
      category,
    );
  }

  @override
  ClothingByCategoryProvider getProviderOverride(
    covariant ClothingByCategoryProvider provider,
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
  String? get name => r'clothingByCategoryProvider';
}

/// See also [clothingByCategory].
class ClothingByCategoryProvider
    extends AutoDisposeProvider<List<ClothingModel>> {
  /// See also [clothingByCategory].
  ClothingByCategoryProvider(
    String category,
  ) : this._internal(
          (ref) => clothingByCategory(
            ref as ClothingByCategoryRef,
            category,
          ),
          from: clothingByCategoryProvider,
          name: r'clothingByCategoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$clothingByCategoryHash,
          dependencies: ClothingByCategoryFamily._dependencies,
          allTransitiveDependencies:
              ClothingByCategoryFamily._allTransitiveDependencies,
          category: category,
        );

  ClothingByCategoryProvider._internal(
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
    List<ClothingModel> Function(ClothingByCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ClothingByCategoryProvider._internal(
        (ref) => create(ref as ClothingByCategoryRef),
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
  AutoDisposeProviderElement<List<ClothingModel>> createElement() {
    return _ClothingByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ClothingByCategoryProvider && other.category == category;
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
mixin ClothingByCategoryRef on AutoDisposeProviderRef<List<ClothingModel>> {
  /// The parameter `category` of this provider.
  String get category;
}

class _ClothingByCategoryProviderElement
    extends AutoDisposeProviderElement<List<ClothingModel>>
    with ClothingByCategoryRef {
  _ClothingByCategoryProviderElement(super.provider);

  @override
  String get category => (origin as ClothingByCategoryProvider).category;
}

String _$recentClothingHash() => r'ea1d2f340475350fd160e44d8df9e869a099798c';

/// See also [recentClothing].
@ProviderFor(recentClothing)
const recentClothingProvider = RecentClothingFamily();

/// See also [recentClothing].
class RecentClothingFamily extends Family<List<ClothingModel>> {
  /// See also [recentClothing].
  const RecentClothingFamily();

  /// See also [recentClothing].
  RecentClothingProvider call({
    int limit = 10,
  }) {
    return RecentClothingProvider(
      limit: limit,
    );
  }

  @override
  RecentClothingProvider getProviderOverride(
    covariant RecentClothingProvider provider,
  ) {
    return call(
      limit: provider.limit,
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
  String? get name => r'recentClothingProvider';
}

/// See also [recentClothing].
class RecentClothingProvider extends AutoDisposeProvider<List<ClothingModel>> {
  /// See also [recentClothing].
  RecentClothingProvider({
    int limit = 10,
  }) : this._internal(
          (ref) => recentClothing(
            ref as RecentClothingRef,
            limit: limit,
          ),
          from: recentClothingProvider,
          name: r'recentClothingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recentClothingHash,
          dependencies: RecentClothingFamily._dependencies,
          allTransitiveDependencies:
              RecentClothingFamily._allTransitiveDependencies,
          limit: limit,
        );

  RecentClothingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.limit,
  }) : super.internal();

  final int limit;

  @override
  Override overrideWith(
    List<ClothingModel> Function(RecentClothingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecentClothingProvider._internal(
        (ref) => create(ref as RecentClothingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        limit: limit,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<ClothingModel>> createElement() {
    return _RecentClothingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentClothingProvider && other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecentClothingRef on AutoDisposeProviderRef<List<ClothingModel>> {
  /// The parameter `limit` of this provider.
  int get limit;
}

class _RecentClothingProviderElement
    extends AutoDisposeProviderElement<List<ClothingModel>>
    with RecentClothingRef {
  _RecentClothingProviderElement(super.provider);

  @override
  int get limit => (origin as RecentClothingProvider).limit;
}

String _$wardrobeNotifierHash() => r'a2e849e1317cc2cb6db604913400ee18b942561d';

/// See also [WardrobeNotifier].
@ProviderFor(WardrobeNotifier)
final wardrobeNotifierProvider = AutoDisposeAsyncNotifierProvider<
    WardrobeNotifier, List<ClothingModel>>.internal(
  WardrobeNotifier.new,
  name: r'wardrobeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wardrobeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WardrobeNotifier = AutoDisposeAsyncNotifier<List<ClothingModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
