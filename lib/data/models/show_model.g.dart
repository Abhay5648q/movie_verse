// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShowAdapter extends TypeAdapter<Show> {
  @override
  final int typeId = 0;

  @override
  Show read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Show(
      id: fields[0] as int,
      name: fields[1] as String,
      image: fields[2] as String?,
      rating: fields[3] as double?,
      summary: fields[4] as String,
      genres: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Show obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.rating)
      ..writeByte(4)
      ..write(obj.summary)
      ..writeByte(5)
      ..write(obj.genres);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
