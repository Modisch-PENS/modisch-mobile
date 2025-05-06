import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:Modisch/core/database/models/wardrobe_database.dart';

part 'wardrobe_provider.g.dart';

@riverpod
class WardrobeNotifier extends _$WardrobeNotifier {
  late Box<ClothingModel> _clothingBox;

  @override
  Future<List<ClothingModel>> build() async {
    _clothingBox = Hive.box<ClothingModel>('clothing');
    return _clothingBox.values.toList();
  }

  // Add a new clothing item
  Future<void> addClothingItem({
    required String id,
    required String category,
    required String imagePath,
    required String name,
  }) async {
    // Create model
    final model = ClothingModel(
      id: id,
      category: category,
      imagePath: imagePath,
      name: name,
    );

    // Save to Hive
    await _clothingBox.put(id, model);

    // Update state
    state = AsyncData([..._clothingBox.values.toList()]);
  }

  // Update a clothing item
  Future<void> updateClothingItem(ClothingModel item) async {
    // Save to Hive
    await _clothingBox.put(item.id, item);

    // Update state
    state = AsyncData([..._clothingBox.values.toList()]);
  }

  // Delete clothing item
  Future<void> deleteClothingItem(String id) async {
    final item = _clothingBox.get(id);

    // Delete file if it exists
    if (item != null) {
      final file = File(item.imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    }

    // Remove from Hive
    await _clothingBox.delete(id);

    // Update state
    state = AsyncData([..._clothingBox.values.toList()]);
  }

  // Get items by category
  List<ClothingModel> getItemsByCategory(String category) {
    if (state.value == null) return [];
    return state.value!.where((item) => item.category == category).toList();
  }

  // Get recently added items
  List<ClothingModel> getRecentItems({int limit = 10}) {
    if (state.value == null) return [];
    // Sort by ID (assumes ID contains timestamp)
    final sortedItems = [...state.value!];
    sortedItems.sort((a, b) => b.id.compareTo(a.id)); // Most recent first
    return sortedItems.take(limit).toList();
  }
}

// Filtered clothing provider
@riverpod
List<ClothingModel> clothingByCategory(
  ClothingByCategoryRef ref,
  String category,
) {
  final wardrobeState = ref.watch(wardrobeNotifierProvider);
  return wardrobeState.when(
    data: (items) => items.where((item) => item.category == category).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
}

// Recent clothing provider
@riverpod
List<ClothingModel> recentClothing(RecentClothingRef ref, {int limit = 10}) {
  final wardrobeState = ref.watch(wardrobeNotifierProvider);
  return wardrobeState.when(
    data: (items) {
      final sortedItems = [...items];
      sortedItems.sort((a, b) => b.id.compareTo(a.id)); // Most recent first
      return sortedItems.take(limit).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
}
