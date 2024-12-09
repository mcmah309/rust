// ignore_for_file: library_private_types_in_public_api

part of 'iterator.dart';

extension Iter$IterableExtension<T> on Iterable<T> {
  /// Returns an [Iter] over the [Iterable].
  @pragma("vm:prefer-inline")
  Iter<T> iter() => Iter<T>(iterator);
}

extension Iter$IteratorExtension<T> on Iterator<T> {
  /// Returns an [Iter] for this [Iterator].
  @pragma("vm:prefer-inline")
  Iter<T> iter() => Iter<T>(this);
}

extension Iter$IterIterableExtension<T> on Iter<Iterable<T>> {
  /// Flatten an iterator of iterators into a single iterator.
  @pragma("vm:prefer-inline")
  Iter<T> flatten() {
    return Iter(_flattenHelper().iterator);
  }

  Iterable<T> _flattenHelper() sync* {
    for (final iterator in this) {
      for (final value in iterator) {
        yield value;
      }
    }
  }
}

extension Iter$IterNullable<T> on Iter<T?> {
  @pragma("vm:prefer-inline")
  Iter<Option<T>> toOptions() {
    return map((nullable) => Option.of(nullable));
  }
}

extension Iter$IterableNullable<T> on Iterable<T?> {
  @pragma("vm:prefer-inline")
  Iterable<Option<T>> toOptions() {
    return map((nullable) => Option.of(nullable));
  }
}

extension Iter$IterOption<T> on Iter<Option<T>> {
  @pragma("vm:prefer-inline")
  Iter<T?> toNullables() {
    return map((opt) => opt.toNullable());
  }
}

extension Iter$IterableOption<T> on Iterable<Option<T>> {
  @pragma("vm:prefer-inline")
  Iterable<T?> toNullables() {
    return map((opt) => opt.toNullable());
  }
}

extension Iter$IterComparableOtherExtension<U, T extends Comparable<U>> on Iter<T> {
  /// Lexicographically compares the elements of this Iterator with those of another.
  /// Less = -1
  /// Equal = 0
  /// Greater = 1
  int cmp(Iterator<U> other) {
    while (true) {
      if (moveNext()) {
        if (other.moveNext()) {
          final cmp = current.compareTo(other.current);
          if (cmp != 0) {
            return cmp;
          }
        } else {
          return 1;
        }
      } else {
        if (other.moveNext()) {
          return -1;
        } else {
          return 0;
        }
      }
    }
  }

  /// Determines if the elements of this Iterator are lexicographically greater than or equal to those of another.
  @pragma("vm:prefer-inline")
  bool ge(Iterator<U> other) {
    return cmp(other) >= 0;
  }

  /// Determines if the elements of this Iterator are lexicographically greater than those of another.
  @pragma("vm:prefer-inline")
  bool gt(Iterator<U> other) {
    return cmp(other) > 0;
  }

  /// Determines if the elements of this Iterator are lexicographically less or equal to those of another.
  @pragma("vm:prefer-inline")
  bool le(Iterator<U> other) {
    return cmp(other) <= 0;
  }

  /// Determines if the elements of this Iterator are lexicographically less than those of another.
  @pragma("vm:prefer-inline")
  bool lt(Iterator<U> other) {
    return cmp(other) < 0;
  }

  /// Determines if the elements of this Iterator are not equal to those of another.
  @pragma("vm:prefer-inline")
  bool ne(Iterator<U> other) {
    return cmp(other) != 0;
  }
}

extension Iter$IterComparableSelfExtension<T extends Comparable<T>> on Iter<T> {
  /// Checks if the elements of this iterator are sorted.
  /// That is, for each element a and its following element b, a <= b must hold. If the iterator yields exactly zero or one element, true is returned.
  bool isSorted() {
    while (moveNext()) {
      var prevVal = current;
      if (moveNext()) {
        if (prevVal.compareTo(current) > 0) {
          return false;
        }
      }
    }
    return true;
  }

