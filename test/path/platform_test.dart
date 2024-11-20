import 'dart:io';

import 'package:rust/rust.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test("readLinkSync", () {
    if (Path.isIoSupported) {
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
    } else {
      expect(isWeb(), isTrue);
      expect(
        () => Path("test/path/fixtures/file_symlink").readLinkSync(),
        throwsA(isA<UnsupportedError>()),
      );
    }
  });

  test("readLink", () async {
    if (Path.isIoSupported) {
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
    } else {
      expect(isWeb(), isTrue);
      expect(
        () async => await Path("test/path/fixtures/file_symlink").readLink(),
        throwsA(isA<UnsupportedError>()),
      );
    }
  });

  test("metadata", () async {
    if (Path.isIoSupported) {
      if (Platform.isWindows) {
        final _ = await Path("test\\path\\fixtures\\file").metadata();
      } else {
        final _ = await Path("test/path/fixtures/file").metadata();
      }
      // Dev Note: uncommenting below will cause a compilation error when the target is web.
      // DateTime accessed = metadata.accessed;
    } else {
      expect(isWeb(), isTrue);
      expect(
        () async => await Path("test/path/fixtures/file").metadata(),
        throwsA(isA<UnsupportedError>()),
      );
    }
  });

  test("metadataSync", () {
    if (Path.isIoSupported) {
      if (Platform.isWindows) {
        final _ = Path("test\\path\\fixtures\\file").metadataSync();
      } else {
        final _ = Path("test/path/fixtures/file").metadataSync();
      }
    } else {
      expect(isWeb(), isTrue);
      expect(
        () => Path("test/path/fixtures/file").metadataSync(),
        throwsA(isA<UnsupportedError>()),
      );
    }
  });
}

bool isWeb() {
  if (Platform.isAndroid ||
      Platform.isFuchsia ||
      Platform.isIOS ||
      Platform.isLinux ||
      Platform.isMacOS ||
      Platform.isWindows) {
    return false;
  }
  return true;
}
