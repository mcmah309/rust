import 'package:rust_core/panic.dart';
import 'package:rust_core/slice.dart';

// https://stackoverflow.com/a/60358200
const int _intMaxValue = 9007199254740991;

sealed class RangeBounds {
  Iterable<T> list<T>(List<T> list);

  Iterable<T> slice<T>(Slice<T> slice);
}

class RangeIterator implements Iterator<int> {
  final int start;
  final int end;
  int _current;

  RangeIterator(this.start, this.end) : _current = start >= end ? end - 1 : start - 1;

  @override
  int get current => _current;

  @override
  bool moveNext() {
    if (_current + 1 == end) {
      return false;
    }
    _current++;
    return true;
  }
}

/// A (half-open) range bounded inclusively below and exclusively above (start..end).
/// The range start..end contains all values with start <= x < end. It is empty if start >= end.
class Range extends Iterable<int> implements RangeBounds {
  final int start;
  final int end;

  const Range(this.start, this.end);

  @override
  RangeIterator get iterator => RangeIterator(start, end);

  @override
  Iterable<T> list<T>(List<T> list) sync* {
    _checkValidRange(start, end, list.length);
    for (int i = start; i < end; i++) {
      yield list[i];
    }
  }

  @override
  Iterable<T> slice<T>(Slice<T> slice) sync* {
    final len = slice.len();
    _checkValidRange(start, end, len);
    for (int i = start; i < end; i++) {
      yield slice.getUnchecked(i);
    }
  }
}

class RangeFrom extends Iterable<int> implements RangeBounds {
  final int start;

  const RangeFrom(this.start);

  @override
  Iterator<int> get iterator => RangeIterator(start, _intMaxValue);

  @override
  Iterable<T> list<T>(List<T> list) sync* {
    final len = list.length;
    _checkStart(start, len);
    for (int i = start; i < len; i++) {
      yield list[i];
    }
  }

  @override
  Iterable<T> slice<T>(Slice<T> slice) sync* {
    final len = slice.len();
    _checkStart(start, len);
    for (int i = start; i < len; i++) {
      yield slice.getUnchecked(i);
    }
  }
}

class RangeFull extends Iterable<int> implements RangeBounds {
  RangeFull();

  @override
  Iterator<int> get iterator =>
      panic("'FullRange' cannot serve as an iterator because it has not starting point.");

  @override
  Iterable<T> list<T>(List<T> list) => list;

  @override
  Iterable<T> slice<T>(Slice<T> slice) => slice;
}

class RangeInclusive extends Range {
  const RangeInclusive(int start, int end) : super(start, end + 1);
}

@pragma("vm:prefer-inline")
void _checkValidRange(int start, int end, int length) {
  _checkStart(start, length);
  _checkEnd(start, end, length);
}

@pragma("vm:prefer-inline")
void _checkStart(int start, int length) {
  if (0 > start || start > length) {
    panic("'start' is not valid");
  }
}

@pragma("vm:prefer-inline")
void _checkEnd(int start, int end, int length) {
  if (start > end || end > length) {
    panic("'end' is not valid");
  }
}

/// A generator over a range by a step size.
/// If [end] is not provided, the generated range will be [0..startOrEnd) if [startOrEnd] > 0, and
/// nothing is generated otherwise.
/// If [step] is not provided, step will be `-1` if `0 > startOrEnd` and `1` if `0 < startOrEnd`.
/// For reference, it works the same as the python `range` function.
/// ```dart
/// range(end); // == range(0,end);
/// range(start, end);
/// range(start, end, step);
/// ```
// Dev Note: inlined for parameter optimization
@pragma("vm:prefer-inline")
Iterable<int> range(int startOrEnd, [int? end, int? step]) sync* {
  assert(!(end == null && step != null),
      "'step' cannot be given if 'end' is null. Step will be ignored in release mode.");
  if (step == 0) {
    panic("'step' cannot be zero");
  }
  if (end == null) {
    int current = 0;
    if (startOrEnd > 0) {
      do {
        yield current;
        current++;
      } while (current < startOrEnd);
    }
    return;
  }
  if (startOrEnd == end) {
    return;
  }
  if (startOrEnd < end) {
    if (step == null) {
      step = 1;
    } else if (step < 0) {
      return;
    }
    do {
      yield startOrEnd;
      startOrEnd += step;
    } while (startOrEnd < end);
  } else {
    if (step == null) {
      step = -1;
    } else if (step > 0) {
      return;
    }
    while (startOrEnd > end) {
      yield startOrEnd;
      startOrEnd += step;
    }
  }
}
