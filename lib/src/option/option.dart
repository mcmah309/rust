// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:rust/rust.dart';

part 'future_option_extensions.dart';
part 'future_option.dart';
part 'option_extensions.dart';
part 'record_to_option_extensions.dart';

/// Option represents the union of two types - `Some<T>` and `None`. As an extension Option$type of `T?`, `Option<T>`
/// has the same runtime cost of `T?` with the advantage of being able to chain null specific operations.
// Dev Note: `T` cannot be `T extends Object`. e.g. because then a method on `Vec<T>` would not be able to return an Option<T>
// unless it is also `Vec<T extends Object>` and if this was true then a `Vec<Option<T>>` where `T extends Object` would not be possible,
// because the erasure of `Option<T>` would still be `T?`. Therefore, here T cannot be `T extends Object`
extension type const Option<T>._(T? v) {

  @pragma("vm:prefer-inline")
  T? get value => v;

  /// Creates a context for early return, similar to "Do notation". Works like the Rust "?" operator, which is a
  /// "Early Return Operator". Here "$" is used as the "Early Return Key". when "$" is used on a type [_None],
  /// immediately the context that "$" belongs to is returned with None(). e.g.
  /// ```
  ///   Option<int> intNone() => const None();
  ///
  ///   Option<int> earlyReturn(int val) => Option(($){
  ///     int x = intNone()[$]; // returns [None] immediately
  ///     return Some(val + 3);
  ///   });
  ///   expect(earlyReturn(2), const None());
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
  /// "Early Return Operator". Here "$" is used as the "Early Return Key". when "$" is used on a type [_None],
  /// immediately the context that "$" belongs to is returned with None(). e.g.
  /// ```
  /// FutureOption<int> intNone() async => const None();
  ///
  /// FutureOption<int> earlyReturn(int val) => Option.async(($) async {
  ///  int x = await intNone()[$]; // returns [None] immediately
  ///  return Some(x + 3);
  /// });
  /// expect(await earlyReturn(2), const None());
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
  Option.from(T? v) : this._(v);
}

extension Option$OptionMethodsExtension<T extends Object> on Option<T> {
  /// Returns None if the option is None, otherwise returns [other].
  @pragma("vm:prefer-inline")
  Option<U> and<U extends Object>(Option<U> other) {
    return v == null ? None : other;
  }

  ///Returns None if the option is None, otherwise calls f with the wrapped value and returns the result. Some
  ///languages call this operation flatmap.
  @pragma("vm:prefer-inline")
  Option<U> andThen<U extends Object>(Option<U> Function(T) f) {
    return v == null ? None : f(v!);
  }

  // copy: Does not make sense to add here since this is an extension Option$type

  /// Returns the contained Some value if [Some], otherwise throws a [Panic].
  @pragma("vm:prefer-inline")
  T expect(String msg) {
    return v == null
        ? throw Panic("Called `expect` on a value that was `None`. $msg")
        : v!;
  }

  /// Returns None if the option is None, otherwise calls predicate with the wrapped value and returns
  /// Some(t) if predicate returns true (where t is the wrapped value), and
  // None if predicate returns false
  @pragma("vm:prefer-inline")
  Option<T> filter(bool Function(T) predicate) {
    if (v == null) {
      return None;
    } else {
      if (predicate(v!)) {
        return Some(v!);
      }
      return None;
    }
  }

  // flatten: Added as extension

  // T getOrInsert(T value); // not possible, otherwise would not be const

  // T getOrInsertWith(T Function() f); // not possible, otherwise cannot be const

  // T insert(T value); // not possible, otherwise lose const

  /// Calls the provided closure with a reference to the contained value
  @pragma("vm:prefer-inline")
  Option<T> inspect(Function(T) f) {
    if (v == null) {
      return this;
    } else {
      f(v!);
      return this;
    }
  }

  /// Returns true if the option is a None value.
  @pragma("vm:prefer-inline")
  bool isNone() {
    return this == null;
  }

