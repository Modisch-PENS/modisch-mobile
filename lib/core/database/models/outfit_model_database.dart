import 'package:hive/hive.dart';

part 'outfit_model_database.g.dart';

@HiveType(typeId: 1)
class OutfitModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String? shirt;
  
  @HiveField(3)
  final String? pants;
  
  @HiveField(4)
  final String? dress;
  
  @HiveField(5)
  final String? shoes;
  
  @HiveField(6)
  final DateTime createdAt;

  OutfitModel({
    required this.id,
    required this.name,
    this.shirt,
    this.pants,
    this.dress,
    this.shoes,
    required this.createdAt,
  });
  
  // Create a copy of this model with updated fields
  OutfitModel copyWith({
    String? id,
    String? name,
    String? shirt,
    String? pants,
    String? dress,
    String? shoes,
    DateTime? createdAt,
  }) {
    return OutfitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      shirt: shirt ?? this.shirt,
      pants: pants ?? this.pants,
      dress: dress ?? this.dress,
      shoes: shoes ?? this.shoes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  // Create empty model
  factory OutfitModel.empty() {
    return OutfitModel(
      id: '',
      name: '',
      shirt: null,
      pants: null,
      dress: null,
      shoes: null,
      createdAt: DateTime.now(),
    );
  }
}