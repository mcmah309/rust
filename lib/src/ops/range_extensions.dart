import 'package:rust/rust.dart';

extension ListRangeExtension<T> on List<T> {
  @pragma("vm:prefer-inline")
  Slice<T> call(RangeBounds range) => range.slice(this);
}
