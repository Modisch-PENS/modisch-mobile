// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModelClothingAdapter extends TypeAdapter<ModelClothing> {
  @override
  final int typeId = 1;

  @override
  ModelClothing read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModelClothing(
      id: fields[0] as String,
      shirtId: fields[1] as String?,
      pantsId: fields[2] as String?,
      dressId: fields[3] as String?,
      shoesId: fields[4] as String?,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ModelClothing obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.shirtId)
      ..writeByte(2)
      ..write(obj.pantsId)
      ..writeByte(3)
      ..write(obj.dressId)
      ..writeByte(4)
      ..write(obj.shoesId)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelClothingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
