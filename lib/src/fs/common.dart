import 'package:rust/rust.dart';
import 'package:path/path.dart' as p;

final p.Context _context = p.Context(style: p.Style.platform);

Path canonicalize(Path path) {
  return _context.canonicalize(path.asString()).asPath();
}
