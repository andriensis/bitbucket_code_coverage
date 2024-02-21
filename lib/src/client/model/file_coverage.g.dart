// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_coverage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileCoverage _$FileCoverageFromJson(Map json) => $checkedCreate(
      'FileCoverage',
      json,
      ($checkedConvert) {
        final val = FileCoverage(
          $checkedConvert('path', (v) => v as String),
          $checkedConvert('coverage',
              (v) => const CoverageStringConverter().fromJson(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$FileCoverageToJson(FileCoverage instance) =>
    <String, dynamic>{
      'path': instance.path,
      'coverage': const CoverageStringConverter().toJson(instance.coverage),
    };
