import 'dart:async';
import 'dart:io';

import 'package:bitbucket_code_coverage/src/client/coverage_converter/coverage_converter.dart';
import 'package:bitbucket_code_coverage/src/client/coverage_converter/lcov/report_to_commit_coverage_mapper.dart';
import 'package:bitbucket_code_coverage/src/client/model/commit_coverage.dart';
import 'package:lcov_dart/lcov_dart.dart';

class LcovCoverageConverter implements CoverageConverter {
  final String _workingDirectory;
  final ReportToCommitCoverageMapper _mapper;

  LcovCoverageConverter(this._workingDirectory) : _mapper = const ReportToCommitCoverageMapper();

  @override
  Future<CommitCoverage> convert(File coverageFile) async {
    var coverage = await coverageFile.readAsString();
    var report = Report.fromCoverage(coverage);
    return _mapper.convert(report, _workingDirectory, coverageFile.path);
  }
}
