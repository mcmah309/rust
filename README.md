# rust_core

[![Pub Version](https://img.shields.io/pub/v/rust_core.svg)](https://pub.dev/packages/rust_core)
[![Dart Package Docs](https://img.shields.io/badge/documentation-pub.dev-blue.svg)](https://pub.dev/documentation/rust_core/latest/)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://github.com/mcmah309/rust_core/actions/workflows/dart.yml/badge.svg)](https://github.com/mcmah309/rust_core/actions)

Implementing Rust's Core Library in Dart.

`rust_core` provides a Dart-friendly implementation of Rust's core library, enabling idiomatic programming with 
predictable control flow. Rust's functionalities are carefully adapted to Dart's paradigms, focusing on smooth 
and language-compatible integration.

## Highlights
### Libraries

| [Result] | [Option] | [Cell] | [Slice] | [Iter] | [Panic] | [Typedefs] |

🔥 **Extensive Extensions:** Dozens of additional extensions with hundreds of methods tailored for Dart. These 
extensions are designed for maximum composability, addressing specific scenarios.

🚀 **Dart Friendly:** Developed with ergonomics in mind. e.g. Dual Support for `Option` and Nullable Types. If a method or extension exists for `Option<T>`,
it's also available for `T?`.

🧪 **Robust Testing:** Every feature tested. Around 400 meaningful tests. Reliability and performance in every feature.

### Official Packages Based Off rust_core
| Library | Description |
| ------- | ----------- |
| [anyhow] | Idiomatic error handling capabilities to make your code safer, more maintainable, and errors easier to debug. |
| [anyhow_logging] | Dynamic logging utility that allows you to log exactly what you want.  |
| [rust_std] | Implementation of Rust's standard library in Dart. |
| [tapper] | Extension methods on all types that allow transparent, temporary, inspection/mutation (tapping), transformation (piping), or type conversion. |


[Cell]: https://github.com/mcmah309/rust_core/tree/master/lib/src/cell
[Option]: https://github.com/mcmah309/rust_core/tree/master/lib/src/option
[Panic]: https://github.com/mcmah309/rust_core/tree/master/lib/src/panic
[Result]: https://github.com/mcmah309/rust_core/tree/master/lib/src/result
[Typedefs]: https://github.com/mcmah309/rust_core/tree/master/lib/src/typedefs
[Iter]: https://github.com/mcmah309/rust_core/tree/master/lib/src/iter
[Slice]: https://github.com/mcmah309/rust_core/tree/master/lib/src/slice


[anyhow]: https://pub.dev/packages/anyhow
[anyhow_logging]: https://pub.dev/packages/anyhow_logging
[rust_std]: https://pub.dev/packages/rust_std
[tapper]: https://pub.dev/packages/tapper