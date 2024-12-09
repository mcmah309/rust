import 'dart:typed_data';

import 'package:rust/rust.dart';
import 'common.dart' as common;

part 'io_error_web.dart';

class ReadDir {}

class Metadata {}

class File {}

class RandomAccessFile {}

class FileMode {}

class Fs {
  /// Returns whether io operations are supported. If false, is currently running on the web.
  static final bool isIoSupported = false;

  static FutureResult<T, IoError> ioGuard<T>(Future<T> Function() fn) async =>
      throw UnsupportedError("'ioGuard' is not supported on this platform");

  static Result<T, IoError> ioGuardSync<T>(T Function() fn) =>
      throw UnsupportedError("'ioGuardSync' is not supported on this platform");

  static FutureResult<T, IoError> ioGuardResult<T>(
          FutureResult<T, IoError> Function() fn) =>
      throw UnsupportedError(
          "'ioGuardResult' is not supported on this platform");

  static Result<T, IoError> ioGuardResultSync<T>(
          Result<T, IoError> Function() fn) =>
      throw UnsupportedError(
          "'ioGuardResultSync' is not supported on this platform");

  @pragma('vm:prefer-inline')
  static Path canonicalize(Path path) => common.canonicalize(path);

  static FutureResult<(), IoError> copy(Path from, Path to) =>
      throw UnsupportedError("'copy' is not supported on this platform");

  static Result<(), IoError> copySync(Path from, Path to) =>
      throw UnsupportedError("'copySync' is not supported on this platform");

  static FutureResult<(), IoError> createDir(Path path) =>
      throw UnsupportedError("'createDir' is not supported on this platform");

  static Result<(), IoError> createDirSync(Path path) => throw UnsupportedError(
      "'createDirSync' is not supported on this platform");

  static FutureResult<(), IoError> createDirAll(Path path) =>
      throw UnsupportedError(
          "'createDirAll' is not supported on this platform");

  static Result<(), IoError> createDirAllSync(Path path) =>
      throw UnsupportedError(
          "'createDirAllSync' is not supported on this platform");

  static FutureResult<bool, IoError> exists(Path path) =>
      throw UnsupportedError("'exists' is not supported on this platform");

  static Result<bool, IoError> existsSync(Path path) =>
      throw UnsupportedError("'existsSync' is not supported on this platform");

  static FutureResult<(), IoError> createSymlink(Path original, Path link) =>
      throw UnsupportedError(
          "'createSymlink' is not supported on this platform");

  static Result<(), IoError> createSymlinkSync(Path original, Path link) =>
      throw UnsupportedError(
          "'createSymlinkSync' is not supported on this platform");

  static FutureResult<Metadata, IoError> metadata(Path file) =>
      throw UnsupportedError("'metadata' is not supported on this platform");

  static Result<Metadata, IoError> metadataSync(Path file) =>
      throw UnsupportedError(
          "'metadataSync' is not supported on this platform");

  static FutureResult<Uint8List, IoError> read(Path path) =>
      throw UnsupportedError("'read' is not supported on this platform");

  static Result<Uint8List, IoError> readSync(Path path) =>
      throw UnsupportedError("'readSync' is not supported on this platform");

  static FutureResult<ReadDir, IoError> readDir(Path path) =>
      throw UnsupportedError("'readDir' is not supported on this platform");

  static Result<ReadDir, IoError> readDirSync(Path path) =>
      throw UnsupportedError("'readDirSync' is not supported on this platform");

  static FutureResult<Path, IoError> readLink(Path path) =>
      throw UnsupportedError("'readLink' is not supported on this platform");

  static Result<Path, IoError> readLinkSync(Path path) =>
      throw UnsupportedError(
          "'readLinkSync' is not supported on this platform");

  static FutureResult<String, IoError> readToString(Path path) =>
      throw UnsupportedError(
          "'readToString' is not supported on this platform");

  static Result<String, IoError> readToStringSync(Path path) =>
      throw UnsupportedError(
          "'readToStringSync' is not supported on this platform");

  static FutureResult<(), IoError> removeDir(Path path) =>
      throw UnsupportedError("'removeDir' is not supported on this platform");

  static Result<(), IoError> removeDirSync(Path path) => throw UnsupportedError(
      "'removeDirSync' is not supported on this platform");

  static FutureResult<(), IoError> removeDirAll(Path path) =>
      throw UnsupportedError(
          "'removeDirAll' is not supported on this platform");

  static Result<(), IoError> removeDirAllSync(Path path) =>
      throw UnsupportedError(
          "'removeDirAllSync' is not supported on this platform");

  static FutureResult<(), IoError> removeFile(Path path) =>
      throw UnsupportedError("'removeFile' is not supported on this platform");

  static Result<(), IoError> removeFileSync(Path path) =>
      throw UnsupportedError(
          "'removeFileSync' is not supported on this platform");

  static FutureResult<(), IoError> rename(Path path, String newName) =>
      throw UnsupportedError("'rename' is not supported on this platform");

  static Result<(), IoError> renameSync(Path path, String newName) =>
      throw UnsupportedError("'renameSync' is not supported on this platform");

  static FutureResult<(), IoError> move(Path from, Path to) =>
      throw UnsupportedError("'move' is not supported on this platform");

  static Result<(), IoError> moveSync(Path from, Path to) =>
      throw UnsupportedError("'moveSync' is not supported on this platform");

  static FutureResult<(), IoError> write(Path path, Uint8List bytes) =>
      throw UnsupportedError("'write' is not supported on this platform");

  static Result<(), IoError> writeSync(Path path, Uint8List bytes) =>
      throw UnsupportedError("'writeSync' is not supported on this platform");

  static FutureResult<(), IoError> writeString(Path path, String contents) =>
      throw UnsupportedError("'writeString' is not supported on this platform");

  static Result<(), IoError> writeStringSync(Path path, String contents) =>
      throw UnsupportedError(
          "'writeStringSync' is not supported on this platform");

  //************************************************************************//

  static FutureResult<RandomAccessFile, IoError> open(
          Path path, FileMode mode) =>
      throw UnsupportedError("'open' is not supported on this platform");

  static Result<RandomAccessFile, IoError> openSync(Path path, FileMode mode) =>
      throw UnsupportedError("'openSync' is not supported on this platform");

  static FutureResult<File, IoError> createFile(Path path) =>
      throw UnsupportedError("'createFile' is not supported on this platform");

  static Result<File, IoError> createFileSync(Path path) =>
      throw UnsupportedError(
          "'createFileSync' is not supported on this platform");

  static FutureResult<File, IoError> createNewFile(Path path) =>
      throw UnsupportedError(
          "'createNewFile' is not supported on this platform");

  static Result<File, IoError> createNewFileSync(Path path) =>
      throw UnsupportedError(
          "'createNewFileSync' is not supported on this platform");
}
