// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodEntityAdapter extends TypeAdapter<FoodEntity> {
  @override
  FoodEntity read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodEntity(
      id: fields[0] as String,
      name: fields[1] as String,
      proteinAmount: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FoodEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.proteinAmount);
  }

  @override
  // TODO: implement typeId
  int get typeId => 2;
}