  /// {@template Iter$IterComparableSelfExtension.max}
  /// Returns the maximum element of an iterator.
  /// {@endtemplate}
  T? max() {
    if (!moveNext()) {
      return null;
    }
    var max = current;
    while (moveNext()) {
      if (current.compareTo(max) > 0) {
        max = current;
      }
    }
    return max;
  }

  /// {@macro Iter$IterComparableSelfExtension.max}
  Option<T> maxOpt() {
    if (!moveNext()) {
      return None;
    }
    var max = current;
    while (moveNext()) {
      if (current.compareTo(max) > 0) {
        max = current;
      }
    }
    return Some(max);
  }

  /// {@template Iter$IterComparableSelfExtension.min}
  /// Returns the minimum element of an iterator.
  /// {@endtemplate}
  T? min() {
    if (!moveNext()) {
      return null;
    }
    var min = current;
    while (moveNext()) {
      if (current.compareTo(min) < 0) {
        min = current;
      }
    }
    return min;
  }

  /// {@macro Iter$IterComparableSelfExtension.min}
  Option<T> minOpt() {
    if (!moveNext()) {
      return None;
    }
    var min = current;
    while (moveNext()) {
      if (current.compareTo(min) < 0) {
        min = current;
      }
    }
    return Some(min);
  }
}

/// {@template null_option_correctness}
/// Methods only implemented when [T] is a concrete type (non-nullable).
/// Why: Correctness of code and reduces bugs.
/// e.g. if `nth` returns null on a nullable iterable, the nth element is 
/// either null or the iterable does not have n elements. While if it returns Option, if the element
/// is null it returns `Some(null)` and if it does not have n elements it returns `None`
/// {@endtemplate}
extension Iter$IterConcreteExtension<T extends Object> on Iter<T> {
  /// If the iterator is empty, returns null. Otherwise, returns the next value.
  @pragma("vm:prefer-inline")
  T? next() {
    if (moveNext()) {
      return current;
    }
    return null;
  }

  /// {@template Iter.find}
  /// Searches for an element of an iterator that satisfies a predicate.
  /// {@endtemplate}
  T? find(bool Function(T) f) {
    for (final element in this) {
      if (f(element)) {
        return element;
      }
    }
    return null;
  }

