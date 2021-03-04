// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protein_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProteinEntityAdapter extends TypeAdapter<ProteinEntity> {
  @override
  ProteinEntity read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProteinEntity(
      id: fields[0] as String,
      name: fields[1] as String,
      amount: fields[2] as int,
      date: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProteinEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get typeId => 1;
}
