import 'dart:io';
import 'dart:typed_data';

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

  static FutureResult<T, IoError> ioGuardResult<T>(FutureResult<T, IoError> Function() fn) async {
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
  static FutureResult<Metadata, IoError> metadata(Path path) async {
    return await Fs.ioGuard(() async {
      return await FileStat.stat(path.asString());
    });
  }

  /// {@macro Fs.metadata}
  static Result<Metadata, IoError> metadataSync(Path path) {
    return Fs.ioGuardSync(() => FileStat.statSync(path.asString()));
  }

  /// {@template Fs.read}
  /// Reads the entire file contents of a file as bytes.
  /// {@endtemplate}
  static FutureResult<Uint8List, IoError> read(Path path) async {
    return Fs.ioGuard(() async {
      return await File(path.asString()).readAsBytes();
    });
  }

  /// {@macro Fs.read}
  static Result<Uint8List, IoError> readSync(Path path) {
    return Fs.ioGuardSync(() => File(path.asString()).readAsBytesSync());
  }

  /// {@template Fs.readDr}
  /// Returns a list with the entries within a directory.
  /// {@endtemplate}
  static FutureResult<ReadDir, IoError> readDir(Path path) async {
    return await Fs.ioGuard(() async {
      return await Directory(path.asString()).list(recursive: false, followLinks: false).toList();
    });
  }

  /// {@macro Fs.readDr}
  static Result<ReadDir, IoError> readDirSync(Path path) {
    return Fs.ioGuardSync(() {
      return Directory(path.asString()).listSync(recursive: false, followLinks: false);
    });
  }

  /// {@template Fs.readLink}
  /// Reads a symbolic link, returning the file that the link points to.
  /// {@endtemplate}
  static FutureResult<Path, IoError> readLink(Path path) async {
    return await Fs.ioGuard(() async {
      return Path((await Link(path.asString()).target()));
    });
  }

  /// {@macro Fs.readLink}
  static Result<Path, IoError> readLinkSync(Path path) {
    return Fs.ioGuardSync(() => Path(Link(path.asString()).targetSync()));
  }

  /// {@template Fs.readToString}
  /// Reads the entire contents of a file into a string.
  /// {@endtemplate}
  static FutureResult<String, IoError> readToString(Path path) async {
    return Fs.ioGuard(() async {
      return await File(path.asString()).readAsString();
    });
  }

  /// {@macro Fs.readToString}
  static Result<String, IoError> readToStringSync(Path path) {
    return Fs.ioGuardSync(() => File(path.asString()).readAsStringSync());
  }

  /// {@template Fs.removeDir}
  /// Removes an empty directory.
  /// {@endtemplate}
  static FutureResult<(), IoError> removeDir(Path path) async {
    return await Fs.ioGuard(() async {
      return await Directory(path.asString()).delete(recursive: false);
    }).map((_) => ());
  }

  /// {@macro Fs.removeDir}
  static Result<(), IoError> removeDirSync(Path path) {
    return Fs.ioGuardSync(() => Directory(path.asString()).deleteSync(recursive: false))
        .map((_) => ());
  }

  /// {@template Fs.removeDirAll}
  /// Removes a directory at this path, after removing all its contents. Use carefully!
  /// {@endtemplate}
  static FutureResult<(), IoError> removeDirAll(Path path) async {
    return await Fs.ioGuard(() async {
      return await Directory(path.asString()).delete(recursive: true);
    }).map((_) => ());
  }

  /// {@macro Fs.removeDirAll}
  static Result<(), IoError> removeDirAllSync(Path path) {
    return Fs.ioGuardSync(() => Directory(path.asString()).deleteSync(recursive: true))
        .map((_) => ());
  }

  /// {@template Fs.removeFile}
  /// Removes a file.
  /// {@endtemplate}
  static FutureResult<(), IoError> removeFile(Path path) async {
    return await Fs.ioGuard(() async {
      return await File(path.asString()).delete(recursive: false);
    }).map((_) => ());
  }

  /// {@macro Fs.removeFile}
  static Result<(), IoError> removeFileSync(Path path) {
    return Fs.ioGuardSync(() => File(path.asString()).deleteSync(recursive: false)).map((_) => ());
  }

  /// {@template Fs.rename}
  /// Renames a file or directory.
  /// Note this is different from the rust `rename` as this is just a rename, for an equivalent use - [move].
  /// {@endtemplate}
  static FutureResult<(), IoError> rename(Path path, String newName) async {
    final pathStr = path.asString();
    final lastSeparatorIndex = pathStr.lastIndexOf(Path.separator);
    final newPath = pathStr.substring(0, lastSeparatorIndex + 1) + newName;
    return Fs.move(path, newPath.asPath());
  }

  /// {@macro Fs.rename}
  static Result<(), IoError> renameSync(Path path, String newName) {
    final pathStr = path.asString();
    final lastSeparatorIndex = pathStr.lastIndexOf(Path.separator);
    final newPath = pathStr.substring(0, lastSeparatorIndex + 1) + newName;
    return Fs.moveSync(path, newPath.asPath());
  }

  /// {@template Fs.move}
  /// Moves a file or directory, possibly just a rename operation.
  /// {@endtemplate}
  static FutureResult<(), IoError> move(Path from, Path to) async {
    final fromStr = from.asString();
    final toStr = to.asString();
    return await Fs.ioGuardResult(() async {
      FileSystemEntity entity = File(fromStr);
      if (await entity.exists()) {
        return Ok(await entity.rename(toStr));
      }
      entity = Directory(fromStr);
      if (await entity.exists()) {
        return Ok(await entity.rename(toStr));
      }
      entity = Link(fromStr);
      if (await entity.exists()) {
        return Ok(await entity.rename(toStr));
      }
      return Err(IoError.ioException(PathNotFoundException(fromStr, const OSError())));
    }).map((_) => ());
  }

  /// {@macro Fs.move}
  static Result<(), IoError> moveSync(Path from, Path to) {
    final fromStr = from.asString();
    final toStr = to.asString();
    return Fs.ioGuardResultSync(() {
      FileSystemEntity entity = File(fromStr);
      if (entity.existsSync()) {
        return Ok(entity.renameSync(toStr));
      }
      entity = Directory(fromStr);
      if (entity.existsSync()) {
        return Ok(entity.renameSync(toStr));
      }
      entity = Link(fromStr);
      if (entity.existsSync()) {
        return Ok(entity.renameSync(toStr));
      }
      return Err(IoError.ioException(PathNotFoundException(fromStr, const OSError())));
    }).map((_) => ());
  }
}
