import 'package:rust/rust.dart';

/// A value which is initialized on the first access. Nullable implementation of [LazyCell]
///
/// Equality: Cells are equal if they have the same evaluated value or are unevaluated.
///
/// Hash: Cells hash to their evaluated value or hash the same if unevaluated.
class LazyCellNullable<T> {
  late final T _val;
  final T Function() _func;
  bool _isSet = false;

  LazyCellNullable(this._func);

  /// Lazily evaluates the function passed into the constructor. Equivalent to [call] but more explicit.
  @pragma("vm:prefer-inline")
  T force() => call();

  /// Lazily evaluates the function passed into the constructor.
  T call() {
    if (_isSet) {
      return _val!;
    }
    _isSet = true;
    _val = _func();
    return _val;
  }

  /// Returns true if this has already been called, otherwise false.
  @pragma("vm:prefer-inline")
  bool isEvaluated() {
    return _isSet;
  }

  @override
  int get hashCode {
    final valueHash = _isSet ? _val.hashCode : 0;
    return valueHash;
  }

  @override
  bool operator ==(Object other) {
    return other is LazyCellNullable<T> &&
        ((isEvaluated() && other.isEvaluated() && this() == other()) ||
            (!isEvaluated() && !other.isEvaluated()));
  }

  @override
  String toString() {
    return (_isSet ? "$runtimeType($_val)" : "$runtimeType");
  }
}
