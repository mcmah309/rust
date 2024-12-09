// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:rust/rust.dart';

part 'future_option_extensions.dart';
part 'future_option.dart';
part 'option_extensions.dart';
part 'record_to_option_extensions.dart';
part 'record_to_null_extensions.dart';

/// Option represents the union of two types - `Some<T>` and `None`.
sealed class Option<T> {
  /// Creates a context for early return, similar to "Do notation". Works like the Rust "?" operator, which is a
  /// "Early Return Operator". Here "$" is used as the "Early Return Key". when "$" is used on a type [None],
  /// immediately the context that "$" belongs to is returned with None. e.g.
  /// ```
  ///   Option<int> intNone => None;
  ///
  ///   Option<int> earlyReturn(int val) => Option(($){
  ///     int x = intNone[$]; // returns [None] immediately
  ///     return Some(val + 3);
  ///   });
  ///   expect(earlyReturn(2), None);
  ///```
  /// This should be used at the top level of a function as above. Passing "$" to any other functions, nesting, or
  /// attempting to bring "$" out of the original scope should be avoided.
  @pragma("vm:prefer-inline")
  factory Option(_OptionEarlyReturnFunction<T> fn) {
    try {
      return fn(const _OptionEarlyReturnKey._());
    } on _OptionEarlyReturnNotification catch (_) {
      return None;
    }
  }

  /// Creates a context for async early return, similar to "Do notation". Works like the Rust "?" operator, which is a
  /// "Early Return Operator". Here "$" is used as the "Early Return Key". when "$" is used on a type [None],
  /// immediately the context that "$" belongs to is returned with None. e.g.
  /// ```
  /// FutureOption<int> intNone async => None;
  ///
  /// FutureOption<int> earlyReturn(int val) => Option.async(($) async {
  ///  int x = await intNone[$]; // returns [None] immediately
  ///  return Some(x + 3);
  /// });
  /// expect(await earlyReturn(2), None);
  ///```
  /// This should be used at the top level of a function as above. Passing "$" to any other functions, nesting, or
  /// attempting to bring "$" out of the original scope should be avoided.
  @pragma("vm:prefer-inline")
  static Future<Option<T>> async<T>(
      _OptionAsyncEarlyReturnFunction<T> fn) async {
    try {
      return await fn(const _OptionEarlyReturnKey._());
    } on _OptionEarlyReturnNotification catch (_) {
      return Future.value(None);
    }
  }

  /// Converts from `T?` to `Option<T>`.
  factory Option.of(T? v) => v == null ? None : Some(v);

  /// Returns None if the option is None, otherwise returns [other].
  Option<U> and<U>(Option<U> other);

  ///Returns None if the option is None, otherwise calls f with the wrapped value and returns the result. Some
  ///languages call this operation flatmap.
  Option<U> andThen<U>(Option<U> Function(T) f);

  /// Shallow copies this Option
  Option<T> copy();

  /// Returns the contained Some value if [Some], otherwise throws a [Panic].
  T expect(String msg);

  /// Returns None if the option is None, otherwise calls predicate with the wrapped value and returns
  /// Some(t) if predicate returns true (where t is the wrapped value), and
  // None if predicate returns false
  Option<T> filter(bool Function(T) predicate);

  // flatten: Added as extension

  // T getOrInsert(T value); // not possible, otherwise would not be const

  // T getOrInsertWith(T Function() f); // not possible, otherwise would not be const

  // T insert(T value); // only applicable to Rust

  /// Calls the provided closure with a reference to the contained value
  Option<T> inspect(Function(T) f);

  /// Returns true if the option is a None value.
  bool isNone();

  /// Returns true if the option is a Some value.
  bool isSome();

  /// Returns true if the option is a Some and the value inside of it matches a predicate.
  bool isSomeAnd(bool Function(T) f);

  /// Returns an Iter over the possibly contained value.
  Iter<T> iter();

  /// Maps an this Option<T> to Option<U> by applying a function to a contained value (if Some) or returns None (if
  /// None).
  Option<U> map<U>(U Function(T) f);

  /// Returns the provided default result (if none), or applies a function to the contained value (if any).
  U mapOr<U>(U defaultValue, U Function(T) f);

  /// Computes a default function result (if none), or applies a different function to the contained value (if any).
  U mapOrElse<U>(U Function() defaultFn, U Function(T) f);

