// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealRecordModelAdapter extends TypeAdapter<MealRecordModel> {
  @override
  final int typeId = 1;

  @override
  MealRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealRecordModel(
      label: fields[0] as String,
      checked: fields[1] == null ? false : fields[1] as bool,
      photoPath: fields[2] as String?,
      photoTimestamp: fields[3] as String?,
      aiStatus: fields[4] as String?,
      aiFeedback: fields[5] as String?,
      mealTime: fields[6] as String?,
      foodText: fields[7] as String?,
      recordedAt: fields[8] as String?,
      skipped: fields[9] == null ? false : fields[9] as bool,
      eatenAt: fields[10] as String?,
      guideText: fields[11] as String?,
      skipReason: fields[12] as String?,
      lateReason: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MealRecordModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.checked)
      ..writeByte(2)
      ..write(obj.photoPath)
      ..writeByte(3)
      ..write(obj.photoTimestamp)
      ..writeByte(4)
      ..write(obj.aiStatus)
      ..writeByte(5)
      ..write(obj.aiFeedback)
      ..writeByte(6)
      ..write(obj.mealTime)
      ..writeByte(7)
      ..write(obj.foodText)
      ..writeByte(8)
      ..write(obj.recordedAt)
      ..writeByte(9)
      ..write(obj.skipped)
      ..writeByte(10)
      ..write(obj.eatenAt)
      ..writeByte(11)
      ..write(obj.guideText)
      ..writeByte(12)
      ..write(obj.skipReason)
      ..writeByte(13)
      ..write(obj.lateReason);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