  /// Returns true if the option is a Some value.
  @pragma("vm:prefer-inline")
  bool isSome() {
    return this != null;
  }

  /// Returns true if the option is a Some and the value inside of it matches a predicate.
  @pragma("vm:prefer-inline")
  bool isSomeAnd(bool Function(T) f) {
    if (v == null) {
      return false;
    } else {
      return f(v!);
    }
  }

  /// Returns an Iter over the possibly contained value.
  @pragma("vm:prefer-inline")
  Iter<T> iter() {
    if (v == null) {
      return Iter(<T>[].iterator);
    } else {
      return Iter([v!].iterator);
    }
  }

  /// Maps an this Option<T> to Option<U> by applying a function to a contained value (if Some) or returns None (if
  /// None).
  @pragma("vm:prefer-inline")
  Option<U> map<U extends Object>(U Function(T) f) {
    if (v == null) {
      return None;
    } else {
      return Some(f(v!));
    }
  }

  /// Returns the provided default result (if none), or applies a function to the contained value (if any).
  @pragma("vm:prefer-inline")
  U mapOr<U>(U defaultValue, U Function(T) f) {
    if (v == null) {
      return defaultValue;
    } else {
      return f(v!);
    }
  }

  /// Computes a default function result (if none), or applies a different function to the contained value (if any).
  @pragma("vm:prefer-inline")
  U mapOrElse<U>(U Function() defaultFn, U Function(T) f) {
    if (v == null) {
      return defaultFn();
    } else {
      return f(v!);
    }
  }

  /// Transforms the Option<T> into a Result<T, E>, mapping Some(v) to Ok(v) and None to Err(err).
  @pragma("vm:prefer-inline")
  Result<T, E> okOr<E extends Object>(E err) {
    if (v == null) {
      return Err(err);
    } else {
      return Ok(v!);
    }
  }

  /// Transforms the Option<T> into a Result<T, E>, mapping Some(v) to Ok(v) and None to Err(err()).
  @pragma("vm:prefer-inline")
  Result<T, E> okOrElse<E extends Object>(E Function() errFn) {
    if (v == null) {
      return Err(errFn());
    } else {
      return Ok(v!);
    }
  }

  /// Returns the option if it contains a value, otherwise returns other.
  @pragma("vm:prefer-inline")
  Option<T> or(Option<T> other) {
    if (v == null) {
      return other;
    } else {
      return Some(v!);
    }
  }

  /// Returns the option if it contains a value, otherwise calls f and returns the result.
  @pragma("vm:prefer-inline")
  Option<T> orElse(Option<T> Function() f) {
    if (v == null) {
      return f();
    } else {
      return Some(v!);
    }
  }

  // Option<T> replace(value); // not possible, otherwise not const

  // Option<T> take(); // not possible, can't transmute into None

  // Option<T> takeIf(bool Function(T) predicate); // not possible, can't transmute into None

  // transpose: Added as extension

  /// Returns the contained Some value, consuming the self value.
  @pragma("vm:prefer-inline")
  T unwrap() {
    return v as T;
  }

  /// Returns the contained Some value or a provided default.
  @pragma("vm:prefer-inline")
  T unwrapOr(T defaultValue) {
    if (v == null) {
      return defaultValue;
    } else {
      return v!;
    }
  }

  /// Returns the contained Some value or computes it from a closure.
  @pragma("vm:prefer-inline")
  T unwrapOrElse(T Function() f) {
    if (v == null) {
      return f();
    } else {
      return v!;
    }
  }

  // unzip: Added as extension

  /// Returns Some if exactly one of self, [other] is Some, otherwise returns None.
  @pragma("vm:prefer-inline")
  Option<T> xor(Option<T> other) {
    if (v == null) {
      if (other.isSome()) {
        return other;
      }
      return None;
    } else {
      if (other.isSome()) {
        return None;
      }
      return Some(v!);
    }
  }

  /// Zips self with another Option.
  @pragma("vm:prefer-inline")
  Option<(T, U)> zip<U extends Object>(Option<U> other) {
    if (v == null) {
      return None;
    } else {
      if (other.isSome()) {
        return Some((v!, other.unwrap()));
      }
      return None;
    }
  }

