@TestOn('vm')

import 'dart:io';

import 'package:rust/rust.dart';
import 'package:rust/src/path/io/unsupported.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test("isIoSupported", () {
    expect(Path.isIoSupported, isTrue);
    expect(
        (Platform.isAndroid ||
            Platform.isFuchsia ||
            Platform.isIOS ||
            Platform.isLinux ||
            Platform.isMacOS ||
            Platform.isWindows),
        isTrue);
  });

  test("readLinkSync", () {
    if (Platform.isWindows) {
      expect(
        Path("test\\path\\fixtures\\file_symlink").readLinkSync().unwrap(),
        endsWith("test\\path\\fixtures\\file"),
      );
    } else {
      expect(
        Path("test/path/fixtures/file_symlink").readLinkSync().unwrap(),
        endsWith("test/path/fixtures/file"),
      );
    }
  });

  test("readLink", () async {
    if (Platform.isWindows) {
      expect(
        (await Path("test\\path\\fixtures\\file_symlink").readLink()).unwrap(),
        endsWith("test\\path\\fixtures\\file"),
      );
    } else {
      expect(
        (await Path("test/path/fixtures/file_symlink").readLink()).unwrap(),
        endsWith("test/path/fixtures/file"),
      );
    }
  });

  test("metadata", () async {
    if (Platform.isWindows) {
      final _ = await Path("test\\path\\fixtures\\file").metadata();
    } else {
      // ignore: unused_local_variable
      final metadata = await Path("test/path/fixtures/file").metadata();
      // Dev Note: uncommenting below will cause a compilation error when the target is web.
      // DateTime accessed = metadata.accessed;
    }
  });

  test("metadataSync", () {
    if (Platform.isWindows) {
      final _ = Path("test\\path\\fixtures\\file").metadataSync();
    } else {
      final _ = Path("test/path/fixtures/file").metadataSync();
    }
  });
}
