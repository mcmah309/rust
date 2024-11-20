// ignore_for_file: pattern_never_matches_value_type, unused_local_variable

import 'package:rust/rust.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test("readLinkSync", () {
    if (Path.isIoSupported()) {
      expect(
        Path("test/path/fixtures/file_symlink").readLinkSync().unwrap(),
        endsWith("test/path/fixtures/file"),
      );
    } else {
      expect(
        () => Path("test/path/fixtures/file_symlink").readLinkSync(),
        throwsA(isA<UnsupportedError>()),
      );
    }
  });

  test("readLink", () async {
    if (Path.isIoSupported()) {
      expect(
        (await Path("test/path/fixtures/file_symlink").readLink()).unwrap(),
        endsWith("test/path/fixtures/file"),
      );
    } else {
      expect(
        () async => await Path("test/path/fixtures/file_symlink").readLink(),
        throwsA(isA<UnsupportedError>()),
      );
    }
  });

  test("metadata", () async {
    if (Path.isIoSupported()) {
      final metadata = await Path("test/path/fixtures/file").metadata();
      // Dev Note: uncommenting below will cause a compilation error when the target is web.
      // DateTime accessed = metadata.accessed;
    } else {
      expect(
        () async => await Path("test/path/fixtures/file").metadata(),
        throwsA(isA<UnsupportedError>()),
      );
    }
  });

  test("metadataSync", () {
    if (Path.isIoSupported()) {
      final metadata = Path("test/path/fixtures/file").metadataSync();
      // Dev Note: uncommenting below will cause a compilation error when the target is web.
    } else {
      expect(
        () => Path("test/path/fixtures/file").metadataSync(),
        throwsA(isA<UnsupportedError>()),
      );
    }
  });
}
