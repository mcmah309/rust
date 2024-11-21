@TestOn('browser')

import 'package:rust/rust.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test("isIoSupported", () {
    expect(Path.isIoSupported, isFalse);
  });

  test("readLinkSync", () {
    expect(
      () => Path("test/path/fixtures/file_symlink").readLinkSync(),
      throwsA(isA<UnsupportedError>()),
    );
  });

  test("readLink", () async {
    expect(
      () async => await Path("test/path/fixtures/file_symlink").readLink(),
      throwsA(isA<UnsupportedError>()),
    );
  });

  test("metadata", () async {
    expect(
      () async => await Path("test/path/fixtures/file").metadata(),
      throwsA(isA<UnsupportedError>()),
    );
  });

  test("metadataSync", () {
    expect(
      () => Path("test/path/fixtures/file").metadataSync(),
      throwsA(isA<UnsupportedError>()),
    );
  });
}
