import 'package:rust/rust.dart';
import 'common.dart' as common;

part 'io_error_web.dart';

class Fs {
  /// Returns whether io operations are supported. If false, is currently running on the web.
  static final bool isIoSupported = false;

  static FutureResult<T, IoError> ioGuard<T>(Future<T> Function() fn) async => throw UnsupportedError("'ioGuard' is not supported on this platform");


  static Result<T,IoError> ioGuardSync<T>(T Function() fn) => throw UnsupportedError("'ioGuardSync' is not supported on this platform");


  @pragma('vm:prefer-inline')
  static Path canonicalize(Path path) => common.canonicalize(path);

  static FutureResult<(), IoError> copy(Path from, Path to) => throw UnsupportedError("'copy' is not supported on this platform");

  static Result<(), IoError> copySync(Path from, Path to) => throw UnsupportedError("'copySync' is not supported on this platform");
}