import 'package:rust/rust.dart';
import 'package:test/test.dart';

void main() {
  group('range', () {
    test('Range ascending', () {
      expect(range(5).toList(), equals([0, 1, 2, 3, 4]));
      expect(range(0, 5).toList(), equals([0, 1, 2, 3, 4]));
      expect(range(5, 10).toList(), equals([5, 6, 7, 8, 9]));
      expect(range(5, 10, 2).toList(), equals([5, 7, 9]));
    });

    test('Range descending', () {
      expect(range(-5).toList(), equals([]));
      expect(range(-5, 0).toList(), equals([-5, -4, -3, -2, -1]));
      expect(range(10, 5).toList(), equals([10, 9, 8, 7, 6]));
      expect(range(10, 5, -2).toList(), equals([10, 8, 6]));
    });

    test('Range equal', () {
      expect(range(5, 5).toList(), equals([]));
    });

    test("Range ascending with step", () {
      expect(range(5, 10, 1).toList(), equals([5, 6, 7, 8, 9]));
      expect(range(5, 10, 2).toList(), equals([5, 7, 9]));
      expect(() => range(5, 10, 0).toList(), throwsA(isA<Panic>()));
      expect(range(5, 10, -1).toList(), equals([]));
      expect(range(5, 10, 10).toList(), equals([5]));
    });

    test("Range descending with step", () {
      expect(range(10, 5, -1).toList(), equals([10, 9, 8, 7, 6]));
      expect(() => range(10, 5, 0).toList(), throwsA(isA<Panic>()));
      expect(range(10, 5, 1).toList(), equals([]));
      expect(range(10, 5, -10).toList(), equals([10]));
    });

    test("Range equal with step", () {
      expect(range(5, 5, 1).toList(), equals([]));
      expect(() => range(5, 5, 0).toList(), throwsA(isA<Panic>()));
      expect(range(5, 5, -1).toList(), equals([]));
    });
  });
}
