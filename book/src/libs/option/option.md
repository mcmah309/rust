# Option
***
Option represents the union of two types - `Some<T>` and `None`. An `Option<T>` is an extension type of `T?`. Therefore, `Option`
has zero runtime cost and has one big advantage over `T?`, you can chain null specific operations!

rust_core support nullable and `Option` implementations of classes and methods for ergonomic convenience where possible, but you
can easily switch between the two with `toOption` and `toNullable` (or you can use `.v` directly).

### Usage
The `Option` Type and features work very similar to [Result](../result/result.md). We are able to chain operations in a safe way without
needing a bunch of `if` statements to check if a value is null.

```dart
Option<int> intOptionFunc() => None;
double halfVal(int val) => val/2;
Option<double> val = intOptionFunc()
    .map(halfVal);
expect(val.unwrapOr(2), 2);
```
See the [docs](https://pub.dev/documentation/rust_core/latest/option/option-library.html) for all methods and extensions.

You can also use Option in pattern matching
```dart
switch(Some(2)){
  case Some(:final v):
    // do something
  default:
    // do something
}
```
or
```dart
final x = switch(Some(2)){
  Some(:final v) => "some"
  _ => "none"
}
```

### Early Return Key Notation
Option also supports "Early Return Key Notation" (ERKN), which is a derivative of "Do Notation". It allows a 
function to return early if the value is `None`, and otherwise safely access the inner value directly without needing to unwrap or type check.
```dart
Option<int> intNone() => None;
Option<double> earlyReturn(int val) => Option(($) { // Early Return Key
  // Returns here
  double x = intNone()[$].toDouble();
  return Some(val + x);
});
expect(earlyReturn(2), None);
```
This is a powerful concept and make you code much more concise without losing any safety.

For async, use `Option.async` e.g.
```dart
FutureOption<double> earlyReturn() => Option.async(($) async {
  ...
});
```

### To Option or Not To Option
As mentioned `Option<T>` is an extension type of `T?` so they can be used interchangeably with no runtime cost.
```dart
Option<int> intNone() => None;
Option<int> option = intNone();
int? nullable = option.v;
nullable = option.toNullable(); // or
nullable = option as int?; // or
option = Option.from(nullable);
option = nullable as Option<int>; // or
```
If Dart already supports nullable types, why use an option type? - with null, chaining null specific operations is not possible and the only alternate solution is a bunch of if statements and implicit and explicit type promotion. The `Option` type solves these issues.
```dart
final x;
final y;
switch(optionFunc1().map((e) => e + " added string").zip(optionFunc2())){
  case Some(:final v):
    (x, y) = v;
  default:
    return
}
// use x and y
```
or if using early return notation.
```dart
final (x,y) = optionFunc1().map((e) => e + " added string").zip(optionFunc2())[$];
// use x and y
```
vs
```dart
final x = optionFunc1();
if (x == null) {
  return;
}
else {
  x = x + " added string";
}
final y = optionFunc2();
if (y == null) {
  return;
}
// use x and y
```
With `Option` you will also never get another null assertion error again.

As in the previous example, it is recommended to use the `Option` type as the return type, since it allows 
early return and chaining operations. But the choice is up to the developer.