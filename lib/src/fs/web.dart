import 'package:rust/rust.dart';
import 'common.dart' as common;

part 'io_error_web.dart';

class ReadDir {}

class Metadata {}

class Fs {
  /// Returns whether io operations are supported. If false, is currently running on the web.
  static final bool isIoSupported = false;

  static FutureResult<T, IoError> ioGuard<T>(Future<T> Function() fn) async => throw UnsupportedError("'ioGuard' is not supported on this platform");

  static Result<T,IoError> ioGuardSync<T>(T Function() fn) => throw UnsupportedError("'ioGuardSync' is not supported on this platform");

  static FutureResult<T, IoError> ioGuardResult<T>(FutureResult<T, IoError> Function() fn) => throw UnsupportedError("'ioGuardResult' is not supported on this platform");

  static Result<T, IoError> ioGuardResultSync<T>(Result<T, IoError> Function() fn) => throw UnsupportedError("'ioGuardResultSync' is not supported on this platform");

  @pragma('vm:prefer-inline')
  static Path canonicalize(Path path) => common.canonicalize(path);

  static FutureResult<(), IoError> copy(Path from, Path to) => throw UnsupportedError("'copy' is not supported on this platform");

  static Result<(), IoError> copySync(Path from, Path to) => throw UnsupportedError("'copySync' is not supported on this platform");

  static FutureResult<(), IoError> createDir(Path path) => throw UnsupportedError("'createDir' is not supported on this platform");

  static Result<(), IoError> createDirSync(Path path) => throw UnsupportedError("'createDirSync' is not supported on this platform");

  static FutureResult<(), IoError> createDirAll(Path path) => throw UnsupportedError("'createDirAll' is not supported on this platform");

  static Result<(), IoError> createDirAllSync(Path path) => throw UnsupportedError("'createDirAllSync' is not supported on this platform");

  static FutureResult<bool, IoError> exists(Path path) => throw UnsupportedError("'exists' is not supported on this platform");

  static Result<bool, IoError> existsSync(Path path) => throw UnsupportedError("'existsSync' is not supported on this platform");

  static FutureResult<(), IoError> createSymlink(Path original, Path link) => throw UnsupportedError("'createSymlink' is not supported on this platform");

  static Result<(), IoError> createSymlinkSync(Path original, Path link) => throw UnsupportedError("'createSymlinkSync' is not supported on this platform");

  static FutureResult<Metadata, IoError> metadata(Path file) => throw UnsupportedError("'metadata' is not supported on this platform");

  static Result<Metadata, IoError> metadataSync(Path file) => throw UnsupportedError("'metadataSync' is not supported on this platform");
}