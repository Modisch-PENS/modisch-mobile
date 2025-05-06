import 'package:Modisch/core/database/models/wardrobe_database.dart';
import 'package:Modisch/features/wardrobe/riverpod/dummy_assets_provider.dart';

/// A wrapper class that can represent either a real user item or a dummy asset
class WardrobeItem {
  final bool isUserItem;
  final ClothingModel? clothingModel;
  final String? dummyAssetPath;

  /// Create a WardrobeItem from a user's real ClothingModel
  WardrobeItem.fromUserItem(this.clothingModel)
      : isUserItem = true,
        dummyAssetPath = null;

  /// Create a WardrobeItem from a dummy asset path
  WardrobeItem.fromDummyAsset(this.dummyAssetPath)
      : isUserItem = false,
        clothingModel = null;

  /// Get the display name for this item
  String get displayName {
    if (isUserItem) {
      return clothingModel!.name;
    } else {
      return DummyAssetsNotifier.getDisplayName(dummyAssetPath!);
    }
  }
}