  /// {@template Iter.findMap}
  /// Applies the function to the elements of iterator and returns the first non-(none/null) result.
  /// {@endtemplate}
  U? findMap<U>(U? Function(T) f) {
    for (final element in this) {
      final result = f(element);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  /// {@template Iter.filterMap}
  /// Creates an iterator that both filters and maps.
  /// {@endtemplate}
  /// The returned iterator yields only the values for which the supplied closure returns a non-null value.
  @pragma("vm:prefer-inline")
  Iter<U> filterMap<U>(U? Function(T) f) {
    return Iter.fromIterable(_filterMapHelper(f));
  }

  Iterable<U> _filterMapHelper<U>(U? Function(T) f) sync* {
    for (final element in this) {
      final nullable = f(element);
      if (nullable != null) {
        yield nullable;
      }
    }
  }

  /// {@template Iter.lastOrNull}
  /// Consumes the iterator and returns the last element.
  /// {@endtemplate}
  T? lastOrNull() {
    if (moveNext()) {
      var last = current;
      while (moveNext()) {
        last = current;
      }
      return last;
    }
    return null;
  }

  /// {@template Iter.mapWhile}
  /// Creates an iterator that both yields elements based on a predicate and maps.
  /// It will call this closure on each element of the iterator, and yield elements while it returns Some(_).
  /// {@endtemplate}
  Iter<U> mapWhile<U>(U? Function(T) f){
    return Iter.fromIterable(_mapWhileHelper(f));
  }

  Iterable<U> _mapWhileHelper<U>(U? Function(T) f) sync* {
    for (final element in this) {
      final nullable = f(element);
      if (nullable != null) {
        yield nullable;
      } else {
        break;
      }
    }
  }

  /// {@template Iter.maxBy}
  /// Returns the element that gives the maximum value with respect to the specified comparison function.
  /// {@endtemplate}
  T? maxBy(int Function(T, T) f) {
    T max;
    if (moveNext()) {
      max = current;
    } else {
      return null;
    }
    for (final element in this) {
      if (f(element, max) > 0) {
        max = element;
      }
    }
    return max;
  }

  /// {@template Iter.maxByKey}
  /// Returns the element that gives the maximum value from the specified function.
  /// {@endtemplate}
  T? maxByKey<U extends Comparable<U>>(U Function(T) f) {
    T max;
    U maxVal;
    if (moveNext()) {
      max = current;
      maxVal = f(max);
    } else {
      return null;
    }
    for (final element in this) {
      final val = f(element);
      if (val.compareTo(maxVal) > 0) {
        max = element;
        maxVal = val;
      }
    }
    return max;
  }

  /// {@template Iter.minBy}
  /// Returns the element that gives the minimum value with respect to the specified comparison function.
  /// {@endtemplate}
  T? minBy(int Function(T, T) f) {
    T min;
    if (moveNext()) {
      min = current;
    } else {
      return null;
    }
    for (final element in this) {
      if (f(element, min) < 0) {
        min = element;
      }
    }
    return min;
  }

  /// {@template Iter.minByKey}
  /// Returns the element that gives the minimum value from the specified function.
  /// {@endtemplate}
  T? minByKey<U extends Comparable<U>>(U Function(T) f) {
    T min;
    U minVal;
    if (moveNext()) {
      min = current;
      minVal = f(min);
    } else {
      return null;
    }
    for (final element in this) {
      final val = f(element);
      if (val.compareTo(minVal) < 0) {
        min = element;
        minVal = val;
      }
    }
    return min;
  }

  /// {@template Iter.nth}
  /// Returns the nth element of the iterator.
  /// Like most indexing operations, the count starts from zero, so nth(0) returns the first value, nth(1) the second, and so on.
  /// nth() will return None if n is greater than or equal to the length of the iterator.
  /// {@endtemplate}
  T? nth(int n) {
    if (n < 0) {
      return null;
    }
    var index = 0;
    for (final element in this) {
      if (index == n) {
        return element;
      }
      index++;
    }
    return null;
  }

  /// {@template Iter.position}
  /// Searches for an element in an iterator, returning its index.
  /// {@endtemplate}
  int? position(bool Function(T) f) {
    var index = 0;
    for (final element in this) {
      if (f(element)) {
        return index;
      }
      index++;
    }
    return null;
  }

  /// {@template Iter.rposition}
  /// Searches for an element in an iterator from the right, returning its index.
  /// Recommended to use with a list, as it is more efficient, otherwise use [positionOpt].
  /// {@endtemplate}
  int? rposition(bool Function(T) f) {
    final list = toList(growable: false).reversed;
    var index = list.length - 1;
    for (final element in list) {
      if (f(element)) {
        return index;
      }
      index--;
    }
    return null;
  }
}

extension Iter$IterNullableExtension<T extends Object> on Iter<T?> {
  /// Creates an iterator which ends after the first None.
  Iter<T> fuse() {
    return Iter(_fuseHelper().iterator);
  }

  Iterable<T> _fuseHelper() sync* {
    for (final nullable in this) {
      if (nullable == null) {
        break;
      }
      yield nullable;
    }
  }
}

extension Iter$IterOptionExtension<T extends Object> on Iter<Option<T>> {
  /// Creates an iterator which ends after the first None.
  Iter<T> fuse() {
    return Iter(_fuseHelper().iterator);
  }

  Iterable<T> _fuseHelper() sync* {
    for (final option in this) {
      if (option.isNone()) {
        break;
      }
      yield option.unwrap();
    }
  }
}

extension Iter$IterResultExtension<T, E extends Object> on Iter<Result<T, E>> {
  /// Transforms an iterator into a collection, short circuiting if a Err is encountered.
  Result<List<T>, E> tryCollect() {
    final result = <T>[];
    for (final res in this) {
      if (res.isErr()) {
        return res.intoUnchecked();
      }
      result.add(res.unwrap());
    }
    return Ok(result);
  }

  /// {@template Iter$IterResultExtension.tryCollectOpt}
  /// Applies function to the elements of iterator and returns the first true result or the first Err element.
  /// {@endtemplate}
  Result<T?, E> tryFind(bool Function(T) f) {
    for (final res in this) {
      if (res.isErr()) {
        return res.intoUnchecked();
      }
      if (f(res.unwrap())) {
        return Ok(res.unwrap());
      }
    }
    return Ok(null);
  }

  /// {@macro Iter$IterResultExtension.tryCollectOpt}
  Result<Option<T>, E> tryFindOpt(bool Function(T) f) {
    for (final res in this) {
      if (res.isErr()) {
        return res.intoUnchecked();
      }
      if (f(res.unwrap())) {
        return Ok(Some(res.unwrap()));
      }
    }
    return Ok(None);
  }

  /// An iterator method that applies a function producing a single value, returns Err is encountered.
  Result<U, E> tryFold<U>(U initial, U Function(U, T) f) {
    var accum = initial;
    for (final res in this) {
      if (res.isErr()) {
        return res.intoUnchecked();
      }
      accum = f(accum, res.unwrap());
    }
    return Ok(accum);
  }

  /// An iterator method that applies a function, stopping at the first Err and returning that Err.
  Result<(), E> tryForEach(void Function(T) f) {
    for (final res in this) {
      if (res.isErr()) {
        return res.intoUnchecked();
      }
      f(res.unwrap());
    }
    return const Ok(());
  }

  /// {@template Iter$IterResultExtension.tryReduce}
  /// Reduces the elements to a single one by repeatedly applying a reducing operation. If a Err is encountered it is returned.
  /// {@endtemplate}
  Result<T?, E> tryReduce(T Function(T, T) f) {
    if (!moveNext()) {
      return Ok(null);
    }
    var accumRes = current;
    if (accumRes.isErr()) {
      return accumRes.intoUnchecked();
    }
    var accum = accumRes.unwrap();
    while (moveNext()) {
      if (current.isErr()) {
        return current.intoUnchecked();
      }
      accum = f(accum, current.unwrap());
    }
    return Ok(accum);
  }

  /// {@macro Iter$IterResultExtension.tryReduce}
  Result<Option<T>, E> tryReduceOpt(T Function(T, T) f) {
    if (!moveNext()) {
      return Ok(None);
    }
    var accumRes = current;
    if (accumRes.isErr()) {
      return accumRes.intoUnchecked();
    }
    var accum = accumRes.unwrap();
    while (moveNext()) {
      if (current.isErr()) {
        return current.intoUnchecked();
      }
      accum = f(accum, current.unwrap());
    }
    return Ok(Some(accum));
  }
}

extension Iter$IterExtension<T> on Iter<T> {
  /// {@template Iter$IterExtension.all}
  /// Applies function to the elements of iterator and returns the first true result or the first error.
  /// {@endtemplate}
  Result<T?, E> tryFind<E extends Object>(Result<bool, E> Function(T) f) {
    for (final res in this) {
      final found = f(res);
      if (found.isErr()) {
        return found.intoUnchecked();
      }
      if (found.unwrap()) {
        return Ok(res);
      }
    }
    return Ok(null);
  }

  /// {@macro Iter$IterExtension.all}
  Result<Option<T>, E> tryFindOpt<E extends Object>(Result<bool, E> Function(T) f) {
    for (final res in this) {
      final found = f(res);
      if (found.isErr()) {
        return found.intoUnchecked();
      }
      if (found.unwrap()) {
        return Ok(Some(res));
      }
    }
    return Ok(None);
  }

  /// An iterator method that applies a function as long as it returns successfully, producing a single, final value.
  Result<U, E> tryFold<U, E extends Object>(U initial, Result<U, E> Function(U, T) f) {
    var accum = initial;
    for (final res in this) {
      final folded = f(accum, res);
      if (folded.isErr()) {
        return folded.intoUnchecked();
      }
      accum = folded.unwrap();
    }
    return Ok(accum);
  }

  /// An iterator method that applies a fallible function to each item in the iterator, stopping at the first error and returning that error.
  Result<(), E> tryForEach<E extends Object>(Result<(), E> Function(T) f) {
    for (final res in this) {
      final result = f(res);
      if (result.isErr()) {
        return result.intoUnchecked();
      }
    }
    return const Ok(());
  }

  /// {@template Iter$IterExtension.tryReduce}
  /// Reduces the elements to a single one by repeatedly applying a reducing operation. If the closure returns a failure, the failure is propagated back to the caller immediately.
  /// {@endtemplate}
  Result<T?, E> tryReduce<E extends Object>(Result<T, E> Function(T, T) f) {
    if (!moveNext()) {
      return Ok(null);
    }
    var accum = current;
    while (moveNext()) {
      final next = current;
      final res = f(accum, next);
      if (res.isErr()) {
        return res.intoUnchecked();
      }
      accum = res.unwrap();
    }
    return Ok(accum);
  }

  /// {@macro Iter$IterExtension.tryReduce}
  Result<Option<T>, E> tryReduceOpt<E extends Object>(Result<T, E> Function(T, T) f) {
    if (!moveNext()) {
      return Ok(None);
    }
    var accum = current;
    while (moveNext()) {
      final next = current;
      final res = f(accum, next);
      if (res.isErr()) {
        return res.intoUnchecked();
      }
      accum = res.unwrap();
    }
    return Ok(Some(accum));
  }
}

extension Iter$IterRecord2Extension<T, U> on Iter<(T, U)> {
  /// Converts an iterator of pairs into a pair of containers.
  (List<T>, List<U>) unzip() {
    final first = <T>[];
    final second = <U>[];
    for (final (t, u) in this) {
      first.add(t);
      second.add(u);
    }
    return (first, second);
  }
}

//************************************************************************//

/// Overrides built in extension Iter$methods on nullable [Iterable].
extension Iter$IterNullableExtensionOverride<T extends Object> on Iter<T?> {
  /// Returns an Iter over the non-null elements of this iterator.
  Iter<T> nonNulls() => Iter.fromIterable(NullableIterableExtensions(this).nonNulls);
}

/// Overrides built in extension Iter$methods on [Iterable].
extension Iter$IterExtensionOverride<T> on Iter<T> {
  /// Returns an Iter over the elements of this iterable, paired with their index.
  Iter<(int, T)> get indexed => Iter.fromIterable(IterableExtensions(this).indexed);

  @Deprecated(
      "FirstOrNull is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use next() instead.")
  Never firstOrNull() =>
      throw "FirstOrNull is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use next() instead.";

  /// Returns the last element of this iterable, or `null` if the iterable is empty.
  T? lastOrNull() => IterableExtensions(this).lastOrNull;

  @Deprecated(
      "SingleOrNull is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use next() instead.")
  Never singleOrNull() =>
      throw "SingleOrNull is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use peekable() instead.";

  @Deprecated(
      "ElementAtOrNull is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use nth() instead.")
  Never elementAtOrNull(int index) =>
      throw "ElementAtOrNull is not supported as it would require consuming part of the iterator, which is likely not the users intent. Use nth() instead.";
}
