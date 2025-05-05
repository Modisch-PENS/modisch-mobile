import 'package:hive/hive.dart';
import 'package:modisch/core/database/models/wardrobe_database.dart';

class WardrobeService {
  final Box _wardrobeBox = Hive.box('wardrobe');

  // Create (Add)
  Future<void> addClothing(ClothingModel clothing) async {
    await _wardrobeBox.add(clothing);
  }

  // Read (Get All)
  List<ClothingModel> getAllClothing() {
    return _wardrobeBox.values.toList().cast<ClothingModel>();
  }

  // Update
  Future<void> updateClothing(ClothingModel clothing) async {
    await clothing.save();
  }

  // Delete
  Future<void> deleteClothing(ClothingModel clothing) async {
    await clothing.delete();
  }
}
