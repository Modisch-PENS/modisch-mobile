import 'package:hive_flutter/hive_flutter.dart';
import 'package:Modisch/core/database/models/outfit_model_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'outfit_provider.g.dart';

@riverpod
class OutfitNotifier extends _$OutfitNotifier {
  late Box<OutfitModel> _outfitBox;
  
  @override
  Future<List<OutfitModel>> build() async {
    _outfitBox = Hive.box<OutfitModel>('outfits');
    return _outfitBox.values.toList();
  }
  
  // Add a new outfit
  Future<void> addOutfit({
    required String name,
    String? shirt,
    String? pants,
    String? dress,
    String? shoes,
  }) async {
    final id = const Uuid().v4();
    final outfit = OutfitModel(
      id: id,
      name: name,
      shirt: shirt,
      pants: pants,
      dress: dress,
      shoes: shoes,
      createdAt: DateTime.now(),
    );
    
    // Save to Hive
    await _outfitBox.put(id, outfit);
    
    // Update state
    state = AsyncData([..._outfitBox.values.toList()]);
  }
  
  // Delete an outfit
  Future<void> deleteOutfit(String id) async {
    await _outfitBox.delete(id);
    
    // Update state
    state = AsyncData([..._outfitBox.values.toList()]);
  }
  
  // Update an outfit
  Future<void> updateOutfit(OutfitModel outfit) async {
    await _outfitBox.put(outfit.id, outfit);
    
    // Update state
    state = AsyncData([..._outfitBox.values.toList()]);
  }
  
  // Get recent outfits
  List<OutfitModel> getRecentOutfits({int limit = 5}) {
    if (state.value == null) return [];
    final sortedOutfits = [...state.value!];
    sortedOutfits.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedOutfits.take(limit).toList();
  }
}

// Provider for editing an outfit
@riverpod
class OutfitEditorNotifier extends _$OutfitEditorNotifier {
  @override
  OutfitModel build() {
    return OutfitModel.empty();
  }
  
  void setName(String name) {
    state = state.copyWith(name: name);
  }
  
  void setShirt(String? shirt) {
    // If selecting a shirt, remove any dress (they're mutually exclusive)
    if (shirt != null) {
      state = state.copyWith(shirt: shirt, dress: null);
    } else {
      state = state.copyWith(shirt: shirt);
    }
  }
  
  void setPants(String? pants) {
    state = state.copyWith(pants: pants);
  }
  
  void setDress(String? dress) {
    // If selecting a dress, remove any shirt (they're mutually exclusive)
    if (dress != null) {
      state = state.copyWith(dress: dress, shirt: null);
    } else {
      state = state.copyWith(dress: dress);
    }
  }
  
  void setShoes(String? shoes) {
    state = state.copyWith(shoes: shoes);
  }
  
  // Reset the editor
  void reset() {
    state = OutfitModel.empty();
  }
  
  // Load an existing outfit for editing
  void loadOutfit(OutfitModel outfit) {
    state = outfit;
  }
  
  // Validation check for tops (dress and shirt are mutually exclusive)
  String? validateTopSelection({required String target}) {
    if (target == 'shirt' && state.dress != null) {
      return 'You already have a dress selected. Please remove it before adding a shirt.';
    }
    if (target == 'dress' && state.shirt != null) {
      return 'You already have a shirt selected. Please remove it before adding a dress.';
    }
    return null;
  }
  
  // Check if the outfit is ready to save (has at least one item)
  bool get isReadyToSave {
    return state.shirt != null || state.pants != null || 
           state.dress != null || state.shoes != null;
  }
  
  // Check if the outfit has a valid name
  bool isNameValid(String name) {
    return name.trim().isNotEmpty;
  }
}