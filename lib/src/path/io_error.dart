sealed class PathIoError implements Exception {
  final String path;

  const PathIoError(this.path);

  factory PathIoError.notADirectory(String path) = PathIoError$NotADirectory;
  factory PathIoError.notAFile(String path) = PathIoError$NotAFile;
  factory PathIoError.notALink(String path) = PathIoError$NotALink;
  factory PathIoError.notAValidPath(String path) = PathIoError$NotAValidPath;
  factory PathIoError.unknown(String path, [Object? error]) = PathIoError$Unknown;

  @override
  String toString() {
    return "PathIoError";
  }

  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType && other is PathIoError && other.path == path;
  }

  @override
  int get hashCode => path.hashCode ^ runtimeType.hashCode;
}

final class PathIoError$NotADirectory extends PathIoError {
  const PathIoError$NotADirectory(super.path);

  @override
  String toString() {
    return "PathIoError: The path '$path' is not a directory.";
  }
}

final class PathIoError$NotAFile extends PathIoError {
  const PathIoError$NotAFile(super.path);

  @override
  String toString() {
    return "PathIoError: The path '$path' is not a file.";
  }
}

final class PathIoError$NotALink extends PathIoError {
  const PathIoError$NotALink(super.path);

  @override
  String toString() {
    return "PathIoError: The path '$path' is not a link.";
  }
}

final class PathIoError$NotAValidPath extends PathIoError {
  const PathIoError$NotAValidPath(super.path);

  @override
  String toString() {
    return "PathIoError: The path '$path' is not a valid path.";
  }
}

final class PathIoError$Unknown extends PathIoError {
  final Object? error;

  const PathIoError$Unknown(super.path, [this.error]);

  @override
  String toString() {
    if (error != null) {
      return "PathIoError: An unknown error occurred with path '$path'. Error: $error";
    }
    return "PathIoError: An unknown error occurred with path '$path'.";
  }
}
