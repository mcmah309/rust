part of 'path.dart';

/// A Unix Path.
/// {@macro path.Path}
extension type UnixPath._(String _string) implements Object {
  static const String separator = "/";

  static final RegExp _oneOrMoreSlashes = RegExp('$separator+');
  static final p.Context _posix = p.Context(style: p.Style.posix);

  UnixPath(this._string);

  @pragma("vm:prefer-inline")
  String asString() => _string;

  /// {@macro path.Path.ancestors}
  Iterable<UnixPath> ancestors() sync* {
    yield this;
    UnixPath? current = parent();
    while (current != null) {
      yield current;
      current = current.parent();
    }
  }

// as_mut_os_str : will not be implemented
// as_os_str : will not be implemented

  /// {@macro path.Path.canonicalize}
  UnixPath canonicalize() => UnixPath(_posix.canonicalize(_string));

  /// {@macro path.Path.components}
  Iterable<Component> components() sync* {
    bool removeLast;
    // trailing slash does not matter
    if (_string.endsWith(separator)) {
      if (_string.length == 1) {
        yield const RootDir(false);
        return;
      }
      removeLast = true;
    } else {
      removeLast = false;
    }
    final splits = _string.split(_oneOrMoreSlashes);
    if (removeLast) {
      splits.removeLast();
    }

    final iterator = splits.iterator;
    iterator.moveNext();
    var current = iterator.current;
    switch (current) {
      case "":
        yield const RootDir(false);
        break;
      case ".":
        yield const CurDir();
        break;
      case "..":
        yield const ParentDir();
        break;
      default:
        yield Normal(current);
    }
    while (iterator.moveNext()) {
      current = iterator.current;
      switch (current) {
        case ".":
          yield CurDir();
          break;
        case "..":
          yield ParentDir();
          break;
        default:
          yield Normal(current);
      }
    }
  }

  /// {@macro path.Path.endsWith}
  bool endsWith(UnixPath other) => _string.endsWith(other._string);

  /// {@macro path.Path.existsSync}
  bool existsSync() => io.existsSync(_string);

  /// {@macro path.Path.exists}
  Future<bool> exists() => io.exists(_string);

  /// {@macro path.Path.extension}
  String extension() {
    String extensionWithDot = _posix.extension(_string);
    if (extensionWithDot.isNotEmpty) {
      assert(extensionWithDot.startsWith("."));
      return extensionWithDot.replaceFirst(".", "");
    }
    return extensionWithDot;
  }

  /// {@macro path.Path.fileName}
  String fileName() => _posix.basename(_string);

   /// {@macro path.Path.filePrefix}
  String? filePrefix() {
    final value = _posix.basename(_string);
    if (value.isEmpty) {
      return null;
    }
    if (!value.contains(".")) {
      return value;
    }
    if (value.startsWith(".")) {
      final splits = value.split(".");
      if (splits.length == 2) {
        return value;
      } else {
        assert(splits.length > 2);
        return splits[1];
      }
    }
    return value.split(".").first;
  }

  /// {@macro path.Path.filePrefix}
  @pragma('vm:prefer-inline')
  Option<String> filePrefixOpt() => Option.of(filePrefix());

  /// {@macro path.Path.fileStem}
  String? fileStem() {
    final fileStem = _posix.basenameWithoutExtension(_string);
    if (fileStem.isEmpty) {
      return null;
    }
    return fileStem;
  }

  /// {@macro path.Path.fileStem}
  Option<String> fileStemOpt() => Option.of(fileStem());

  /// {@macro path.Path.hasRoot}
  bool hasRoot() => _posix.rootPrefix(_string) == separator;

  // into_path_buf : will not be implemented

  /// {@macro path.Path.isAbsolute}
  bool isAbsolute() => _posix.isAbsolute(_string);

  /// {@macro path.Path.isDirSync}
  bool isDirSync() => io.isDirSync(_string);

  /// {@macro path.Path.isDir}
  Future<bool> isDir() => io.isDir(_string);

  /// {@macro path.Path.isFileSync}
  bool isFileSync() => io.isFileSync(_string);

  /// {@macro path.Path.isFile}
  Future<bool> isFile() => io.isFile(_string);

  /// {@macro path.Path.isRelative}
  bool isRelative() => _posix.isRelative(_string);

  /// {@macro path.Path.isRoot}
  bool isSymlinkSync() => io.isSymlinkSync(_string);

  /// {@macro path.Path.isSymlink}
  Future<bool> isSymlink() => io.isSymlink(_string);

  /// {@macro path.Path.iter}
  Iter<String> iter() =>
      Iter.fromIterable(components().map((e) => e.toString()));

