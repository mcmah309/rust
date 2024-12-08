@TestOn('vm')

import 'package:rust/rust.dart';
import 'package:test/test.dart';

main() {
  test("joinPaths", () {
    if (Env.isWindows) {
      expect(Env.joinPaths(["this/is/a/path", "this/is/also/a/path", "this/is/a/path/as/well"]),
          "this/is/a/path;this/is/also/a/path;this/is/a/path/as/well");
    } else {
      expect(Env.joinPaths(["this/is/a/path", "this/is/also/a/path", "this/is/a/path/as/well"]),
          "this/is/a/path:this/is/also/a/path:this/is/a/path/as/well");
    }
  });

  test("isWeb", () {
    expect(Env.isWeb, false);
  });
}