  /// Transforms the Option<T> into a Result<T, E>, mapping Some(v) to Ok(v) and None to Err(err).
  Result<T, E> okOr<E extends Object>(E err);

  /// Transforms the Option<T> into a Result<T, E>, mapping Some(v) to Ok(v) and None to Err(err()).
  Result<T, E> okOrElse<E extends Object>(E Function() errFn);

  // Option<T> replace(value); // not possible, otherwise not const

  // Option<T> take(); // not possible, can't transmute into None

  // Option<T> takeIf(bool Function(T) predicate); // not possible, can't transmute into None

  // transpose: Added as extension

  /// Returns the contained Some value, consuming the self value.
  T unwrap();

  // unwrapOr: Added as extension (for the [None] case) and implemented in [Some]

  // unwrapOrElse: Added as extension (for the [None] case) and implemented in [Some]

  // unzip: Added as extension (for the [None] case) and implemented in [Some]

  // xor: Added as extension (for the [None] case) and implemented in [Some]

  /// Zips self with another Option.
  Option<(T, U)> zip<U>(Option<U> other);

  /// Zips self and another Option with function f
  Option<R> zipWith<U, R>(Option<U> other, R Function(T, U) f);

  //************************************************************************//

  T? toNullable();

  /// Functions an "Early Return Operator" when given an "Early Return key" "$". See [Option.$] for more information.
  @pragma("vm:prefer-inline")
  T operator [](_OptionEarlyReturnKey op);
}

final class Some<T> implements Option<T> {
  final T v;

  @pragma("vm:prefer-inline")
  T get value => v;

  const Some(this.v);

  @override
  Option<U> and<U>(Option<U> other) {
    return other;
  }

  @override
  Option<U> andThen<U>(Option<U> Function(T self) f) {
    return f(v);
  }

  @override
  Some<T> copy() {
    return Some(v);
  }

  @override
  T expect(String msg) {
    return v;
  }

  @override
  Option<T> filter(bool Function(T self) predicate) {
    if (predicate(v)) {
      return this;
    }
    return None;
  }

  @override
  Some<T> inspect(Function(T self) f) {
    f(v);
    return this;
  }

  @override
  bool isNone() {
    return false;
  }

  @override
  bool isSome() {
    return true;
  }

  @override
  bool isSomeAnd(bool Function(T self) f) {
    return f(v);
  }

  @override
  Iter<T> iter() {
    return Iter([v].iterator);
  }

  @override
  Some<U> map<U>(U Function(T self) f) {
    return Some(f(v));
  }

  @override
  U mapOr<U>(U defaultValue, U Function(T) f) {
    return f(v);
  }

  @override
  U mapOrElse<U>(U Function() defaultFn, U Function(T) f) {
    return f(v);
  }

  @override
  Ok<T, E> okOr<E extends Object>(E err) {
    return Ok(v);
  }

  @override
  Ok<T, E> okOrElse<E extends Object>(E Function() errFn) {
    return Ok(v);
  }

  /// Returns the option if it contains a value, otherwise returns other.
  Some<T> or(Option<T> other) {
    return this;
  }

  /// Returns this value as [Some]
  Some<T> orElse(Option<T> Function() f) {
    return this;
  }

  @override
  T unwrap() {
    return v;
  }

  /// Returns this value
  T unwrapOr(T defaultValue) {
    return v;
  }

  /// Returns this value
  T unwrapOrElse(T Function() f) {
    return v;
  }

  /// Returns [Some] if the [other] is not [Some]
  Option<T> xor(Option<T> other) {
    if (other.isSome()) {
      return None;
    }
    return this;
  }

  @override
  Option<(T, U)> zip<U>(Option<U> other) {
    if (other.isSome()) {
      return Some((v, other.unwrap()));
    }
    return None;
  }

  @override
  Option<R> zipWith<U, R>(Option<U> other, R Function(T p1, U p2) f) {
    if (other.isSome()) {
      return Some(f(v, other.unwrap()));
    }
    return None;
  }

  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  T toNullable() => v;

  @override
  T operator [](_OptionEarlyReturnKey op) {
    return v;
  }

  //************************************************************************//
  @override
  int get hashCode => v.hashCode;

