import 'package:rust/rust.dart';

/// A value which is asynchronously initialized on the first access. Non-nullable implementation of [LazyCellAsync]
///
/// Equality: Cells are equal if they have the same evaluated value or are unevaluated.
///
/// Hash: Cells hash to their evaluated value or hash the same if unevaluated.
class LazyCellAsync<T extends Object> implements LazyCellNullableAsync<T> {
  T? _val;
  final Future<T> Function() _func;

  LazyCellAsync(this._func);

  @override
  Future<T> force() async {
    if (_val == null) {
      _val = await _func();
      return _val!;
    }
    return _val!;
  }

  @override
  T call() {
    if (_val == null) {
      panic(
          "Cannot get the result of an async LazyCell synchronously if the value has not yet been computed asynchronously.");
    }
    return _val!;
  }

  @override
  @pragma("vm:prefer-inline")
  bool isEvaluated() {
    return _val == null ? false : true;
  }

  @override
  int get hashCode {
    final valueHash = _val?.hashCode ?? 0;
    return valueHash;
  }

  @override
  bool operator ==(Object other) {
    return other is LazyCellNullableAsync<T> &&
        ((isEvaluated() && other.isEvaluated() && this() == other()) ||
            (!isEvaluated() && !other.isEvaluated()));
  }

  @override
  String toString() {
    return (_val == null ? "$runtimeType" : "$runtimeType($_val)");
  }
}
