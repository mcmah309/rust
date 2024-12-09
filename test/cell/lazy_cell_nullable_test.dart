import 'package:rust/rust.dart';
import 'package:test/test.dart';

void main() {
  group('NullableLazyCell Tests', () {
    LazyCellNullable<int?> lazyCell;
    int callCount = 0;
    initFunc() {
      callCount++;
      return 10;
    }

    setUp(() {
      callCount = 0;
    });

    test('Value is lazily initialized', () {
      lazyCell = LazyCellNullable<int?>(initFunc);
      expect(callCount, equals(0));
      var value = lazyCell();
      expect(value, equals(10));
      expect(callCount, equals(1));
    });

    test('Subsequent calls return the same value without reinitializing', () {
      lazyCell = LazyCellNullable<int?>(initFunc);
      var firstCall = lazyCell();
      expect(callCount, equals(1));

      var secondCall = lazyCell();
      expect(secondCall, equals(firstCall));
      expect(callCount, equals(1));
    });

    test('Works with null values', () {
      var nullLazyCell = LazyCellNullable<int?>(() => null);
      expect(nullLazyCell(), isNull);
    });

    test('Equality and hashCode', () {
      lazyCell = LazyCellNullable<int?>(initFunc);
      var anotherLazyCell = LazyCellNullable<int?>(initFunc);
      anotherLazyCell();

      expect(lazyCell, isNot(equals(anotherLazyCell)));
      expect(lazyCell.hashCode, isNot(equals(anotherLazyCell.hashCode)));

      lazyCell();
      expect(lazyCell, equals(anotherLazyCell));
      expect(lazyCell.hashCode, equals(anotherLazyCell.hashCode));
    });
  });
}
