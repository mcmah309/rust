part of 'path.dart';

/// A Unix Path.
/// {@macro path.Path}
extension type UnixPath._(String _string) implements Object {
  static const String separator = "/";

  /// {@template path.Path.isIoSupported}
  /// Returns whether io operations are supported. If false, is currently running on the web.
  /// {@endtemplate}
  static const bool isIoSupported = io.isIoSupported;

  static final RegExp _oneOrMoreSlashes = RegExp('$separator+');
  static final p.Context _posix = p.Context(style: p.Style.posix);

  UnixPath(this._string);

  @pragma("vm:prefer-inline")
  String asString() => _string;

  /// {@template path.Path.ancestors}
  /// Produces an iterator over Path and its ancestors. e.g. `/a/b/c` will produce `/a/b/c`, `/a/b`, `/a`, and `/`.
  /// {@endtemplate}
  Iterable<UnixPath> ancestors() sync* {
    yield this;
    Option<UnixPath> currentOpt = parent();
    while (currentOpt.isSome()) {
      final current = currentOpt.unwrap();
      yield current;
      currentOpt = current.parent();
    }
  }

// as_mut_os_str : will not be implemented
// as_os_str : will not be implemented

  /// {@template path.Path.canonicalize}
  /// Returns the canonical, absolute form of the path with all intermediate components normalized.
  /// {@endtemplate}
  UnixPath canonicalize() => UnixPath(_posix.canonicalize(_string));

  /// {@template path.Path.components}
  /// Produces an iterator over the Components of the path.
  /// {@endtemplate}
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

  /// {@template path.Path.endsWith}
  /// Determines whether other is a suffix of this.
  /// {@endtemplate}
  bool endsWith(UnixPath other) => _string.endsWith(other._string);

  /// {@template path.Path.existsSync}
  /// Determines whether file exists on disk.
  /// {@endtemplate}
  bool existsSync() => io.existsSync(_string);

  /// {@template path.Path.exists}
  /// Determines whether file exists on disk.
  /// {@endtemplate}
  Future<bool> exists() => io.exists(_string);

  /// {@template path.Path.extension}
  /// Extracts the extension (without the leading dot) of self.file_name, if possible.
  /// {@endtemplate}
  String extension() {
    String extensionWithDot = _posix.extension(_string);
    if (extensionWithDot.isNotEmpty) {
      assert(extensionWithDot.startsWith("."));
      return extensionWithDot.replaceFirst(".", "");
    }
    return extensionWithDot;
  }

  /// {@template path.Path.fileName}
  /// Returns the final component of the Path, if there is one.
  /// {@endtemplate}
  String fileName() => _posix.basename(_string);

  /// {@template path.Path.filePrefix}
  /// Extracts the portion of the file name before the first "." -
  ///
  /// None, if there is no file name;
  /// The entire file name if there is no embedded .;
  /// The portion of the file name before the first non-beginning .;
  /// The entire file name if the file name begins with . and has no other .s within;
  /// The portion of the file name before the second . if the file name begins with .
  /// {@endtemplate}
  Option<String> filePrefix() {
    final value = _posix.basename(_string);
    if (value.isEmpty) {
      return None;
    }
    if (!value.contains(".")) {
      return Some(value);
    }
    if (value.startsWith(".")) {
      final splits = value.split(".");
      if (splits.length == 2) {
        return Some(value);
      } else {
        assert(splits.length > 2);
        return Some(splits[1]);
      }
    }
    return Some(value.split(".").first);
  }

  /// {@template path.Path.fileStem}
  /// Extracts the portion of the file name before the last "." -
  ///
  /// None, if there is no file name;
  /// The entire file name if there is no embedded .;
  /// The entire file name if the file name begins with . and has no other .s within;
  /// Otherwise, the portion of the file name before the final .
  /// {@endtemplate}
  Option<String> fileStem() {
    final fileStem = _posix.basenameWithoutExtension(_string);
    if (fileStem.isEmpty) {
      return None;
    }
    return Some(fileStem);
  }

  /// {@template path.Path.hasRoot}
  /// Returns true if the Path has a root.
  /// {@endtemplate}
  bool hasRoot() => _posix.rootPrefix(_string) == separator;

  // into_path_buf : will not be implemented

  /// {@template path.Path.isAbsolute}
  /// Returns true if the Path is absolute, i.e., if it is independent of the current directory.
  /// {@endtemplate}
  bool isAbsolute() => _posix.isAbsolute(_string);

  /// {@template path.Path.isDirSync}
  /// Returns true if the path exists on disk and is pointing at a directory. Does not follow links.
  /// {@endtemplate}
  bool isDirSync() => io.isDirSync(_string);

  /// {@template path.Path.isDir}
  /// Returns true if the path exists on disk and is pointing at a directory. Does not follow links.
  /// {@endtemplate}
  Future<bool> isDir() => io.isDir(_string);

  /// {@template path.Path.isFileSync}
  /// Returns true if the path exists on disk and is pointing at a regular file. Does not follow links.
  /// {@endtemplate}
  bool isFileSync() => io.isFileSync(_string);

  /// {@template path.Path.isFile}
  /// Returns true if the path exists on disk and is pointing at a regular file. Does not follow links.
  /// {@endtemplate}
  Future<bool> isFile() => io.isFile(_string);

  /// {@template path.Path.isRelative}
  /// Returns true if the Path is relative, i.e., not absolute.
  /// {@endtemplate}
  bool isRelative() => _posix.isRelative(_string);

  /// {@template path.Path.isRoot}
  /// Returns true if the path exists on disk and is pointing at a symlink. Does not follow links.
  /// {@endtemplate}
  bool isSymlinkSync() => io.isSymlinkSync(_string);

