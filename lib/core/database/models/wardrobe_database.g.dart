// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wardrobe_database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClothingModelAdapter extends TypeAdapter<ClothingModel> {
  @override
  final int typeId = 0;

  @override
  ClothingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClothingModel(
      id: fields[0] as String,
      category: fields[1] as String,
      imagePath: fields[2] as String,
      name: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClothingModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClothingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