  /// {@macro path.Path.join}
  UnixPath join(UnixPath other) =>
      UnixPath(_posix.join(_string, other._string));

  /// {@macro path.Path.metadataSync}
  Result<Metadata, IoError>  metadataSync() => io.metadataSync(_string);

  /// {@macro path.Path.metadata}
  FutureResult<Metadata, IoError>  metadata() => io.metadata(_string);

// new : will not be implemented

  /// {@macro path.Path.parent}
  UnixPath? parent() {
    final comps = components().toList();
    if (comps.length == 1) {
      switch (comps.first) {
        case RootDir():
          return null;
        case Prefix():
          unreachable("Prefixes are not possible for Unix");
        case ParentDir():
        case CurDir():
        case Normal():
          return UnixPath("");
      }
    }
    if (comps.length > 1) {
      comps.removeLast();
    } else {
      return null;
    }
    return _joinUnixComponents(comps);
  }

  /// {@macro path.Path.parentOpt}
  @pragma('vm:prefer-inline')
  Option<UnixPath> parentOpt() => Option.of(parent());

  /// {@macro path.Path.readDirSync}
  Result<ReadDir, IoError> readDirSync() => io.readDirSync(_string);

  /// {@macro path.Path.readDir}
  Future<Result<ReadDir, IoError>> readDir() => io.readDir(_string);

  /// {@macro path.Path.readLinkSync}
  Result<UnixPath, IoError> readLinkSync() =>
      io.readLinkSync(_string) as Result<UnixPath, IoError>;

  /// {@macro path.Path.readLink}
  Future<Result<UnixPath, IoError>> readLink() =>
      io.readLink(_string) as Future<Result<UnixPath, IoError>>;

  /// {@macro path.Path.relativeTo}
  bool startsWith(UnixPath other) => _string.startsWith(other._string);

  /// {@macro path.Path.stripPrefix}
  UnixPath? stripPrefix(UnixPath prefix) {
    if (!startsWith(prefix)) {
      return null;
    }
    final newPath = _string.substring(prefix._string.length);
    return UnixPath(newPath);
  }

  /// {@macro path.Path.stripPrefix}
  @pragma('vm:prefer-inline')
  Option<UnixPath> stripPrefixOpt(UnixPath prefix) => Option.of(stripPrefix(prefix));

  /// {@macro path.Path.symlinkMetadataSync}
  Result<Metadata, IoError> symlinkMetadataSync() =>
      io.symlinkMetadataSync(_string);

  /// {@macro path.Path.symlinkMetadata}
  Future<Result<Metadata, IoError>> symlinkMetadata() =>
      io.symlinkMetadata(_string);

// to_path_buf: Will not implement, implementing a PathBuf does not make sense at the present (equality cannot hold for extension types and a potential PathBuf would likely be `StringBuffer` or `List<String>`).
// to_str: Implemented by type
// to_string_lossy: Will not be implemented
// try_exists: Will not implement

  /// {@macro path.Path.withExtension}
  UnixPath withExtension(String extension) {
    final stem = fileStemOpt().unwrapOr("");
    final parentN = parent();
    if (parentN == null) {
      if (stem.isEmpty) {
        return UnixPath(extension);
      } else {
        if (extension.isEmpty) {
          return UnixPath(stem);
        }
        return UnixPath("$stem.$extension");
      }
    }
    if (stem.isEmpty) {
      return parentN.join(UnixPath(extension));
    }
    if (extension.isEmpty) {
      return parentN.join(UnixPath(stem));
    }
    return parentN.join(UnixPath("$stem.$extension"));
  }

  /// {@macro path.Path.withFileName}
  UnixPath withFileName(String fileName) {
    final parentN = parent();
    if (parentN == null) {
      return UnixPath(fileName);
    }
    return parentN.join(UnixPath(fileName));
  }
}

UnixPath _joinUnixComponents(Iterable<Component> components) {
  final buffer = StringBuffer();
  final iterator = components.iterator;
  forEachExceptFirstAndLast(iterator, doFirst: (e) {
    if (e is RootDir) {
      buffer.write(UnixPath.separator);
    } else {
      buffer.write(e);
      buffer.write(UnixPath.separator);
    }
  }, doRest: (e) {
    buffer.write(e);
    buffer.write(UnixPath.separator);
  }, doLast: (e) {
    buffer.write(e);
  }, doIfOnlyOne: (e) {
    buffer.write(e);
  }, doIfEmpty: () {
    return buffer.write("");
  });
  return UnixPath(buffer.toString());
}
