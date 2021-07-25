// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sources.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SourcesAdapter extends TypeAdapter<Sources> {
  @override
  final int typeId = 1;

  @override
  Sources read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sources(
      sources: (fields[0] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Sources obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.sources);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SourcesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
