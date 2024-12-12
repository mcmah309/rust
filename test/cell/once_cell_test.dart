import 'package:rust/rust.dart';
import 'package:test/test.dart';

void main() {
  group('NonNullableOnceCell Tests', () {
    OnceCell<int> cell;

    test('Initial state', () {
      cell = OnceCell<int>();
      expect(cell.getOrOption(), None);
    });

    test('Construction with initial value', () {
      var cellWithValue = OnceCell(10);
      expect(cellWithValue.getOrNull(), equals(10));
    });

    test('getOrNull on non-empty cell', () {
      cell = OnceCell<int>();
      cell.setOrNull(5);
      expect(cell.getOrNull(), equals(5));
    });

    test('getOrInit on empty cell', () {
      cell = OnceCell<int>();
      var value = cell.getOrInit(() => 3);
      expect(value, equals(3));
    });

    test('getOrInit on non-empty cell', () {
      cell = OnceCell<int>();
      cell.setOrNull(2);
      var value = cell.getOrInit(() => 3);
      expect(value, equals(2));
    });

    test('getOrTryInit on empty cell with success', () {
      cell = OnceCell<int>();
      var result = cell.getOrTryInit(() => Ok(4));
      expect(result.unwrap(), equals(4));
    });

    test('getOrTryInit on empty cell with failure', () {
      cell = OnceCell<int>();
      var result = cell.getOrTryInit(() => Err('Error'));
      expect(result.isErr(), isTrue);
    });

    test('getOrTryInit on non-empty cell', () {
      cell = OnceCell<int>();
      cell.setOrNull(1);
      var result = cell.getOrTryInit(() => Ok(4));
      expect(result.unwrap(), equals(1));
    });

    test('setOrNull on empty cell', () {
      cell = OnceCell<int>();
      var result = cell.setOrNull(6);
      expect(result, equals(6));
    });

    test('setOrNull on non-empty cell', () {
      cell = OnceCell<int>();
      cell.setOrNull(7);
      var result = cell.setOrNull(8);
      expect(result, isNull);
    });

    test('set on empty cell', () {
      cell = OnceCell<int>();
      var result = cell.setOrNull(10);
      expect(result, 10);
    });

    test('set on non-empty cell', () {
      cell = OnceCell<int>();
      cell.setOrNull(11);
      var result = cell.setOrOption(12);
      expect(result.isNone(), isTrue);
    });

    test('takeOrNull on non-empty cell', () {
      cell = OnceCell<int>();
      cell.setOrNull(9);
      var value = cell.takeOrNull();
      expect(value, equals(9));
      expect(cell.getOrNull(), isNull);
    });

    test('takeOrNull on empty cell', () {
      cell = OnceCell<int>();
      var value = cell.takeOrNull();
      expect(value, isNull);
    });

    test('Equality and hashCode', () {
      var cell2 = OnceCell<int>();
      cell = OnceCell<int>();
      expect(cell, equals(cell2));
      expect(cell.hashCode, equals(cell2.hashCode));

      cell.setOrNull(13);
      expect(cell, isNot(equals(cell2)));
      expect(cell.hashCode, isNot(equals(cell2.hashCode)));
      cell2.setOrNull(13);
      expect(cell, equals(cell2));
      expect(cell.hashCode, equals(cell2.hashCode));
    });

    test("OnceCell", () {
      final cell = OnceCell<int>();
      var result = cell.setOrOption(10);
      expect(result.unwrap(), 10);
      var result2 = cell.setOrNull(20);
      expect(result2, null);
    });
  });
}
