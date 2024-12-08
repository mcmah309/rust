import 'dart:io';

import 'package:rust/rust.dart';
import 'common.dart' as common;

part 'io_error_vm.dart';

/// An iterator over the entries within a directory.
typedef ReadDir = List<FileSystemEntity>;

// Dev Note: Dart did not name [FileStat] well. Since it is for not just files.
/// Metadata about a file system object - file, directory, etc.
///
/// This is the result of calling the POSIX stat() function on a file system object.
/// This is an immutable object, representing the snapshotted values returned by the stat() call.
typedef Metadata = FileStat;

class Fs {
  /// Returns whether io operations are supported. If false, is currently running on the web.
  static final bool isIoSupported = true;

  static FutureResult<T, IoError> ioGuard<T>(Future<T> Function() fn) async {
    try {
      return Ok(await fn());
    } on IOException catch (e) {
      return Err(IoError.ioException(e));
    } catch (e) {
      return Err(IoError.unknown(e));
    }
  }

  static Result<T, IoError> ioGuardSync<T>(T Function() fn) {
    try {
      return Ok(fn());
    } on IOException catch (e) {
      return Err(IoError.ioException(e));
    } catch (e) {
      return Err(IoError.unknown(e));
    }
  }

  static FutureResult<T, IoError> ioGuardResult<T>(
      FutureResult<T, IoError> Function() fn) async {
    try {
      return await fn();
    } on IOException catch (e) {
      return Err(IoError.ioException(e));
    } catch (e) {
      return Err(IoError.unknown(e));
    }
  }

  static Result<T, IoError> ioGuardResultSync<T>(Result<T, IoError> Function() fn) {
    try {
      return fn();
    } on IOException catch (e) {
      return Err(IoError.ioException(e));
    } catch (e) {
      return Err(IoError.unknown(e));
    }
  }

  @pragma('vm:prefer-inline')
  static Path canonicalize(Path path) => common.canonicalize(path);

  /// {@template Fs.copy}
  /// Copies this file.
  ///
  /// If [to] is a relative path, it is resolved against
  /// the current working directory ([Env.currentDirectory]).
  ///
  /// If [to] identifies an existing file, that file is
  /// removed first. If [to] identifies an existing directory, the
  /// operation fails and the future completes with an [IoError].
  /// {@endtemplate}
  static FutureResult<(), IoError> copy(Path from, Path to) async {
    return await Fs.ioGuard(() async => File(from.asString()).copy(to.asString())).map((_) => ());
  }

  /// {@macro Fs.copy}
  static Result<(), IoError> copySync(Path from, Path to) {
    return Fs.ioGuardSync(() => File(from.asString()).copySync(to.asString())).map((_) => ());
  }

  /// {@template Fs.createDir}
  /// Creates the directory if it doesn't exist. Does not create intermediate
  /// directories if they do not exist - see [Fs.createDirAll].
  ///
  /// Returns a [Ok] if the directory was created. Otherwise, if the directory cannot be
  /// created the future completes with an [Err] of [IoError].
  /// {@endtemplate}
  static FutureResult<(), IoError> createDir(Path path) async {
    return await Fs.ioGuard(() async => Directory(path.asString()).create()).map((_) => ());
  }

  /// {@macro Fs.createDir}
  static Result<(), IoError> createDirSync(Path path) {
    return Fs.ioGuardSync(() => Directory(path.asString()).create()).map((_) => ());
  }

  /// {@template Fs.createDirAll}
  /// Creates the directory if it doesn't exist. Will create all non-existing path components.
  ///
  /// Returns a [Ok] if the directory was created. Otherwise, if the directory cannot be
  /// created the future completes with an [Err] of [IoError].
  /// {@endtemplate}
  static FutureResult<(), IoError> createDirAll(Path path) async {
    return await Fs.ioGuard(() async => Directory(path.asString()).create(recursive: true))
        .map((_) => ());
  }

  /// {@macro Fs.createDirAll}
  static Result<(), IoError> createDirAllSync(Path path) {
    return Fs.ioGuardSync(() => Directory(path.asString()).createSync(recursive: true))
        .map((_) => ());
  }

  /// {@template Fs.exists}
  /// Returns Ok(true) if the path points at an existing entity.
  /// {@endtemplate}
  static FutureResult<bool, IoError> exists(Path path) async {
    return Fs.ioGuard(() async {
      final fsEntity = await FileSystemEntity.type(path.asString());
      return switch (fsEntity) { FileSystemEntityType.notFound => false, _ => true };
    });
  }

  /// {@macro Fs.exists}
  static Result<bool, IoError> existsSync(Path path) {
    return Fs.ioGuardSync(() {
      final fsEntity = FileSystemEntity.typeSync(path.asString());
      return switch (fsEntity) { FileSystemEntityType.notFound => false, _ => true };
    });
  }

  // hard_link: Not supported by dart

  /// {@template Fs.createSymlink}
  /// Creates a symbolic link at [link] pointing to [original].
  /// {@endtemplate}
  static FutureResult<(), IoError> createSymlink(Path original, Path link) async {
    return await Fs.ioGuard(
            () async => Link(link.asString()).create(original.asString(), recursive: true))
        .map((_) => ());
  }

  /// {@macro Fs.createSymlink}
  static Result<(), IoError> createSymlinkSync(Path original, Path link) {
    return Fs.ioGuardSync(
            () => Link(link.asString()).createSync(original.asString(), recursive: true))
        .map((_) => ());
  }

  /// {@template Fs.metadata}
  /// Asynchronously calls the operating system's `stat()` function (or
  /// equivalent) on [path].
  ///
  /// If [path] is a symbolic link then it is resolved and results for the
  /// resulting file are returned.
  /// {@endtemplate}
  static FutureResult<Metadata, IoError> metadata(Path file) async {
    return await Fs.ioGuard(() async {
      return await FileStat.stat(file.asString());
    });
  }

  /// {@macro Fs.metadata}
  static Result<Metadata, IoError> metadataSync(Path file) {
    return Fs.ioGuardSync(() => FileStat.statSync(file.asString()));
  }
}
