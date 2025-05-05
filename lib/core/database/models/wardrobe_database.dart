import 'package:hive/hive.dart';

part 'wardrobe_database.g.dart';

@HiveType(typeId: 0)
class ClothingModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String category;
  
  @HiveField(2)
  final String imagePath;
  
  @HiveField(3)
  final String name;

  ClothingModel({
    required this.id,
    required this.category,
    required this.imagePath,
    required this.name,
  });
  
  ClothingModel copyWith({
    String? id,
    String? category,
    String? imagePath,
    String? name,
  }) {
    return ClothingModel(
      id: id ?? this.id,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
    );
  }
}