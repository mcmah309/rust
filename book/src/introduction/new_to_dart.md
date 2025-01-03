# New To Dart
***
Welcome to Dart!

Dart is a great language choice for fast cross platform development and scripting.
You'll find that rust is great start to learn Dart's semantics as you will feel like you are writing native rust.
rust will introduce you to a few new types you may find useful as a Dart developer:

| Rust Type         | Dart Equivalent | rust | Description                                             |
|-------------------|-----------------|----------------------|---------------------------------------------------------|
| `[T; N]`          | `const [...]`/`List<T>(growable: false)` | `Arr<T>`            | Fixed size array or list                                   |
| `Iterator<T>`     | `Iterator<T>`/`Iterable<T>`   |  `Iter<T>`                  | Consumable iteration
| `Option<T>`       | `T?`            | `Option<T>`                    | A type that may hold a value or none                   |
| `Result<T, E>`    |  - | `Result<T, E>`  | Type used for returning and propagating errors|                         |
| `[T]`             | - | `Slice<T>`                    | View into an array or list                                 |
| `Cell<T>`         | - | `Cell<T>`                    | Value wrapper, useful for primitives                                  |
| `channel<T>`      | - | `channel<T>` | Communication between produces and consumers
| `Mutex<T>`      | - | `Mutex` | Exclusion primitive useful for protecting critical sections
| `RwLock<T>`      | - | `RwLock` |  Exclusion primitive allowing multiple read operations and exclusive write operations
| `Path`            | - | `Path`  | Type for file system path manipulation and interaction
| `Vec<T>`          | `List<T>`       | `Vec<T>`                    | Dynamic/Growable array                              |

To learn more about the Dart programming language, checkout [dart.dev](https://dart.dev/language)!