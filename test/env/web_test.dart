@TestOn('browser')

import 'package:rust/rust.dart';
import 'package:test/test.dart';

main() {
  test("joinPaths", () {
    expect(
      () async {
        if (Env.isWindows) {
          expect(
              Env.joinPaths([
                "this/is/a/path",
                "this/is/also/a/path",
                "this/is/a/path/as/well"
              ]),
              "this/is/a/path;this/is/also/a/path;this/is/a/path/as/well");
        } else {
          expect(
              Env.joinPaths([
                "this/is/a/path",
                "this/is/also/a/path",
                "this/is/a/path/as/well"
              ]),
              "this/is/a/path:this/is/also/a/path:this/is/a/path/as/well");
        }
      },
      throwsA(isA<UnsupportedError>()),
    );
  });

  test("isWeb", () {
    expect(Env.isWeb, true);
  });
}
