import 'package:hive/hive.dart';
import 'wardrobe_database.dart';

part 'model_database.g.dart';

@HiveType(typeId: 1)
class ModelClothing extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? shirtId;

  @HiveField(2)
  final String? pantsId;

  @HiveField(3)
  final String? dressId;

  @HiveField(4)
  final String? shoesId;

  @HiveField(5)
  final DateTime createdAt;

  ModelClothing({
    required this.id,
    this.shirtId,
    this.pantsId,
    this.dressId,
    this.shoesId,
    required this.createdAt,
  });

  bool get isDressMode => dressId != null;
}
