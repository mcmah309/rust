import 'dart:async';
import 'package:rust/rust.dart';
import 'package:test/test.dart';

void main() {
  group('FutureOptionExtension Tests', () {
    test("flatten", () async {
      FutureOption<Option<int>> someSome6 = Future.value(Some(Some(6)));
      expect(await someSome6.flatten(), Some(6));

      FutureOption<Option<int>> someNone = Future.value(const Some(None));
      expect(await someNone.flatten(), None);

      FutureOption<Option<int>> none = Future.value(None);
      expect(await none.flatten(), None);

      // Flattening only removes one level of nesting at a time
      FutureOption<Option<Option<int>>> someSomeSome6 =
          Future.value(Some(Some(Some(6))));
      expect(await someSomeSome6.flatten(), Some(Some(6)));
      expect(await someSomeSome6.flatten().flatten(), Some(6));
    });

    test("unzip", () async {
      FutureOption<(int, String)> x = Future.value(Some((1, "hi")));
      var unzippedX = await x.unzip();
      expect(unzippedX.$1, Some(1));
      expect(unzippedX.$2, Some("hi"));

      FutureOption<(int, int)> y = Future.value(None);
      var unzippedY = await y.unzip();
      expect(unzippedY.$1, None);
      expect(unzippedY.$1, None);
    });
  });
}
