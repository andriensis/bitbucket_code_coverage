// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commit_coverage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommitCoverage _$CommitCoverageFromJson(Map json) => $checkedCreate(
      'CommitCoverage',
      json,
      ($checkedConvert) {
        final val = CommitCoverage(
          $checkedConvert(
              'files',
              (v) => (v as List<dynamic>)
                  .map((e) => FileCoverage.fromJson(
                      Map<String, dynamic>.from(e as Map)))
                  .toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$CommitCoverageToJson(CommitCoverage instance) =>
    <String, dynamic>{
      'files': instance.files,
    };
