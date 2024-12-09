part of 'path.dart';

/// A Windows Path.
/// {@macro path.Path}
extension type WindowsPath._(String _string) implements Object {
  static const String separator = "\\";

  static final RegExp _regularPathComponent = RegExp(r'^[ .\w-]+$');
  static final RegExp _oneOrMoreSlashes = RegExp(r'\\+');
  static final p.Context _windows = p.Context(style: p.Style.windows);

  const WindowsPath(this._string);

  @pragma("vm:prefer-inline")
  String asString() => _string;

  /// {@macro path.Path.ancestors}
  Iterable<WindowsPath> ancestors() sync* {
    yield this;
    WindowsPath? current = parent();
    while (current != null) {
      yield current;
      current = current.parent();
    }
  }

  /// {@macro path.Path.canonicalize}
  WindowsPath canonicalize() => WindowsPath(_windows.canonicalize(_string));

  /// {@macro path.Path.components}
  Iterable<Component> components() sync* {
    bool removeLast;
    // trailing slash does not matter
    if (_string.endsWith(separator)) {
      if (_string.length == 1) {
        yield RootDir(true);
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
        yield const RootDir(true);
        break;
      case ".":
        yield const CurDir();
        break;
      case "..":
        yield const ParentDir();
        break;
      default:
        if (_regularPathComponent.hasMatch(current)) {
          yield Normal(current);
        } else {
          yield Prefix(current);
          if (_string.replaceFirst(current, "").startsWith(separator)) {
            yield const RootDir(true);
          }
        }
    }
    while (iterator.moveNext()) {
      current = iterator.current;
      switch (current) {
        case ".":
          yield const CurDir();
          break;
        case "..":
          yield const ParentDir();
          break;
        default:
          yield Normal(current);
      }
    }
  }

  /// {@macro path.Path.endsWith}
  bool endsWith(WindowsPath other) => _string.endsWith(other._string);

  /// {@macro path.Path.existsSync}
  bool existsSync() => io.existsSync(_string);

  /// {@macro path.Path.exists}
  Future<bool> exists() => io.exists(_string);

  /// {@macro path.Path.extension}
  String extension() {
    String extensionWithDot = _windows.extension(_string);
    if (extensionWithDot.isNotEmpty) {
      assert(extensionWithDot.startsWith("."));
      return extensionWithDot.replaceFirst(".", "");
    }
    return extensionWithDot;
  }

  /// {@macro path.Path.fileName}
  String fileName() => _windows.basename(_string);

  /// {@macro path.Path.filePrefix}
  String? filePrefix() {
    final value = _windows.basename(_string);
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
    final fileStem = _windows.basenameWithoutExtension(_string);
    if (fileStem.isEmpty) {
      return null;
    }
    return fileStem;
  }

  /// {@macro path.Path.fileStem}
  Option<String> fileStemOpt() => Option.of(fileStem());

  /// {@macro path.Path.hasRoot}
  bool hasRoot() => _windows.rootPrefix(_string) == separator;

  /// {@macro path.Path.isAbsolute}
  bool isAbsolute() => _windows.isAbsolute(_string);

  /// {@macro path.Path.isDirSync}
  bool isDirSync() => io.isDirSync(_string);

  /// {@macro path.Path.isDir}
  Future<bool> isDir() => io.isDir(_string);

  /// {@macro path.Path.isFileSync}
  bool isFileSync() => io.isFileSync(_string);

  /// {@macro path.Path.isFile}
  Future<bool> isFile() => io.isFile(_string);

  /// {@macro path.Path.isRelative}
  bool isRelative() => _windows.isRelative(_string);

  /// {@macro path.Path.isSymlinkSync}
  bool isSymlinkSync() => io.isSymlinkSync(_string);

  /// {@macro path.Path.isSymlink}
  Future<bool> isSymlink() => io.isSymlink(_string);

  /// {@macro path.Path.iter}
  Iter<String> iter() =>
      Iter.fromIterable(components().map((e) => e.toString()));

  /// {@macro path.Path.join}
  WindowsPath join(WindowsPath other) =>
      WindowsPath(_windows.join(_string, other._string));

  /// {@macro path.Path.metadataSync}
  Result<Metadata, IoError>  metadataSync() => io.metadataSync(_string);

  /// {@macro path.Path.metadata}
  FutureResult<Metadata, IoError>  metadata() => io.metadata(_string);

  /// {@macro path.Path.normalize}
  WindowsPath? parent() {
    final comps = components().toList();
    if (comps.length == 1) {
      switch (comps.first) {
        case RootDir():
        case Prefix():
          return null;
        case ParentDir():
        case CurDir():
        case Normal():
          return WindowsPath("");
      }
    }
    if (comps.length > 1) {
      comps.removeLast();
    } else {
      return null;
    }
    if (comps.length == 1) {
      final prefix = comps[0];
      if (prefix case Prefix()) {
        return null;
      }
    }
    return _joinWindowsComponents(comps);
  }

  /// {@macro path.Path.parent}
  Option<WindowsPath> parentOpt() => Option.of(parent());

  /// {@macro path.Path.readDirSync}
  Result<ReadDir, IoError> readDirSync() => io.readDirSync(_string);

  /// {@macro path.Path.readDir}
  Future<Result<ReadDir, IoError>> readDir() => io.readDir(_string);

  /// {@macro path.Path.readLinkSync}
  Result<WindowsPath, IoError> readLinkSync() =>
      io.readLinkSync(_string) as Result<WindowsPath, IoError>;

  /// {@macro path.Path.readLink}
  Future<Result<WindowsPath, IoError>> readLink() =>
      io.readLink(_string) as Future<Result<WindowsPath, IoError>>;

  /// {@macro path.Path.startsWith}
  bool startsWith(WindowsPath other) => _string.startsWith(other._string);

  /// {@macro path.Path.stripPrefix}
  WindowsPath? stripPrefix(WindowsPath prefix) {
    if (!startsWith(prefix)) {
      return null;
    }
    final newPath = _string.substring(prefix._string.length);
    return WindowsPath(newPath);
  }

  /// {@macro path.Path.stripPrefix}
  @pragma('vm:prefer-inline')
  Option<WindowsPath> stripPrefixOpt(WindowsPath prefix) => Option.of(stripPrefix(prefix));

  /// {@macro path.Path.symlinkMetadataSync}
  Result<Metadata, IoError> symlinkMetadataSync() =>
      io.symlinkMetadataSync(_string);

  /// {@macro path.Path.symlinkMetadata}
  Future<Result<Metadata, IoError>> symlinkMetadata() =>
      io.symlinkMetadata(_string);

  /// {@macro path.Path.withExtension}
  WindowsPath withExtension(String extension) {
    final stem = fileStemOpt().unwrapOr("");
    final parentN = parent();
    if (parentN == null) {
      if (stem.isEmpty) {
        return WindowsPath(extension);
      } else {
        if (extension.isEmpty) {
          return WindowsPath(stem);
        }
        return WindowsPath("$stem.$extension");
      }
    }
    if (stem.isEmpty) {
      return parentN.join(WindowsPath(extension));
    }
    if (extension.isEmpty) {
      return parentN.join(WindowsPath(stem));
    }
    return parentN.join(WindowsPath("$stem.$extension"));
  }

  /// {@macro path.Path.withFileName}
  WindowsPath withFileName(String fileName) {
    final parentN = parent();
    if (parentN == null) {
      return WindowsPath(fileName);
    }
    return parentN.join(WindowsPath(fileName));
  }
}

WindowsPath _joinWindowsComponents(Iterable<Component> components) {
  final buffer = StringBuffer();
  final iterator = components.iterator;
  forEachExceptFirstAndLast(iterator, doFirst: (e) {
    switch (e) {
      case Prefix():
        buffer.write(e);
      case RootDir():
        buffer.write(WindowsPath.separator);
      case CurDir():
      case ParentDir():
      case Normal():
        buffer.write(e);
        buffer.write(WindowsPath.separator);
    }
  }, doRest: (e) {
    switch (e) {
      case Prefix():
        unreachable();
      case RootDir():
        buffer.write(WindowsPath.separator);
      case CurDir():
      case ParentDir():
      case Normal():
        buffer.write(e);
        buffer.write(WindowsPath.separator);
    }
  }, doLast: (e) {
    buffer.write(e);
  }, doIfOnlyOne: (e) {
    buffer.write(e);
  }, doIfEmpty: () {
    return buffer.write("");
  });
  return WindowsPath(buffer.toString());
}