  @override
  bool operator ==(Object other) {
    return other is Some && other.v == v;
  }

  @override
  String toString() => 'Some($v)';
}

// ignore: constant_identifier_names
const None = _None();

final class _None implements Option<Never> {
  //@literal
  const _None();

  @override
  _None and<U>(Option<U> other) {
    return None;
  }

  @override
  _None andThen<U>(Option<U> Function(Never self) f) {
    return None;
  }

  @override
  _None copy() {
    return None;
  }

  @override
  Never expect(String msg) {
    throw Panic("Called `expect` on a value that was `None`. $msg");
  }

  @override
  _None filter(bool Function(Never self) predicate) {
    return None;
  }

  @override
  _None inspect(Function(Never self) f) {
    return this;
  }

  @override
  bool isNone() {
    return true;
  }

  @override
  bool isSome() {
    return false;
  }

  @override
  bool isSomeAnd(bool Function(Never self) f) {
    return false;
  }

  @override
  Iter<Never> iter() {
    return Iter(const <Never>[].iterator);
  }

  @override
  Option<U> map<U>(U Function(Never self) f) {
    return None;
  }

  @override
  U mapOr<U>(U defaultValue, U Function(Never) f) {
    return defaultValue;
  }

  @override
  U mapOrElse<U>(U Function() defaultFn, U Function(Never) f) {
    return defaultFn();
  }

  @override
  Err<Never, E> okOr<E extends Object>(E err) {
    return Err(err);
  }

  @override
  Err<Never, E> okOrElse<E extends Object>(E Function() errFn) {
    return Err(errFn());
  }

  @override
  Never unwrap() {
    throw Panic("called `unwrap` a None type");
  }

  @override
  Option<(Never, U)> zip<U>(Option<U> other) {
    return None;
  }

  @override
  Option<R> zipWith<U, R>(Option<U> other, R Function(Never p1, U p2) f) {
    return None;
  }

  //************************************************************************//

  @override
  @pragma("vm:prefer-inline")
  Null toNullable() => null;

  @override
  Never operator [](_OptionEarlyReturnKey op) {
    throw const _OptionEarlyReturnNotification();
  }

  //************************************************************************//
  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => other is _None;

  @override
  String toString() => "None";
}

//************************************************************************//

/// [Option] methods that could not be added to the main [Option] class.
///
/// Dev Note: This is because things like `option.xor(Some(..))`, where `option` is really a `None`,
/// would cause runtime exceptions since it was valid code, but Some<T> is Option<T> not Option<Never>.
/// [Some] also directly implements these methods as well. Since there is no chance of a runtime
/// exception there and if we know it is a [Some] it will be more efficient.
extension Option$NoneExtension<T> on Option<T> {
  /// Returns the option if it contains a value, otherwise returns [other]
  Option<T> or(Option<T> other) {
    if (isSome()) {
      return this;
    }
    return other;
  }

  /// Returns the option if it contains a value, otherwise calls f and returns the result.
  Option<T> orElse(Option<T> Function() f) {
    return switch (this) { Some() => this, _ => f() };
  }

  /// Returns the contained [Some] value or a provided default.
  T unwrapOr(T defaultValue) {
    return switch (this) { Some(:final value) => value, _ => defaultValue };
  }

  /// Returns the option if it contains a value, otherwise returns other.
  T unwrapOrElse(T Function() f) {
    return switch (this) {
      Some(:final value) => value,
      _ => f(),
    };
  }

  /// Returns Some if exactly one of this or [other] is Some, otherwise returns None.
  Option<T> xor(Option<T> other) {
    if (isSome()) {
      if (other.isSome()) {
        return None;
      } else {
        return this;
      }
    }
    if (other.isSome()) {
      return other;
    }
    return None;
  }
}

//************************************************************************//

/// The key that allows early returns for [Option]. The key to the lock.
final class _OptionEarlyReturnKey {
  const _OptionEarlyReturnKey._();
}

/// Thrown from a do notation context
final class _OptionEarlyReturnNotification {
  const _OptionEarlyReturnNotification();
}

typedef _OptionEarlyReturnFunction<T> = Option<T> Function(
    _OptionEarlyReturnKey);

typedef _OptionAsyncEarlyReturnFunction<T> = Future<Option<T>> Function(
    _OptionEarlyReturnKey);
