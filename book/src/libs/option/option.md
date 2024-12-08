# Option
***
`Option` represents the union of two types - `Some<T>` and `None`.

## If Dart Has Nullable Types Why Ever Use `Option`?

`Option` is wrapper around a value that may or may be set. A nullable type is a type that may or may not be set.
This small distinction leads to some useful differences:

- Any extension method on `T?` also exists for `T`. So null specific extensions cannot be added.
Also since `T` is all types, there would be a lot of clashes with existing types if you tried to
do so - e.g. `map` on `Iterable`.

- `Option` can be passed around like a reference and values can be taken in and 
  out of. Thus visible to all with reference to the `Option`, unlike null.

- `T??` is not possible, while Option<Option<T>> or Option<T?> is. This may be useful,
  e.g.

  State 1 (`None`): The configuration value isn't defined at all.

  State 2 (`Some(None)`): The configuration value is explicitly disabled.

  State 3 (`Some(Some(value))`): The configuration value is explicitly set to value.

  With nullable types a separate field would be needed to keep track of this.

- Certain operations should not be used without it e.g. `flatmap` - since null can be a valid state.

These issues are not insurmountable, and if fact, most of the time nullable types are probably more concise
and easier to deal with. Therefore, `Option` is only used where needed in the library, like `flatmap`, where it is not,
nullable types are used.

## The Option Type

Easy to declare and translate back and forth between nullable types.
```dart
Option<int> option = None;
Option<int> option = Some(1);

int? nullable = option.v; // or `.value`
option = Option.of(nullable);
```

### Usage
The `Option` type and features work very similar to [Result](../result/result.md). We are able to chain operations in a safe way without
needing a bunch of `if` statements to check if a value is null.

```dart
Option<int> intOptionFunc() => None;
double halfVal(int val) => val/2;
Option<double> val = intOptionFunc()
    .map(halfVal);
expect(val.unwrapOr(2), 2);
```
See the [docs](https://pub.dev/documentation/rust/latest/option/option-library.html) for all methods and extensions.

You can also use Option in pattern matching
```dart
switch(Some(2)){
  case Some(:final v):
    // do something
  case _:
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

#### Drawbacks

Currently in Dart, one cannot rebind variables and `Option` does not support type promotion like nullable types. 
This makes using `Option` less ergonomic in some scenarios.
```dart
Option<int> xOpt = optionFunc();
int x;
switch(xOpt) {
  case Some(:final v):
    x = v;
  case _:
    return;
}
// use `int` x
```
vs
```dart
int? x = nullableFunc();
if(x == null){
  return;
}
// use `int` x
```
Fortunately, since `Option` is an extension type of `T?`.
```dart
int? x = optionFunc().value;
if(x == null){
  return;
}
// use `int` x
```

#### Conclusion

The choice to use `Option` is up to the developer. You can easily use this package and never use `Option`.