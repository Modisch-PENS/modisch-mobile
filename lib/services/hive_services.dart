import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modisch/models/clothing_item.dart';

class HiveServices {
  static const String boxName = 'clothingBox';

  static Future<void> init() async{
    await Hive.initFlutter();
    Hive.registerAdapter(ClothingItemAdapter());
    await Hive.openBox<ClothingItem>(boxName);
  }

  static Future<void> addDummyData() async{
    var box = Hive.box<ClothingItem>(boxName);
    final items = [
      ClothingItem(
          name: 'Kemeja Hitam', 
          category: 'Shirt', 
          imagePath: 'assets/clothes/shirt/shirt_black.webp'
        ),
        ClothingItem(
          name: 'Jas Lab', 
          category: 'Shirt', 
          imagePath: 'assets/clothes/shirt/shirt_jaslab.png'
        ),
        ClothingItem(
          name: 'Kemeja Putih', 
          category: 'Shirt', 
          imagePath: 'assets/clothes/shirt/shirt_white.png'
        ),
        ClothingItem(
          name: 'Jeans Biru', 
          category: 'Pants', 
          imagePath: 'assets/clothes/pants/pants_bluejeans.webp'
        ),
        ClothingItem(
          name: 'Adidas Dress', 
          category: 'Dress', 
          imagePath: 'assets/clothes/dress/dress_adidas.png'
        ),
        ClothingItem(
          name: 'Air Force 1 White', 
          category: 'Shoes', 
          imagePath: 'assets/clothes/shoes/shoes_white.webp'
        )
      ];
    await box.addAll(items);
  }

  static List<ClothingItem> getByCategory(String category){
    final box = Hive.box<ClothingItem>(boxName);
    return box.values.where((item) => item.category == category).toList();
  } 
}