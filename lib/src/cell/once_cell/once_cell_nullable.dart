import 'package:rust/rust.dart';

/// OnceCell, A cell which can be written to only once. OnceCell implementation that allows [T] to be null and does
/// not use [Option]
///
/// Equality: Cells are equal if they have the same value or are not set.
///
/// Hash: Cells hash to their existing or the same if not set.
class OnceCellNullable<T> {
  T? _val;
  bool _isSet = false;

  OnceCellNullable([Option<T>? value]) {
    if(value != null) {
      _isSet = true;
      switch(value) {
        case Some<T>(:final v):
          _val = v;
        case _:
      }
    }
  }

  /// Gets the underlying value, returns null if the cell is empty
  @pragma("vm:prefer-inline")
  T? getOrNull() {
    return _val;
  }

  /// Gets the underlying value, returns [None] if the cell is empty
  Option<T> getOrOption() {
    if (_isSet) {
      return Some(_val as T);
    }
    return None;
  }

  /// Gets the contents of the cell, initializing it with [func] if the cell was empty.
  T getOrInit(T Function() func) {
    if (_isSet) {
      return _val!;
    }
    _val = func();
    _isSet = true;
    return _val!;
  }

  /// Gets the contents of the cell, initializing it with f if the cell was empty. If the cell was empty and f failed, an error is returned.
  Result<T, E> getOrTryInit<E extends Object>(Result<T, E> Function() f) {
    if (_isSet) {
      return Ok(_val as T);
    }
    final result = f();
    if (result.isOk()) {
      _val = result.unwrap();
      _isSet = true;
      return Ok(_val as T);
    }
    return result;
  }

  /// Sets the contents of the cell to value. Returns null if the value is already set. Otherwise returns the input value.
  T? setOrNull(T value) {
    if (_isSet) {
      return null;
    }
    _val = value;
    _isSet = true;
    return _val;
  }

  /// Sets the contents of the cell to value. Returns a None if the value is already set. Otherwise returns Some of the input value.
  Option<T> setOrOption(T value) {
    if (_isSet) {
      return None;
    }
    _val = value;
    _isSet = true;
    return Some(value);
  }

  /// Takes the value out of this OnceCell, moving it back to an uninitialized state. Returns null if the cell is empty.
  T? takeOrNull() {
    if (_isSet) {
      _isSet = false;
      final val = _val;
      _val = null;
      return val;
    }
    return null;
  }

  /// Takes the value out of this OnceCell, moving it back to an uninitialized state. Returns a None if the cell is empty.
  Option<T> takeOrOption() {
    if (_isSet) {
      _isSet = false;
      final val = _val;
      _val = null;
      return Some(val as T);
    }
    return None;
  }

  /// Returns true if the value has been set. Returns false otherwise.
  @pragma("vm:prefer-inline")
  bool isSet() {
    return _isSet;
  }

  @override
  int get hashCode {
    final valueHash = _isSet ? _val.hashCode : 0;
    return valueHash;
  }

  @override
  bool operator ==(Object other) {
    return other is OnceCellNullable<T> &&
        ((isSet() && other.isSet() && getOrNull() == other.getOrNull()) ||
            (!isSet() && !other.isSet()));
  }

  @override
  String toString() {
    return (_isSet
        ? "Initialized $runtimeType($_val)"
        : "Uninitialized $runtimeType");
  }
}
