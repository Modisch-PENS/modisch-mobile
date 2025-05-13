import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dummy_assets_provider.g.dart';

class CategoryAssets {
  final String category;
  final List<String> assetPaths;

  CategoryAssets({required this.category, required this.assetPaths});
}

@riverpod
class DummyAssetsNotifier extends _$DummyAssetsNotifier {
  @override
  Map<String, List<String>> build() {
    return {
      'Shirt': _getShirtAssets(),
      'Pants': _getPantsAssets(),
      'Dress': _getDressAssets(),
      'Shoes': _getShoesAssets(),
    };
  }

  List<String> _getShirtAssets() {
    return [
      'assets/clothes/shirt/shirt_beige.webp',
      'assets/clothes/shirt/shirt_black.webp',
      'assets/clothes/shirt/shirt_blackplain.webp',
      'assets/clothes/shirt/shirt_jaslab.webp',
      'assets/clothes/shirt/shirt_lightblue.webp',
      'assets/clothes/shirt/shirt_plaid.webp',
      'assets/clothes/shirt/shirt_white.webp',
      'assets/clothes/shirt/shirt_whiteplain.webp',
    ];
  }

  List<String> _getPantsAssets() {
    return [
      'assets/clothes/pants/pants_beige.webp',
      'assets/clothes/pants/pants_blackjeans.webp',
      'assets/clothes/pants/pants_blackloose.webp',
      'assets/clothes/pants/pants_bluejeans.webp',
      'assets/clothes/pants/pants_green.webp',
      'assets/clothes/pants/pants_grey.webp',
      'assets/clothes/pants/pants_jeans.webp',
      'assets/clothes/pants/pants_skinnyjeans.webp',
    ];
  }

  List<String> _getDressAssets() {
    return [
      'assets/clothes/dress/dress_adidas.webp',
      'assets/clothes/dress/dress_blackshort.webp',
      'assets/clothes/dress/dress_blue.webp',
      'assets/clothes/dress/dress_green.webp',
      'assets/clothes/dress/dress_longblack.webp',
      'assets/clothes/dress/dress_red.webp',
      'assets/clothes/dress/dress_white.webp',
    ];
  }

  List<String> _getShoesAssets() {
    return [
      'assets/clothes/shoes/shoes_asics.webp',
      'assets/clothes/shoes/shoes_black.webp',
      'assets/clothes/shoes/shoes_boots.webp',
      'assets/clothes/shoes/shoes_converse.webp',
      'assets/clothes/shoes/shoes_loafers.webp',
      'assets/clothes/shoes/shoes_onitsuka.webp',
      'assets/clothes/shoes/shoes_white.webp',
    ];
  }

  // Get assets for a specific category
  List<String> getAssetsForCategory(String category) {
    return state[category] ?? [];
  }

  // Get the name without category prefix
  static String getDisplayName(String assetPath) {
    // Extract filename from path
    final fileName = assetPath.split('/').last;
    
    // Remove extension
    final nameWithoutExtension = fileName.split('.').first;
    
    // Remove category prefix (first word and underscore)
    final parts = nameWithoutExtension.split('_');
    if (parts.length > 1) {
      return parts.sublist(1).join(' ');
    }
    
    return nameWithoutExtension;
  }
}

// Provider to get dummy assets for a specific category
@riverpod
List<String> dummyAssetsByCategory(DummyAssetsByCategoryRef ref, String category) {
  final assetProvider = ref.watch(dummyAssetsNotifierProvider);

  // Special case for 'All' category - return all assets from all categories
  if (category == 'All') {
    return assetProvider.values.expand((list) => list).toList();
  }

  // Otherwise return assets for the specific category
  return assetProvider[category] ?? [];
}