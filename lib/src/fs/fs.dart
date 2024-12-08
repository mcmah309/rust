import 'package:rust/rust.dart';
import 'package:path/path.dart' as p;
import 'io_status.dart' as io_status;

class Fs {

  /// Returns whether io operations are supported. If false, is currently running on the web.
  static final bool isIoSupported = io_status.isIoSupported;

  // static final p.Context _windows = p.Context(style: p.Style.windows);

  // static Path canonicalize(Path path) {
  //   return _windows.canonicalize(path.asString()).asPath();
  // }
}