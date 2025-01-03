import 'package:rust/rust.dart';

/// A fixed-size array, denoted as [T; N] in Rust.
extension type Arr<T>._(List<T> _list) implements Iterable<T> {
  @pragma("vm:prefer-inline")
  Arr(T defaultVal, int size)
      : _list = List.filled(size, defaultVal, growable: false);

  @pragma("vm:prefer-inline")
  const Arr.constant(this._list);

  @pragma("vm:prefer-inline")
  Arr.fromList(this._list);

  @pragma("vm:prefer-inline")
  Arr.empty() : _list = const [];

  @pragma("vm:prefer-inline")
  Arr.generate(int length, T Function(int) generator)
      : _list = List.generate(length, generator, growable: false);

  /// An array of [int] in the range [start..end), where start >= end or start <= end. [step] must be positive.
  @pragma("vm:prefer-inline")
  static Arr<int> range(int start, int end, {int step = 1}) {
    assert(step > 0, "'step' must be positive.");
    if (start < end) {
      return Arr<int>.generate(((end - start) + step - 1) ~/ step,
          (index) => start + (index * step));
    } else {
      return Arr<int>.generate(((start - end) + step - 1) ~/ step,
          (index) => start - (index * step));
    }
  }

  @pragma("vm:prefer-inline")
  T operator [](int index) => _list[index];

  @pragma("vm:prefer-inline")
  void operator []=(int index, T value) => _list[index] = value;

  @pragma("vm:prefer-inline")
  Slice<T> call(RangeBounds range) => range.slice(_list);

  // as_ascii: Will not be implemented, not possible in Dart
  // as_ascii_unchecked_mut: Will not be implemented, not possible in Dart
  // as_mut_slice: Will not be implemented, covered by `asSlice`

  @pragma("vm:prefer-inline")
  Slice<T> asSlice() => Slice.fromList(_list);

  @pragma("vm:prefer-inline")
  List<T> asList() => _list;

  @pragma("vm:prefer-inline")
  Slice<T> slice([int start = 0, int? end]) {
    end ??= length;
    return Slice(this._list, start, end);
  }

  // each_mut: Will not be implemented, not possible in Dart
  // each_ref: Will not be implemented, not possible in Dart

  /// Returns an array of the same size as self, with function f applied to each element in order.
  Arr<U> map<U>(U Function(T) f) {
    return Arr._(_list.map(f).toList(growable: false));
  }

  /// Divides array into two [Slice]s at index from end.
  /// The first will contain all indices from [0, N - M) (excluding the index N - M itself) and
  /// the second will contain all indices from [N - M, N) (excluding the index N itself).
  (Slice<T>, Slice<T>) rsplitSlice(int index) {
    assert(index >= 0 && index <= _list.length, "Index out of bounds");
    return (
      Slice(_list, 0, _list.length - index),
      Slice(_list, _list.length - index, _list.length)
    );
  }

  // rsplit_array_mut: Will not be implemented, not possible in Dart
  // rsplit_array_ref: Will not be implemented, not possible in Dart

  /// Divides array into two [Slice]s at index from start.
  /// The first will contain all indices from [0, M) (excluding the index M itself) and
  /// the second will contain all indices from [M, N) (excluding the index N itself).
  (Slice<T>, Slice<T>) splitSlice(int index) {
    assert(index >= 0 && index <= _list.length, "Index out of bounds");
    return (Slice(_list, 0, index), Slice(_list, index, _list.length));
  }

  // split_array_mut: Will not be implemented, not possible in Dart
  // split_array_ref: Will not be implemented, not possible in Dart
  // transpose: Will not be implemented, not possible in Dart

  /// A fallible function f applied to each element on this array in order to return an array the same size as this or the first error encountered.
  Result<Arr<S>, F> tryMap<S, F extends Object>(Result<S, F> Function(T) f) {
    List<S?> result = List.filled(_list.length, null, growable: false);
    for (int i = 0; i < _list.length; i++) {
      var res = f(_list[i]);
      if (res case Err()) {
        return res.into();
      }
      result[i] = res.unwrap();
    }
    return Ok(Arr._(result.cast<S>()));
  }

