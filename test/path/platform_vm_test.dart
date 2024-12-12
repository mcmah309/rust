@TestOn('vm')

import 'dart:io';

import 'package:rust/rust.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test("isIoSupported", () {
    expect(Fs.isIoSupported, isTrue);
    expect(
        (Platform.isAndroid ||
            Platform.isFuchsia ||
            Platform.isIOS ||
            Platform.isLinux ||
            Platform.isMacOS ||
            Env.isWindows),
        isTrue);
  });

  test("readLinkSync", () {
    if (Env.isWindows) {
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
    if (Env.isWindows) {
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
    if (Env.isWindows) {
      final _ = await Path("test\\path\\fixtures\\file").metadata().unwrap();
    } else {
      // ignore: unused_local_variable
      final metadata =
          await Path("test/path/fixtures/file").metadata().unwrap();
      DateTime _ = metadata.accessed;
    }
  });

  test("metadataSync", () {
    if (Env.isWindows) {
      final _ = Path("test\\path\\fixtures\\file").metadataSync();
    } else {
      final _ = Path("test/path/fixtures/file").metadataSync();
    }
  });
}
