// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outfit_model_database.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OutfitModelAdapter extends TypeAdapter<OutfitModel> {
  @override
  final int typeId = 1;

  @override
  OutfitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OutfitModel(
      id: fields[0] as String,
      name: fields[1] as String,
      shirt: fields[2] as String?,
      pants: fields[3] as String?,
      dress: fields[4] as String?,
      shoes: fields[5] as String?,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, OutfitModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.shirt)
      ..writeByte(3)
      ..write(obj.pants)
      ..writeByte(4)
      ..write(obj.dress)
      ..writeByte(5)
      ..write(obj.shoes)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutfitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
