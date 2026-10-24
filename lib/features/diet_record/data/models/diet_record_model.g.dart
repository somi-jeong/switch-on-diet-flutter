// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DietRecordModelAdapter extends TypeAdapter<DietRecordModel> {
  @override
  final int typeId = 0;

  @override
  DietRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DietRecordModel(
      date: fields[0] as String,
      wakeTime: fields[1] as String?,
      meals: fields[2] == null
          ? []
          : (fields[2] as List).cast<MealRecordModel>(),
      weight: fields[3] as double?,
      bodyFat: fields[4] as double?,
      diary: fields[5] as String?,
      aiFeedback: fields[6] as String?,
      weeklySummary: fields[7] as String?,
      confession: fields[8] as String?,
      confessionFeedback: fields[9] as String?,
      bedTime: fields[10] as String?,
      warningCount: fields[11] == null ? 0 : fields[11] as int,
      actualBedTime: fields[12] as String?,
      bedTimeFeedback: fields[13] as String?,
      dailyChecklist: (fields[14] as Map?)?.cast<String, bool>(),
    );
  }

  @override
  void write(BinaryWriter writer, DietRecordModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.wakeTime)
      ..writeByte(2)
      ..write(obj.meals)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.bodyFat)
      ..writeByte(5)
      ..write(obj.diary)
      ..writeByte(6)
      ..write(obj.aiFeedback)
      ..writeByte(7)
      ..write(obj.weeklySummary)
      ..writeByte(8)
      ..write(obj.confession)
      ..writeByte(9)
      ..write(obj.confessionFeedback)
      ..writeByte(10)
      ..write(obj.bedTime)
      ..writeByte(11)
      ..write(obj.warningCount)
      ..writeByte(12)
      ..write(obj.actualBedTime)
      ..writeByte(13)
      ..write(obj.bedTimeFeedback)
      ..writeByte(14)
      ..write(obj.dailyChecklist);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DietRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