  /// Returns the first element of an iterator, None if empty.
  Option<T> get firstOrOption {
    final first = _list.firstOrNull;
    if (first == null) {
      return None;
    }
    return Some(first);
  }

  /// Returns the last element of an iterator, None if empty.
  Option<T> get lastOrOption {
    final last = _list.lastOrNull;
    if (last == null) {
      return None;
    }
    return Some(last);
  }

  /// Returns the single element of an iterator, null if this is empty or has more than one element.
  T? get singleOrNull {
    final firstTwo = _list.take(2).iterator;
    if (!firstTwo.moveNext()) {
      return null;
    }
    final first = firstTwo.current;
    if (!firstTwo.moveNext()) {
      return first;
    }
    return null;
  }

  /// Returns the single element of an iterator, None if this is empty or has more than one element.
  Option<T> get singleOrOption {
    final firstTwo = _list.take(2).iterator;
    if (!firstTwo.moveNext()) {
      return None;
    }
    final first = firstTwo.current;
    if (!firstTwo.moveNext()) {
      return Some(first);
    }
    return None;
  }

  // Iterable: Overriding iterable methods
  //************************************************************************//

  /// Returns true if the iterator is empty, false otherwise.
  @pragma("vm:prefer-inline")
  bool isEmpty() => _list.isEmpty;

  /// Returns true if the iterator is not empty, false otherwise.
  @pragma("vm:prefer-inline")
  bool isNotEmpty() => _list.isNotEmpty;

  @pragma("vm:prefer-inline")
  Iterator<T> get iterator => _list.iterator;

  /// Returns the length of an iterator.
  @pragma("vm:prefer-inline")
  int len() => _list.length;

  // bool any(bool Function(T) f) {
  //   return list.any(f);
  // }

  /// Casts this Arr<T> to an Arr<U>.
  @pragma("vm:prefer-inline")
  Arr<U> cast<U>() => Arr.fromList(_list.cast<U>());

  // bool contains(Object? element) => list.contains(element);

  // T elementAt(int index) => list.elementAt(index);

  // bool every(bool Function(T) f) => list.every(f);

  @pragma("vm:prefer-inline")
  Iter<U> expand<U>(Iterable<U> Function(T) f) =>
      Iter(_list.expand(f).iterator);

  // T firstWhere(bool Function(T) f, {T Function()? orElse}) => list.firstWhere(f, orElse: orElse);

  // U fold<U>(U initialValue, U Function(U previousValue, T element) f) => list.fold(initialValue, f);

  @pragma("vm:prefer-inline")
  Iter<T> followedBy(Iterable<T> other) =>
      Iter(_list.followedBy(other).iterator);

  // void forEach(void Function(T) f) => list.forEach(f);

  // String join([String separator = '']) => list.join(separator);

  // T lastWhere(bool Function(T) f, {T Function()? orElse}) => list.lastWhere(f, orElse: orElse);

  // Iter<U> map<U>(U Function(T) f) => list.map(f));

  // T reduce(T Function(T, T) f) => list.reduce(f);

  // T singleWhere(bool Function(T) f, {T Function()? orElse}) => list.singleWhere(f, orElse: orElse);

  @pragma("vm:prefer-inline")
  Iter<T> skip(int count) => Iter(_list.skip(count).iterator);

  @pragma("vm:prefer-inline")
  Iter<T> skipWhile(bool Function(T) f) => Iter(_list.skipWhile(f).iterator);

  @pragma("vm:prefer-inline")
  Iter<T> take(int count) => Iter(_list.take(count).iterator);

  @pragma("vm:prefer-inline")
  Iter<T> takeWhile(bool Function(T) f) => Iter(_list.takeWhile(f).iterator);

  // List<T> toList({bool growable = true}) => list.toList(growable: growable);

  // Set<T> toSet() => list.toSet();

  // String toString() => list.toString();

  @pragma("vm:prefer-inline")
  Iter<T> where(bool Function(T) f) => Iter(_list.where(f).iterator);

  @pragma("vm:prefer-inline")
  Iter<U> whereType<U>() => Iter(_list.whereType<U>().iterator);

  //************************************************************************//

  operator +(Arr<T> other) => Arr._(_list + other._list);
}
