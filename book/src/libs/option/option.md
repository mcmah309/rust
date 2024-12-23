# Option
***
[Option](https://pub.dev/documentation/rust/latest/rust/Option-class.html) represents the union of two types - `Some<T>` and `None`.

`Option` is easy to declare and translate back and forth between nullable types.
```dart
Option<int> option = None;
Option<int> option = Some(1);

int? nullable = option.toNullable();
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
### Discussion

#### If Dart Has Nullable Types Why Ever Use `Option`?

`Option` is wrapper around a value that may or may be set. A nullable type is a type that may or may not be set.
This small distinction leads to some useful differences:

- Any extension method on `T?` also exists for `T`. So null specific extensions cannot be added.
Also since `T` is all types, there would be a lot of clashes with existing types if you tried to
do so - e.g. `map` on `Iterable`. While `Option` plays well for a pipeline style of programming.

- `T??` is not possible, while Option<Option<T>> or Option<T?> is. This may be useful,
  e.g.

  **No value at all** (`None`): The configuration value isn't defined at all.

  **A known absence of a value** (`Some(None)`): The configuration value is explicitly disabled.

  **A present value** (`Some(Some(value))`): The configuration value is explicitly set to value.

  With nullable types, a separate field or enum/sealed class would be needed to keep track of this.

- Correctness of code and reducing bugs. As to why, e.g. consider `nth` which returns the nth index
of an iterable or null if the iterable does not have an nth index. 
If the iterable is `Iterable<T?>`, then a null value from calling `nth` means the nth element is 
either null or the iterable does not have n elements. While if `nth` rather returned `Option`,
if the nth index is null it returns `Some(null)` and if it does not have n elements it returns `None`.
One might accidentally mishandle the nullable case and assume the `nth` index does not actually exist,
when it is rather just null. While the second case with `Option` one is force to handle both cases.
This holds true for a lot of operations that might have unintended effects 
e.g. `filterMap` - since null can be a valid state that should not be filtered.

These issues are not insurmountable, and in fact, most of the time nullable types are probably more concise
and easier to deal with. Therefore, for every method in this library that uses `T?` there is also an `Option`
version, usually suffixed with `..Opt`.

> In some languages (like Rust, not Dart) `Option` can be passed around like a reference 
> and values can be taken in and out of (transmutation). Thus visible to all with reference 
> to the `Option`, unlike null. Implementing such an equivalence in Dart would remove pattern
> matching and const-ness.

#### Why Not To Use Option

- Null chaining operations with `?` is not possible with `Option`

- Currently in Dart, one cannot rebind variables and `Option` does not support type promotion like nullable types. 
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
Fortunately, it can be converted back and forth.
```dart
int? x = optionFunc().toNullable();
if(x == null){
  return;
}
// use `int` x
```

#### Conclusion

The choice to use `Option` is up to the developer. You can easily use this package and never use `Option`.