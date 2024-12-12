import 'package:rust/rust.dart';
import 'package:test/test.dart';

void main() {
  test('Infallible', () {
    Result<int, Never> x = Ok(1);
    expect(x.intoOk(), 1);
    Result<Never, int> w = Err(1);
    expect(w.intoErr(), 1);
  });

  group('toErr', () {
    test('without result type', () {
      final result = 'error'.toErr();

      expect(result, isA<Result<dynamic, String>>());
      expect(result.unwrapErr(), isA<String>());
      expect(result.unwrapErr(), 'error');
    });

    test('with result type', () {
      final Result<int, String> result = 'error'.toErr();

      expect(result, isA<Result<int, String>>());
      expect(result.unwrapErr(), isA<String>());
      expect(result.unwrapErr(), 'error');
    });

    test('throw AssertException if is a Result object', () {
      final Result<int, String> result = 'error'.toErr();
      expect(result.toErr, throwsA(isA<AssertionError>()));
    });
  });

  group('toOk', () {
    test('without result type', () {
      final result = 'ok'.toOk();

      expect(result, isA<Result<String, Object>>());
      expect(result.unwrapOrNull(), 'ok');
    });

    test('with result type', () {
      final Result<String, int> result = 'ok'.toOk();

      expect(result, isA<Result<String, int>>());
      expect(result.unwrapOrNull(), 'ok');
    });

    test('throw AssertException if is a Result object', () {
      final result = 'ok'.toOk();
      expect(result.toOk, throwsA(isA<AssertionError>()));
    });
  });
}
