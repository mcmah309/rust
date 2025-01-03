import 'package:rust/rust.dart';

extension Array$ListExtension<T> on List<T> {
  /// Transmutes a List into an Array
  @pragma("vm:prefer-inline")
  Arr<T> asArr() => Arr.fromList(this);
}

extension Array$IterableExtension<T> on Iterable<T> {
  /// Creates an Array from an Iterable
  @pragma("vm:prefer-inline")
  Arr<T> toArr() => Arr.fromList(toList(growable: false));
}
