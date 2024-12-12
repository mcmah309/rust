import 'dart:io' as io;

import 'package:rust/rust.dart';

@pragma('vm:prefer-inline')
FutureResult<Metadata, IoError> metadata(String path) async {
  return Fs.ioGuard(() async {
    return io.FileStat.stat(path);
  });
}

@pragma('vm:prefer-inline')
Result<Metadata, IoError> metadataSync(String path) {
  return Fs.ioGuardSync(() {
    return io.FileStat.statSync(path);
  });
}

@pragma('vm:prefer-inline')
Future<bool> exists(String path) async {
  try {
    return await io.FileSystemEntity.type(path, followLinks: true) !=
        io.FileSystemEntityType.notFound;
  } catch (_) {
    return false;
  }
}

@pragma('vm:prefer-inline')
bool existsSync(String path) {
  try {
    return io.FileSystemEntity.typeSync(path, followLinks: true) !=
        io.FileSystemEntityType.notFound;
  } catch (_) {
    return false;
  }
}

@pragma('vm:prefer-inline')
Future<bool> isDir(String path) async {
  try {
    return await io.FileSystemEntity.isDirectory(path);
  } catch (_) {
    return false;
  }
}

@pragma('vm:prefer-inline')
bool isDirSync(String path) {
  try {
    return io.FileSystemEntity.isDirectorySync(path);
  } catch (_) {
    return false;
  }
}

@pragma('vm:prefer-inline')
Future<bool> isFile(String path) async {
  try {
    return await io.FileSystemEntity.isFile(path);
  } catch (_) {
    return false;
  }
}

@pragma('vm:prefer-inline')
bool isFileSync(String path) {
  try {
    return io.FileSystemEntity.isFileSync(path);
  } catch (_) {
    return false;
  }
}

@pragma('vm:prefer-inline')
Future<bool> isSymlink(String path) async {
  try {
    return await io.FileSystemEntity.isLink(path);
  } catch (_) {
    return false;
  }
}

@pragma('vm:prefer-inline')
bool isSymlinkSync(String path) {
  try {
    return io.FileSystemEntity.isLinkSync(path);
  } catch (_) {
    return false;
  }
}

Future<Result<ReadDir, IoError>> readDir(String path) async {
  return Fs.ioGuard(() async {
    final dir = io.Directory(path);
    final listResult = await dir.list().toList();

    return listResult;
  });
}

Result<ReadDir, IoError> readDirSync(String path) {
  return Fs.ioGuardSync(() {
    final dir = io.Directory(path);
    return dir.listSync();
  });
}

Future<Result<String, IoError>> readLink(String path) async {
  return Fs.ioGuard(() async {
    final link = io.Link(path);
    final resolvedLinkResult = await link.resolveSymbolicLinks();

    return resolvedLinkResult;
  });
}

Result<String, IoError> readLinkSync(String path) {
  return Fs.ioGuardSync(() {
    final link = io.Link(path);
    return link.resolveSymbolicLinksSync();
  });
}

Result<Metadata, IoError> symlinkMetadataSync(String path) {
  return Fs.ioGuardSync(() {
    return io.Link(path).statSync();
  });
}

Future<Result<Metadata, IoError>> symlinkMetadata(String path) async {
  return Fs.ioGuard(() async {
    return await io.Link(path).stat();
  });
}
