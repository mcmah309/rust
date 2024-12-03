// ignore_for_file: unused_local_variable

import 'package:rust/rust.dart';

void main() {
  usingTheEarlyReturnKeyExample();
  usingRegularPatternMatchingExample();
  usingFunctionChainingExample();
  iteratorExample();
  sliceExample();

  /// Visit the book to see more!
}

Result<int, String> usingTheEarlyReturnKeyExample() => Result(($) {
      // Early Return Key
      // Will return here with 'Err("error")'
      int x = willAlwaysReturnErr()[$].toInt();
      return Ok(x);
    });

Result<int, String> usingRegularPatternMatchingExample() {
  switch (willAlwaysReturnErr()) {
    case Err(:final e):
      return Err(e);
    case Ok(:final o):
      return Ok(o.toInt());
  }
}

Result<int, String> usingFunctionChainingExample() =>
    willAlwaysReturnErr().map((e) => e.toInt());

void iteratorExample() {
  List<int> list = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  Iter<int> iter = list.iter();
  List<int> collect = [];
  for (final e in iter.take(5).map((e) => e * e)) {
    if (e.isEven) {
      collect.add(e);
    }
  }
  Option<int> next = iter.next();
  collect.add(next.unwrap());
  next = iter.next();
  collect.add(next.unwrap());
  while (iter.moveNext()) {
    collect.add(iter.current * iter.current);
  }
}

void sliceExample() {
  var list = [1, 2, 3, 4, 5];
  var slice = Slice(list, 1, 4);
  var taken = slice.takeLast();
  slice[1] = 10;
  assert(list[2] == 10);
}

Result<double, String> willAlwaysReturnErr() => Err("error");
