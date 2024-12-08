import 'package:rust/rust.dart';

class ReadDir {}

class Metadata {}

@pragma('vm:prefer-inline')
Future<Metadata> metadata(String path) =>
    throw UnsupportedError("'metadata' is not supported on on this platform.");

@pragma('vm:prefer-inline')
Metadata metadataSync(String path) => throw UnsupportedError(
    "'metadataSync' is not supported on on this platform.");

@pragma('vm:prefer-inline')
Future<bool> exists(String path) =>
    throw UnsupportedError("'exists' is not supported on on this platform.");

@pragma('vm:prefer-inline')
bool existsSync(String path) => throw UnsupportedError(
    "'existsSync' is not supported on on this platform.");

@pragma('vm:prefer-inline')
Future<bool> isDir(String path) =>
    throw UnsupportedError("'isDir' is not supported on on this platform.");

@pragma('vm:prefer-inline')
bool isDirSync(String path) =>
    throw UnsupportedError("'isDirSync' is not supported on on this platform.");

@pragma('vm:prefer-inline')
Future<bool> isFile(String path) =>
    throw UnsupportedError("'isFile' is not supported on on this platform.");

@pragma('vm:prefer-inline')
bool isFileSync(String path) => throw UnsupportedError(
    "'isFileSync' is not supported on on this platform.");

@pragma('vm:prefer-inline')
Future<bool> isSymlink(String path) =>
    throw UnsupportedError("'isSymlink' is not supported on on this platform.");

@pragma('vm:prefer-inline')
bool isSymlinkSync(String path) => throw UnsupportedError(
    "'isSymlinkSync' is not supported on on this platform.");

@pragma('vm:prefer-inline')
Future<Result<ReadDir, PathIoError>> readDir(String path) =>
    throw UnsupportedError("'readDir' is not supported on on this platform.");

@pragma('vm:prefer-inline')
Result<ReadDir, PathIoError> readDirSync(String path) => throw UnsupportedError(
    "'readDirSync' is not supported on on this platform.");

@pragma('vm:prefer-inline')
Future<Result<String, PathIoError>> readLink(String path) =>
    throw UnimplementedError(
        "'readLink' is not supported on on this platform.");

@pragma('vm:prefer-inline')
Result<String, PathIoError> readLinkSync(String path) =>
    throw UnimplementedError(
        "'readLinkSync' is not supported on on this platform.");

@pragma('vm:prefer-inline')
Future<Result<Metadata, PathIoError>> symlinkMetadata(String path) =>
    throw UnimplementedError(
        "'symlinkMetadata' is not supported on on this platform.");

@pragma('vm:prefer-inline')
Result<Metadata, PathIoError> symlinkMetadataSync(String path) =>
    throw UnimplementedError(
        "'symlinkMetadataSync' is not supported on on this platform.");
