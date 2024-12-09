import 'package:rust/rust.dart';

/// OnceCell, A cell which can be written to only once. OnceCell implementation based off [Option]
///
/// Equality: Cells are equal if they have the same value or are not set.
///
/// Hash: Cells hash to their existing or the same if not set.
class OnceCell<T extends Object> implements OnceCellNullable<T> {
  T? _val;

  OnceCell([this._val]);

  @override
  Option<T> getOrOption() {
    if (_val == null) {
      return None;
    }
    return Some(_val!);
  }

  @override
  T? getOrNull() {
    return _val;
  }

  @override
  T getOrInit(T Function() func) {
    if (_val != null) {
      return _val!;
    }
    _val = func();
    return _val!;
  }

  @override
  Result<T, E> getOrTryInit<E extends Object>(Result<T, E> Function() f) {
    if (_val != null) {
      return Ok(_val!);
    }
    final result = f();
    if (result.isOk()) {
      _val = result.unwrap();
      return Ok(_val!);
    }
    return result;
  }

  @override
  T? setOrNull(T value) {
    if (_val != null) {
      return null;
    }
    _val = value;
    return value;
  }

  @override
  Option<T> setOrOption(T value) {
    if (_val != null) {
      return None;
    }
    _val = value;
    return Some(value);
  }

  @override
  T? takeOrNull() {
    final val = _val;
    _val = null;
    return val;
  }

  @override
  Option<T> takeOrOption() {
    if (_val == null) {
      return None;
    }
    final val = _val;
    _val = null;
    return Some(val!);
  }

  @override
  bool isSet() {
    return _val == null ? false : true;
  }

  @override
  int get hashCode {
    final valueHash = _val?.hashCode ?? 0;
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
    return (_val == null
        ? "$runtimeType"
        : "$runtimeType($_val)");
  }
}
