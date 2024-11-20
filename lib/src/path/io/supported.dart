import 'dart:io' as io;

import 'package:rust/rust.dart';

import '../io_error.dart';

@pragma('vm:prefer-inline')
bool isIoSupported() => true;

/// An iterator over the entries within a directory.
typedef ReadDir = List<io.FileSystemEntity>;

typedef Metadata = io.FileStat;

@pragma('vm:prefer-inline')
Future<Metadata> metadata(String path) => io.FileStat.stat(path);

@pragma('vm:prefer-inline')
Metadata metadataSync(String path) => io.FileStat.statSync(path);

@pragma('vm:prefer-inline')
Future<bool> exists(String path) async =>
    await io.FileSystemEntity.type(path, followLinks: true) !=
    io.FileSystemEntityType.notFound;

@pragma('vm:prefer-inline')
bool existsSync(String path) =>
    io.FileSystemEntity.typeSync(path, followLinks: true) !=
    io.FileSystemEntityType.notFound;

@pragma('vm:prefer-inline')
Future<bool> isDir(String path) => io.FileSystemEntity.isDirectory(path);

@pragma('vm:prefer-inline')
bool isDirSync(String path) => io.FileSystemEntity.isDirectorySync(path);

@pragma('vm:prefer-inline')
Future<bool> isFile(String path) => io.FileSystemEntity.isFile(path);

@pragma('vm:prefer-inline')
bool isFileSync(String path) => io.FileSystemEntity.isFileSync(path);

@pragma('vm:prefer-inline')
Future<bool> isSymlink(String path) => io.FileSystemEntity.isLink(path);

@pragma('vm:prefer-inline')
bool isSymlinkSync(String path) => io.FileSystemEntity.isLinkSync(path);

@pragma('vm:prefer-inline')
Future<Result<ReadDir, IoError>> readDir(String path) async {
  if (!await isDir(path)) {
    return Err(IoErrorNotADirectory(path));
  }
  try {
    final dir = io.Directory(path);
    final listResult = await dir.list().toList();

    return Ok(listResult);
  } catch (e) {
    return Err(IoErrorUnknown(path, e));
  }
}

@pragma('vm:prefer-inline')
Result<ReadDir, IoError> readDirSync(String path) {
  if (!isDirSync(path)) {
    return Err(IoErrorNotADirectory(path));
  }
  try {
    final dir = io.Directory(path);
    return Ok(dir.listSync());
  } catch (e) {
    return Err(IoErrorUnknown(path, e));
  }
}

@pragma('vm:prefer-inline')
Future<Result<String, IoError>> readLink(String path) async {
  if (!await isSymlink(path)) {
    return Err(IoErrorNotALink(path));
  }
  try {
    final link = io.Link(path);
    final resolvedLinkResult = await link.resolveSymbolicLinks();

    return Ok(resolvedLinkResult);
  } catch (e) {
    return Err(IoErrorUnknown(path, e));
  }
}

@pragma('vm:prefer-inline')
Result<String, IoError> readLinkSync(String path) {
  if (!isSymlinkSync(path)) {
    return Err(IoErrorNotALink(path));
  }
  try {
    final link = io.Link(path);
    return Ok(link.resolveSymbolicLinksSync());
  } catch (e) {
    return Err(IoErrorUnknown(path, e));
  }
}

@pragma('vm:prefer-inline')
Result<Metadata, IoError> symlinkMetadataSync(String path) {
  if (!isSymlinkSync(path)) {
    return Err(IoErrorNotALink(path));
  }
  try {
    return Ok(io.Link(path).statSync());
  } catch (e) {
    return Err(IoErrorUnknown(path, e));
  }
}

@pragma('vm:prefer-inline')
Future<Result<Metadata, IoError>> symlinkMetadata(String path) async {
  if (!await isSymlink(path)) {
    return Err(IoErrorNotALink(path));
  }
  try {
    return Ok(await io.Link(path).stat());
  } catch (e) {
    return Err(IoErrorUnknown(path, e));
  }
}
