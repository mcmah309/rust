import 'package:rust/rust.dart';

extension Str_StringExtension on String {
  /// An Iterator of code units of this [String] represented as individual [String]s
  @pragma("vm:prefer-inline")
  Iter<String> chars() {
    return Iter.fromIterable(codeUnits.map((e) => String.fromCharCode(e)));
  }

  @pragma("vm:prefer-inline")
  bool eqIgnoreCase(String other) {
    return toLowerCase() == other.toLowerCase();
  }
}
