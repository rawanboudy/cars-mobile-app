// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sell_request.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SellRequestAdapter extends TypeAdapter<SellRequest> {
  @override
  final int typeId = 0;

  @override
  SellRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SellRequest(
      brand: fields[0] as String,
      model: fields[1] as String,
      year: fields[2] as String,
      condition: fields[3] as String,
      fuelType: fields[4] as String,
      transmission: fields[5] as String,
      price: fields[6] as String,
      mileage: fields[7] as String,
      description: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SellRequest obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.brand)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.year)
      ..writeByte(3)
      ..write(obj.condition)
      ..writeByte(4)
      ..write(obj.fuelType)
      ..writeByte(5)
      ..write(obj.transmission)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.mileage)
      ..writeByte(8)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SellRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
