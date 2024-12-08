part of 'vm.dart';

sealed class IoError {
  factory IoError.fileSystem(FileSystemException error) = IoError$FileSystem._;
  factory IoError.pathAccess(PathAccessException error) = IoError$PathAccess._;
  factory IoError.pathExists(PathExistsException error) = IoError$PathExists._;
  factory IoError.pathNotFound(PathNotFoundException error) = IoError$PathNotFound._;
  factory IoError.unknown(Object error) = IoError$Unknown._;
}

class IoError$FileSystem implements IoError {
  final FileSystemException error;

  IoError$FileSystem._(this.error);
}

class IoError$PathAccess implements IoError {
  final PathAccessException error;

  IoError$PathAccess._(this.error);
}

class IoError$PathExists implements IoError {
  final PathExistsException error;

  IoError$PathExists._(this.error);
}

class IoError$PathNotFound implements IoError {
  final PathNotFoundException error;

  IoError$PathNotFound._(this.error);
}

class IoError$Unknown implements IoError {
  final Object error;

  IoError$Unknown._(this.error);
}