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

  ClothingModel({
    required this.id,
    required this.category,
    required this.imagePath,
  });
}
