import 'dart:async';

/// As with [Error], [Panic] represents a state that should never happen and thus is not expected to be catch.
/// This is closely tied to the `unwrap` method of both [Option] and [Result] types.
class Panic extends Error {
  final String? msg;

  Panic([this.msg]);

  @override
  String toString() {
    if (msg == null) {
      return "Panic: Undefined state.";
    }
    return "Panic: $msg";
  }
}

/// A [Panic] that resulted from an [Exception]
class ExceptionPanic extends Panic {
  final Exception exception;

  ExceptionPanic(this.exception);

  @override
  String toString() {
    return "Panic: $exception";
  }
}

/// A [Panic] that resulted from an [Error]
class ErrorPanic extends Panic {
  final Error error;

  ErrorPanic(this.error);

  @override
  String toString() {
    return "Panic: $error";
  }
}

/// Shorthand for
/// ```dart
/// throw Panic(...)
/// ```
@pragma("vm:prefer-inline")
Never panic([String? msg]) {
  throw Panic(msg);
}

/// Catches any [Panic], [Exception], or [Error] thrown by the function [fn] and handles.
T panicHandler<T>(T Function() fn, T Function(Panic panic) handler) {
  try {
    return fn();
  } on Panic catch (e) {
    return handler(e);
  } on Exception catch (e) {
    return handler(ExceptionPanic(e));
  } on Error catch (e) {
    return handler(ErrorPanic(e));
  }
}

/// Catches any [Panic], [Exception], or [Error] thrown by the function [fn] and handles.
Future<T> panicHandlerAsync<T>(
    Future<T> Function() fn, FutureOr<T> Function(Panic panic) handler) async {
  try {
    return await fn();
  } on Panic catch (e) {
    return handler(e);
  } on Exception catch (e) {
    return handler(ExceptionPanic(e));
  } on Error catch (e) {
    return handler(ErrorPanic(e));
  }
}
