import 'dart:async';
import 'package:test/test.dart';
import 'package:rust/rust.dart';

/// Account simulation extended to use IdMutex for testing.
class Account<Id> {
  int get balance => _balance;
  int _balance = 0;

  final KeyedMutex<Id> keyedMutex = KeyedMutex<Id>();

  void reset([int startingBalance = 0]) {
    _balance = startingBalance;
  }

  /// Critical section for updating balance, protected by IdMutex.
  Future<void> deposit(Id id, int amount, int delay) async {
    await keyedMutex.withLock(id, () async {
      final temp = _balance;
      await Future<void>.delayed(Duration(milliseconds: delay));
      _balance = temp + amount;
    });
  }
}

void main() {
  group('KeyedMutex Tests', () {
    test('Locks with unique Ids', () async {
      final account = Account<String>();

      await Future.wait([
        account.deposit('id1', 42, 1000),
        account.deposit('id2', 26, 50),
      ]);

      expect(account.balance, equals(42),
          reason:
              "Unique Ids do not lock each-other, thus 42 will be set last.");
    });

    test('Locks with same Ids', () async {
      final account = Account<String>();

      await Future.wait([
        account.deposit('id1', 42, 1000),
        account.deposit('id1', 26, 50),
      ]);

      expect(account.balance, equals(68),
          reason:
              "Same Ids lock each-other, thus the second will see the firsts set value.");
    });

    group('withLock functionality', () {
      test('lock obtained and released on success', () async {
        final keyMutex = KeyedMutex<String>();

        await keyMutex.withLock('id1', () async {
          expect(keyMutex.isLocked('id1'), isTrue);
        });

        expect(keyMutex.isLocked('id1'), isFalse);
      });

      test('value returned from critical section', () async {
        final keyMutex = KeyedMutex<String>();

        final value = await keyMutex.withLock('id1', () async => 42);
        expect(value, equals(42));

        final nullValue =
            await keyMutex.withLock<String?>('id1', () async => null);
        expect(nullValue, isNull);

        expect(keyMutex.isLocked('id1'), isFalse);
      });

      test('synchronous exception handling', () async {
        final keyMutex = KeyedMutex<String>();

        Future<int> criticalSection() {
          throw const FormatException('synchronous exception');
        }

        try {
          await keyMutex.withLock('id1', criticalSection);
        } on FormatException catch (e) {
          expect(e.message, equals('synchronous exception'));
          expect(keyMutex.isLocked('id1'), isFalse);
        }
      });

      test('asynchronous exception handling', () async {
        final keyMutex = KeyedMutex<String>();

        Future<int> criticalSection() async {
          await Future.delayed(const Duration(milliseconds: 100));
          throw const FormatException('asynchronous exception');
        }

        try {
          await keyMutex.withLock('id1', criticalSection);
        } on FormatException catch (e) {
          expect(e.message, equals('asynchronous exception'));
          expect(keyMutex.isLocked('id1'), isFalse);
        }
      });
    });
  });
}
