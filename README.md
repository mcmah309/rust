<img src="https://raw.githubusercontent.com/mcmah309/rust/master/.github/DR.png" width="500px">

[![Pub Version](https://img.shields.io/pub/v/rust.svg)](https://pub.dev/packages/rust)
[![Dart Package Docs](https://img.shields.io/badge/documentation-pub.dev-blue.svg)](https://pub.dev/documentation/rust/latest/)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://github.com/mcmah309/rust/actions/workflows/test.yml/badge.svg)](https://github.com/mcmah309/rust/actions)

[rust](https://github.com/mcmah309/rust) is a pure Dart implementation of patterns found in Rust's core library, bringing the power of Rust to Dart!

Types include [Result](https://mcmah309.github.io/rust/libs/result/result.html), [Option](https://mcmah309.github.io/rust/libs/option/option.html), [Cell](https://mcmah309.github.io/rust/libs/cell/cell.html), [Slice](https://mcmah309.github.io/rust/libs/slice/slice.html), [Array](https://mcmah309.github.io/rust/libs/array/array.html), [Iterator](https://mcmah309.github.io/rust/libs/iter/iter.html), [Channels](https://mcmah309.github.io/rust/libs/sync/channels.html), [Mutex](https://mcmah309.github.io/rust/libs/sync/mutex.html), and more.

See the [Rust Core Book 📖](https://mcmah309.github.io/rust)

## Example
> Goal: Get the index of every "!" in a string not followed by a "?"

**Rust:**
```rust
use std::iter::Peekable;

fn main() {
  let string = "kl!sd!?!";
  let mut answer: Vec<usize> = Vec::new();
  let mut iter: Peekable<_> = string
      .chars()
      .map_windows(|w: &[char; 2]| *w)
      .enumerate()
      .peekable();

  while let Some((index, window)) = iter.next() {
      match window {
          ['!', '?'] => continue,
          ['!', _] => answer.push(index),
          [_, '!'] if iter.peek().is_none() => answer.push(index + 1),
          _ => continue,
      }
  }
  assert_eq!(answer, [2, 7]);
}
```
**Dart:**
```dart
import 'package:rust/rust.dart';

void main() {
  String string = "kl!sd!?!";
  List<int> answer = [];
  Peekable<(int, Arr<String>)> iter = string
      .chars()
      .mapWindows(2, identity)
      .enumerate()
      .peekable();
  while (iter.moveNext()) {
    final (index, window) = iter.current;
    switch (window) {
      case ["!", "?"]:
        break;
      case ["!", _]:
        answer.add(index);
      case [_, "!"] when iter.peek().isNone():
        answer.add(index + 1);
    }
  }
  expect(answer, [2, 7]);
}
```

## Project Goals
rust's primary goal is to give Dart developers access to powerful tools previously only available to Rust developers.

To accomplish this, Rust's functionalities are carefully adapted to Dart's paradigms, focusing on a smooth idiomatic language-compatible integration.
The result is developers now have a whole new toolset to tackle problems in Dart.

True to the Rust philosophy, rust strives to bring reliability and performance in every feature. Every feature is robustly tested. Over 500 meaningful test suites and counting.