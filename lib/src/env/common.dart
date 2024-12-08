import 'package:rust/rust.dart';

String joinPaths(Iterable<String> paths) {
  StringBuffer buf = StringBuffer();
  bool canAddToEnd = false;
  for (var path in paths) {
    if (canAddToEnd) {
      buf.write(Path.separator);
    }
    canAddToEnd = true;
    buf.write(path);
  }
  return buf.toString();
}

Iterable<String> splitPaths(String paths) {
  return paths.split(Path.separator);
}
