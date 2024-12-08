import 'dart:io';

import 'package:rust/rust.dart';
import 'common.dart' as common;

part 'io_error_vm.dart';

class Fs {
  /// Returns whether io operations are supported. If false, is currently running on the web.
  static final bool isIoSupported = true;

  static FutureResult<T, IoError> ioGuard<T>(Future<T> Function() fn) async {
    try {
      return Ok(await fn());
    } on PathAccessException catch (e) {
      return Err(IoError.pathAccess(e));
    } on PathExistsException catch (e) {
      return Err(IoError.pathExists(e));
    } on PathNotFoundException catch (e) {
      return Err(IoError.pathNotFound(e));
    } on FileSystemException catch (e) {
      return Err(IoError.fileSystem(e));
    } catch (e) {
      return Err(IoError.unknown(e));
    }
  }

  static Result<T, IoError> ioGuardSync<T>(T Function() fn) {
    try {
      return Ok(fn());
    } on PathAccessException catch (e) {
      return Err(IoError.pathAccess(e));
    } on PathExistsException catch (e) {
      return Err(IoError.pathExists(e));
    } on PathNotFoundException catch (e) {
      return Err(IoError.pathNotFound(e));
    } on FileSystemException catch (e) {
      return Err(IoError.fileSystem(e));
    } catch (e) {
      return Err(IoError.unknown(e));
    }
  }

  @pragma('vm:prefer-inline')
  static Path canonicalize(Path path) => common.canonicalize(path);

  static FutureResult<(), IoError> copy(Path from, Path to) async {
    final _ = await Fs.ioGuard(() async => await File(from.asString()).copy(to.asString()));
    return Ok(());
  }

  static Result<(), IoError> copySync(Path from, Path to) {
    final _ = Fs.ioGuardSync(() => File(from.asString()).copySync(to.asString()));
    return Ok(());
  }
}
