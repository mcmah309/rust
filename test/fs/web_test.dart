@TestOn('browser')

import 'package:rust/rust.dart';
import 'package:test/test.dart';

main() {
  test("exists", () async {
    expect(
      () async => await Fs.exists("/made/up/path".asPath()),
      throwsA(isA<UnsupportedError>()),
    );
  });

  test("metadata", () async {
    expect(
      () async => await Fs.metadata("/made/up/path".asPath()),
      throwsA(isA<UnsupportedError>()),
    );
  });
}