import 'dart:async';
import 'dart:io';

import 'package:bitbucket_code_coverage/src/client/coverage_converter/coverage_converter.dart';
import 'package:bitbucket_code_coverage/src/client/model/commit_coverage.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';

abstract class ConverterStrategy {
  Future<CommitCoverage> convertWith(CoverageConverter coverageConverter);

  factory ConverterStrategy.from(String path, String pattern, String workingDirectory) {
    return _FileConverterStrategy(path);
    }
}

class _FileConverterStrategy implements ConverterStrategy {
  final String path;

  _FileConverterStrategy(this.path);

  @override
  Future<CommitCoverage> convertWith(CoverageConverter converter) {
    return converter.convert(File(path));
  }
}

class _PatternConverterStrategy implements ConverterStrategy {
  final String pattern;
  final String workingDirectory;

  _PatternConverterStrategy(this.pattern, this.workingDirectory);

  @override
  Future<CommitCoverage> convertWith(CoverageConverter converter) {
    return Glob(pattern)
        .list(root: workingDirectory)
        .asyncMap((FileSystemEntity entity) => converter.convert(File(entity.path)))
        .reduce((CommitCoverage first, CommitCoverage second) =>
            CommitCoverage(first.files.followedBy(second.files).toList()));
  }
}
