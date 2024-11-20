sealed class IoError implements Exception {
  final String path;

  const IoError(this.path);

  @override
  String toString() {
    return "IoError";
  }

  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType &&
        other is IoError &&
        other.path == path;
  }

  @override
  int get hashCode => path.hashCode ^ runtimeType.hashCode;
}

final class IoErrorNotADirectory extends IoError {
  const IoErrorNotADirectory(super.path);

  @override
  String toString() {
    return "IoError: The path '$path' is not a directory.";
  }
}

final class IoErrorNotAFile extends IoError {
  const IoErrorNotAFile(super.path);

  @override
  String toString() {
    return "IoError: The path '$path' is not a file.";
  }
}

final class IoErrorNotALink extends IoError {
  const IoErrorNotALink(super.path);

  @override
  String toString() {
    return "IoError: The path '$path' is not a link.";
  }
}

final class IoErrorNotAValidPath extends IoError {
  const IoErrorNotAValidPath(super.path);

  @override
  String toString() {
    return "IoError: The path '$path' is not a valid path.";
  }
}

final class IoErrorUnknown extends IoError {
  final Object? error;

  const IoErrorUnknown(super.path, [this.error]);

  @override
  String toString() {
    if (error != null) {
      return "IoError: An unknown error occurred with path '$path'. Error: $error";
    }
    return "IoError: An unknown error occurred with path '$path'.";
  }
}
