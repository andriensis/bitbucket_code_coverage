// ignore_for_file: prefer_single_quotes

import 'dart:async';

import 'package:bitbucket_code_coverage/src/client/coverage_converter/lcov/path_prefix_finder.dart';
import 'package:bitbucket_code_coverage/src/client/model/commit_coverage.dart';
import 'package:bitbucket_code_coverage/src/client/model/coverage_string.dart';
import 'package:bitbucket_code_coverage/src/client/model/file_coverage.dart';
import 'package:lcov_dart/lcov_dart.dart';

class ReportToCommitCoverageMapper {
  const ReportToCommitCoverageMapper();

  Future<CommitCoverage> convert(Report report, String root, String lcovPath) {
    var f = PathPrefixFinder();

    return Stream.fromIterable(report.records)
        .where((event) => event != null)
        .asyncMap((record) => f.findPrefix(root, lcovPath, record!.sourceFile).then(
            (String pathPrefix) => FileCoverage(
                [pathPrefix, record.sourceFile].where(notNullOrEmpty).join("/"),
                _toCoverageString(record))))
        .toList()
        .then((List<FileCoverage> files) => CommitCoverage(files));
  }

  CoverageString _toCoverageString(Record record) {
    var uncovered = record.lines!.data
        .where((LineData lineData) => lineData.executionCount == 0)
        .map((LineData lineData) => lineData.lineNumber)
        .toList();

    var partial = record.branches!.data
        .where((BranchData branchData) => branchData.taken == 0)
        .map((BranchData branchData) => branchData.lineNumber)
        .toList();

    var covered = record.lines!.data
        .where((LineData lineData) => lineData.executionCount != 0)
        .map((LineData lineData) => lineData.lineNumber)
        .where((int lineNumber) => !partial.contains(lineNumber))
        .toList();

    return CoverageString(covered: covered, partial: partial, uncovered: uncovered);
  }

  bool notNullOrEmpty(String? string) => string?.isNotEmpty ?? false;
}
