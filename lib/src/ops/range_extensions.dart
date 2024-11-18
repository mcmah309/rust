import 'package:rust/ops.dart';
import 'package:rust/slice.dart';

extension ListRangeExtension<T> on List<T> {
  @pragma("vm:prefer-inline")
  Slice<T> call(RangeBounds range) => range.slice(this);
}