  /// Zips self and another Option with function f
  @pragma("vm:prefer-inline")
  Option<R> zipWith<U extends Object, R extends Object>(
      Option<U> other, R Function(T, U) f) {
    if (v == null) {
      return None;
    } else {
      if (other.isSome()) {
        return Some(f(v!, other.unwrap()));
      }
      return None;
    }
  }

  //************************************************************************//

  /// Functions an "Early Return Operator" when given an "Early Return key" "$". See [Option.$] for more information.
  @pragma("vm:prefer-inline")
  T operator [](_OptionEarlyReturnKey op) {
    if (v == null) {
      throw const _OptionEarlyReturnNotification();
    } else {
      return v!;
    }
  }
}

/// Represents a value that is present. The erasure of this is [T].
// Dev Note: This cannot be `T extends Object`, besides the reasons [Option] cannot be as well, Something like Some(Some(...)) would not work.
extension type const Some<T>._(T v) implements Option<T> {
  const Some(T v) : this._(v);

  @pragma("vm:prefer-inline")
  T get value => v;
}

extension Option$SomeMethodsExtension<T extends Object> on Some<T> {
  @pragma("vm:prefer-inline")
  Option<U> and<U extends Object>(Option<U> other) {
    return other;
  }

  @pragma("vm:prefer-inline")
  Option<U> andThen<U extends Object>(Option<U> Function(T self) f) {
    return f(v);
  }

  @pragma("vm:prefer-inline")
  Some<T> copy() {
    return Some(v);
  }

  @pragma("vm:prefer-inline")
  T expect(String msg) {
    return v;
  }

  @pragma("vm:prefer-inline")
  Option<T> filter(bool Function(T self) predicate) {
    if (predicate(v)) {
      return Some(v);
    }
    return None;
  }

  @pragma("vm:prefer-inline")
  Some<T> inspect(Function(T self) f) {
    f(v);
    return this;
  }

  @pragma("vm:prefer-inline")
  bool isNone() {
    return false;
  }

  @pragma("vm:prefer-inline")
  bool isSome() {
    return true;
  }

  @pragma("vm:prefer-inline")
  bool isSomeAnd(bool Function(T self) f) {
    return f(v);
  }

  @pragma("vm:prefer-inline")
  Iter<T> iter() {
    return Iter([v].iterator);
  }

  @pragma("vm:prefer-inline")
  Some<U> map<U extends Object>(U Function(T self) f) {
    return Some(f(v));
  }

  @pragma("vm:prefer-inline")
  U mapOr<U>(U defaultValue, U Function(T) f) {
    return f(v);
  }

  @pragma("vm:prefer-inline")
  U mapOrElse<U>(U Function() defaultFn, U Function(T) f) {
    return f(v);
  }

  @pragma("vm:prefer-inline")
  Ok<T, Infallible> okOr<E extends Object>(E err) {
    return Ok(v);
  }

  @pragma("vm:prefer-inline")
  Ok<T, Infallible> okOrElse<E extends Object>(E Function() errFn) {
    return Ok(v);
  }

  @pragma("vm:prefer-inline")
  Some<T> or(Option<T> other) {
    return Some(v);
  }

  @pragma("vm:prefer-inline")
  Some<T> orElse(Option<T> Function() f) {
    return Some(v);
  }

  @pragma("vm:prefer-inline")
  T unwrap() {
    return v;
  }

  @pragma("vm:prefer-inline")
  T unwrapOr(T defaultValue) {
    return v;
  }

  @pragma("vm:prefer-inline")
  T unwrapOrElse(T Function() f) {
    return v;
  }

  @pragma("vm:prefer-inline")
  Option<T> xor(Option<T> other) {
    if (other.isSome()) {
      return None;
    }
    return Some(v);
  }

  @pragma("vm:prefer-inline")
  Option<(T, U)> zip<U extends Object>(Option<U> other) {
    if (other.isSome()) {
      return Some((v, other.unwrap()));
    }
    return None;
  }