  /// {@template path.Path.isSymlink}
  /// Returns true if the path exists on disk and is pointing at a symlink. Does not follow links.
  /// {@endtemplate}
  Future<bool> isSymlink() => io.isSymlink(_string);

  /// {@template path.Path.iter}
  /// Produces an iterator over the path’s components viewed as Strings
  /// {@endtemplate}
  Iter<String> iter() =>
      Iter.fromIterable(components().map((e) => e.toString()));

  /// {@template path.Path.join}
  /// Creates an Path with path adjoined to this.
  /// {@endtemplate}
  UnixPath join(UnixPath other) =>
      UnixPath(_posix.join(_string, other._string));

  /// {@template path.Path.metadataSync}
  /// Queries the file system to get information about a file, directory, etc.
  /// Note: using this method means that the program can no longer compile for the web.
  /// {@endtemplate}
  io.Metadata metadataSync() => io.metadataSync(_string);

  /// {@template path.Path.metadata}
  /// Queries the file system to get information about a file, directory, etc.
  /// Note: using this method means that the program can no longer compile for the web.
  /// {@endtemplate}
  Future<io.Metadata> metadata() => io.metadata(_string);

// new : will not be implemented

  /// {@template path.Path.parent}
  /// Returns the Path without its final component, if there is one.
  /// This means it returns Some("") for relative paths with one component.
  /// Returns None if the path terminates in a root or prefix, or if it’s the empty string.
  /// {@endtemplate}
  Option<UnixPath> parent() {
    final comps = components().toList();
    if (comps.length == 1) {
      switch (comps.first) {
        case RootDir():
          return None;
        case Prefix():
          unreachable("Prefixes are not possible for Unix");
        case ParentDir():
        case CurDir():
        case Normal():
          return Some(UnixPath(""));
      }
    }
    if (comps.length > 1) {
      comps.removeLast();
    } else {
      return None;
    }
    return Some(_joinUnixComponents(comps));
  }

  /// {@template path.Path.readDirSync}
  /// Returns an iterator over the entries within a directory.
  /// Note: using this method results in the program no longer being able to compile to web.
  /// {@endtemplate}
  Result<io.ReadDir, PathIoError> readDirSync() => io.readDirSync(_string);

  /// {@template path.Path.readDir}
  /// Returns an iterator over the entries within a directory.
  /// Note: using this method results in the program no longer being able to compile to web.
  /// {@endtemplate}
  Future<Result<io.ReadDir, PathIoError>> readDir() => io.readDir(_string);

  /// {@template path.Path.readLinkSync}
  /// Reads a symbolic link, returning the file that the link points to.
  /// {@endtemplate}
  Result<UnixPath, PathIoError> readLinkSync() =>
      io.readLinkSync(_string) as Result<UnixPath, PathIoError>;

  /// {@template path.Path.readLink}
  /// Reads a symbolic link, returning the file that the link points to.
  /// {@endtemplate}
  Future<Result<UnixPath, PathIoError>> readLink() =>
      io.readLink(_string) as Future<Result<UnixPath, PathIoError>>;

  /// {@template path.Path.relativeTo}
  /// Determines whether other is a prefix of this.
  /// {@endtemplate}
  bool startsWith(UnixPath other) => _string.startsWith(other._string);

  /// {@template path.Path.stripPrefix}
  /// Returns a path that, when joined onto base, yields this. Returns None if [prefix] is not a subpath of base.
  /// {@endtemplate}
  Option<UnixPath> stripPrefix(UnixPath prefix) {
    if (!startsWith(prefix)) {
      return None;
    }
    final newPath = _string.substring(prefix._string.length);
    return Some(UnixPath(newPath));
  }

  /// {@template path.Path.symlinkMetadataSync}
  /// Returns the metadata for the symlink.
  /// Note: using this method means that the program can no longer compile for the web.
  /// {@endtemplate}
  Result<io.Metadata, PathIoError> symlinkMetadataSync() =>
      io.symlinkMetadataSync(_string);

  /// {@template path.Path.symlinkMetadata}
  /// Returns the metadata for the symlink.
  /// Note: using this method means that the program can no longer compile for the web.
  /// {@endtemplate}
  Future<Result<io.Metadata, PathIoError>> symlinkMetadata() =>
      io.symlinkMetadata(_string);

// to_path_buf: Will not implement, implementing a PathBuf does not make sense at the present (equality cannot hold for extension types and a potential PathBuf would likely be `StringBuffer` or `List<String>`).
// to_str: Implemented by type
// to_string_lossy: Will not be implemented
// try_exists: Will not implement

  /// {@template path.Path.withExtension}
  /// Creates an Path like this but with the given extension.
  /// {@endtemplate}
  UnixPath withExtension(String extension) {
    final stem = fileStem().unwrapOr("");
    final parentOption = parent();
    if (parentOption.isNone()) {
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
      return parentOption.unwrap().join(UnixPath(extension));
    }
    if (extension.isEmpty) {
      return parentOption.unwrap().join(UnixPath(stem));
    }
    return parentOption.unwrap().join(UnixPath("$stem.$extension"));
  }

  /// {@template path.Path.withFileName}
  /// Creates an PathBuf like this but with the given file name.
  /// {@endtemplate}
  UnixPath withFileName(String fileName) {
    final parentOption = parent();
    return switch (parentOption) {
      // ignore: pattern_never_matches_value_type
      Some(:final v) => v.join(UnixPath(fileName)),
      _ => UnixPath(fileName),
    };
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
