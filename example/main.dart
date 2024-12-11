// ignore_for_file: unused_local_variable

import 'package:rust/rust.dart';

void main() {
  readmeExample();
  usingTheEarlyReturnKeyExample();
  usingRegularPatternMatchingExample();
  usingFunctionChainingExample();
  iteratorExample();
  sliceExample();

  /// Visit the book to see more!
}

void readmeExample() {
  final string = "kl!sd!?!";
  Vec<int> answer = [];
  Peekable<(int, Arr<String>)> iter =
      string.chars().mapWindows(2, identity).enumerate().peekable();

  while (iter.moveNext()) {
    final (index, window) = iter.current;
    switch (window) {
      case ["!", "?"]:
        break;
      case ["!", _]:
        answer.push(index);
      case [_, "!"] when iter.peekOpt().isNone():
        answer.push(index + 1);
    }
  }
  assert(answer.length == 2);
  assert(answer[0] == 2);
  assert(answer[1] == 7);
}

Result<int, String> usingTheEarlyReturnKeyExample() => Result(($) {
      // Early Return Key
      // Will return here with 'Err("error")'
      int x = willAlwaysReturnErr()[$].toInt();
      return Ok(x);
    });

Result<int, String> usingRegularPatternMatchingExample() {
  switch (willAlwaysReturnErr()) {
    case Err(v: final error):
      return Err(error);
    case Ok(v: final okay):
      return Ok(okay.toInt());
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
  Option<int> next = iter.nextOpt();
  collect.add(next.unwrap());
  next = iter.nextOpt();
  collect.add(next.unwrap());
  while (iter.moveNext()) {
    collect.add(iter.current * iter.current);
  }
}

void sliceExample() {
  var list = [1, 2, 3, 4, 5];
  var slice = Slice(list, 1, 4);
  var taken = slice.takeLastOpt();
  slice[1] = 10;
  assert(list[2] == 10);
}

Result<double, String> willAlwaysReturnErr() => Err("error");
