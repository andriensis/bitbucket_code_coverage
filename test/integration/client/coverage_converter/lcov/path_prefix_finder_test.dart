import 'package:bitbucket_code_coverage/src/client/coverage_converter/lcov/path_prefix_finder.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  test('should return path prefix', () async {
    // given
    var parent = d.dir('project', [
      d.dir('build', [d.file('lcov.info', '')]),
      d.dir('lib', [d.file('first.dart', '')])
    ]);
    await parent.create();
    var workingDirectory = parent.io.parent.path;

    var finder = PathPrefixFinder();
    var sourceFilePath = 'lib/first.dart';
    var lcovPath = '$workingDirectory/project/build/lcov.info';

    // when
    var pathPrefix = await finder.findPrefix(workingDirectory, lcovPath, sourceFilePath);

    // then
    expect(pathPrefix, equals('project'));
  });
}