  @pragma("vm:prefer-inline")
  Option<R> zipWith<U extends Object, R extends Object>(
      Option<U> other, R Function(T p1, U p2) f) {
    if (other.isSome()) {
      return Some(f(v, other.unwrap()));
    }
    return None;
  }

  //************************************************************************//

  @pragma("vm:prefer-inline")
  T operator [](_OptionEarlyReturnKey op) {
    return v;
  }
}

/// Represents a value that is absent. The erasure of this is [null].
// ignore: constant_identifier_names
const None = _None();

/// Represents a value that is absent. The erasure of this is [null].
extension type const _None._(Null _) implements Option<Infallible> {
  const _None() : this._(null);

  @pragma("vm:prefer-inline")
  Null get value => v;
}

extension Option$NoneMethodsExtension on _None {
  @pragma("vm:prefer-inline")
  _None and<U extends Object>(Option<U> other) {
    return None;
  }

  @pragma("vm:prefer-inline")
  _None andThen<U extends Object>(Option<U> Function(void self) f) {
    return None;
  }

  @pragma("vm:prefer-inline")
  _None copy() {
    return None;
  }

  @pragma("vm:prefer-inline")
  Infallible expect(String msg) {
    throw Panic("Called `expect` on a value that was `None`. $msg");
  }

  @pragma("vm:prefer-inline")
  _None filter(bool Function(void self) predicate) {
    return None;
  }

  @pragma("vm:prefer-inline")
  _None inspect(Function(void self) f) {
    return this;
  }

  @pragma("vm:prefer-inline")
  bool isNone() {
    return true;
  }

  @pragma("vm:prefer-inline")
  bool isSome() {
    return false;
  }

  @pragma("vm:prefer-inline")
  bool isSomeAnd(bool Function(void self) f) {
    return false;
  }

  @pragma("vm:prefer-inline")
  Iter<_None> iter() {
    return Iter((const <_None>[]).iterator);
  }

  @pragma("vm:prefer-inline")
  _None map<U extends Object>(U Function(void self) f) {
    return None;
  }

  @pragma("vm:prefer-inline")
  U mapOr<U>(U defaultValue, U Function(void) f) {
    return defaultValue;
  }

  @pragma("vm:prefer-inline")
  U mapOrElse<U>(U Function() defaultFn, U Function(void) f) {
    return defaultFn();
  }

  @pragma("vm:prefer-inline")
  Err<Infallible, E> okOr<E extends Object>(E err) {
    return Err(err);
  }

  @pragma("vm:prefer-inline")
  Err<Infallible, E> okOrElse<E extends Object>(E Function() errFn) {
    return Err(errFn());
  }

  @pragma("vm:prefer-inline")
  Option<T> or<T extends Object>(Option<T> other) {
    return other;
  }

  @pragma("vm:prefer-inline")
  Option<T> orElse<T extends Object>(Option<T> Function() f) {
    return f();
  }

  @pragma("vm:prefer-inline")
  Infallible unwrap() {
    throw Panic("Called `unwrap` on a value that was `None`.");
  }

  @pragma("vm:prefer-inline")
  T unwrapOr<T>(T defaultValue) {
    return defaultValue;
  }

  @pragma("vm:prefer-inline")
  T unwrapOrElse<T>(T Function() f) {
    return f();
  }

  @pragma("vm:prefer-inline")
  Option<T> xor<T extends Object>(Option<T> other) {
    if (other.isSome()) {
      return other;
    }
    return None;
  }

  @pragma("vm:prefer-inline")
  _None zip<U extends Object>(Option<U> other) {
    return None;
  }

  @pragma("vm:prefer-inline")
  _None zipWith<U extends Object, R extends Object>(
      Option<U> other, R Function(void p1, U p2) f) {
    return None;
  }

  //************************************************************************//

  @pragma("vm:prefer-inline")
  Infallible operator [](_OptionEarlyReturnKey op) {
    throw const _OptionEarlyReturnNotification();
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
