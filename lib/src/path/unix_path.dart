import 'package:path/path.dart' as p;
import 'package:rust/rust.dart';

import 'io_error.dart';
import 'platform/platform.dart' as platform;
import 'utils.dart';

const _pathSeparator = "/";

extension WindowsStringExtension on String {
  UnixPath asUnixPath() => UnixPath(this);
}

/// This type supports a number of operations for inspecting a path, including breaking the path into its components,
/// extracting the file name, determining whether the path is absolute, and so on.
extension type UnixPath._(String string) implements Object {
  /// Returns whether io operations are supported. If false, is currently running on the web.
  static bool isIoSupported() => platform.isIoSupported();

  static final RegExp _regularPathComponent = RegExp(r'^[ \\.\w-]+$');
  static final RegExp _oneOrMoreSlashes = RegExp('$_pathSeparator+');
  static final p.Context _posix = p.Context(style: p.Style.posix);

  UnixPath(this.string);

  Iterable<UnixPath> ancestors() sync* {
    yield this;
    UnixPath? current = parent().v;
    while (current != null) {
      yield current;
      current = current.parent().v;
    }
  }

// as_mut_os_str : will not be implemented
// as_os_str : will not be implemented

  UnixPath canonicalize() => UnixPath(_posix.canonicalize(string));

  Iterable<UnixComponent> components() sync* {
    bool removeLast;
    // trailing slash does not matter
    if (string.endsWith(_pathSeparator)) {
      if (string.length == 1) {
        yield UnixRootDir();
        return;
      }
      removeLast = true;
    } else {
      removeLast = false;
    }
    final splits = string.split(_oneOrMoreSlashes);
    if (removeLast) {
      splits.removeLast();
    }

    final iterator = splits.iterator;
    iterator.moveNext();
    var current = iterator.current;
    switch (current) {
      case "":
        yield UnixRootDir();
        break;
      case ".":
        yield UnixCurDir();
        break;
      case "..":
        yield UnixParentDir();
        break;
      default:
        if (_regularPathComponent.hasMatch(current)) {
          yield UnixNormal(current);
        } else {
          yield UnixPrefix(current);
        }
    }
    while (iterator.moveNext()) {
      current = iterator.current;
      switch (current) {
        case ".":
          yield UnixCurDir();
          break;
        case "..":
          yield UnixParentDir();
          break;
        default:
          yield UnixNormal(current);
      }
    }
  }

  /// String representation of the path
  String display() => toString();

  /// Determines whether other is a suffix of this.
  bool endsWith(UnixPath other) => string.endsWith(other.string);

  /// Determines whether file exists on disk.
  bool existsSync() => platform.existsSync(string);

  /// Determines whether file exists on disk.
  Future<bool> exists() => platform.exists(string);

  /// Extracts the extension (without the leading dot) of self.file_name, if possible.
  String extension() {
    String extensionWithDot = _posix.extension(string);
    if (extensionWithDot.isNotEmpty) {
      assert(extensionWithDot.startsWith("."));
      return extensionWithDot.replaceFirst(".", "");
    }
    return extensionWithDot;
  }

  /// Returns the final component of the Path, if there is one.
  String fileName() => _posix.basename(string);

  /// Extracts the portion of the file name before the first "." -
  ///
  /// None, if there is no file name;
  /// The entire file name if there is no embedded .;
  /// The portion of the file name before the first non-beginning .;
  /// The entire file name if the file name begins with . and has no other .s within;
  /// The portion of the file name before the second . if the file name begins with .
  Option<String> filePrefix() {
    final value = _posix.basename(string);
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

  /// Extracts the portion of the file name before the last "." -
  ///
  /// None, if there is no file name;
  /// The entire file name if there is no embedded .;
  /// The entire file name if the file name begins with . and has no other .s within;
  /// Otherwise, the portion of the file name before the final .
  Option<String> fileStem() {
    final fileStem = _posix.basenameWithoutExtension(string);
    if (fileStem.isEmpty) {
      return None;
    }
    return Some(fileStem);
  }

  /// Returns true if the Path has a root.
  bool hasRoot() => _posix.rootPrefix(string) == _pathSeparator;

  // into_path_buf : will not be implemented

  /// Returns true if the Path is absolute, i.e., if it is independent of the current directory.
  bool isAbsolute() => _posix.isAbsolute(string);

  /// Returns true if the path exists on disk and is pointing at a directory. Does not follow links.
  bool isDirSync() => platform.isDirSync(string);

  /// Returns true if the path exists on disk and is pointing at a directory. Does not follow links.
  Future<bool> isDir() => platform.isDir(string);

  /// Returns true if the path exists on disk and is pointing at a regular file. Does not follow links.
  bool isFileSync() => platform.isFileSync(string);

  /// Returns true if the path exists on disk and is pointing at a regular file. Does not follow links.
  Future<bool> isFile() => platform.isFile(string);

  /// Returns true if the Path is relative, i.e., not absolute.
  bool isRelative() => _posix.isRelative(string);

  /// Returns true if the path exists on disk and is pointing at a symlink. Does not follow links.
  bool isSymlinkSync() => platform.isSymlinkSync(string);

  /// Returns true if the path exists on disk and is pointing at a symlink. Does not follow links.
  Future<bool> isSymlink() => platform.isSymlink(string);

  /// Produces an iterator over the path’s components viewed as Strings
  Iter<String> iter() =>
      Iter.fromIterable(components().map((e) => e.toString()));

  /// Creates an Path with path adjoined to this.
  UnixPath join(UnixPath other) => UnixPath(_posix.join(string, other.string));

  /// Queries the file system to get information about a file, directory, etc.
  /// Note: using this method means that the program can no longer compile for the web.
  platform.Metadata metadataSync() => platform.metadataSync(string);

  /// Queries the file system to get information about a file, directory, etc.
  /// Note: using this method means that the program can no longer compile for the web.
  Future<platform.Metadata> metadata() => platform.metadata(string);

// new : will not be implemented

  /// Returns the Path without its final component, if there is one.
  /// This means it returns Some("") for relative paths with one component.
  /// Returns None if the path terminates in a root or prefix, or if it’s the empty string.
  Option<UnixPath> parent() {
    final comps = components().toList();
    if (comps.length == 1) {
      switch (comps.first) {
        case UnixRootDir():
        case UnixPrefix():
          return None;
        case UnixParentDir():
        case UnixCurDir():
        case UnixNormal():
          return Some(UnixPath(""));
      }
    }
    if (comps.length > 1) {
      comps.removeLast();
    } else {
      return None;
    }
    return Some(_joinComponents(comps));
  }

  /// Returns an iterator over the entries within a directory.
  /// Note: using this method results in the program no longer being able to compile to web.
  Result<platform.ReadDir, IoError> readDirSync() =>
      platform.readDirSync(string);

  /// Returns an iterator over the entries within a directory.
  /// Note: using this method results in the program no longer being able to compile to web.
  Future<Result<platform.ReadDir, IoError>> readDir() =>
      platform.readDir(string);

  /// Reads a symbolic link, returning the file that the link points to.
  Result<UnixPath, IoError> readLinkSync() =>
      platform.readLinkSync(string) as Result<UnixPath, IoError>;

  /// Reads a symbolic link, returning the file that the link points to.
  Future<Result<UnixPath, IoError>> readLink() =>
      platform.readLink(string) as Future<Result<UnixPath, IoError>>;

  /// Determines whether other is a prefix of this.
  bool startsWith(UnixPath other) => string.startsWith(other.string);

  /// Returns a path that, when joined onto base, yields this. Returns None if [prefix] is not a subpath of base.
  Option<UnixPath> stripPrefix(UnixPath prefix) {
    if (!startsWith(prefix)) {
      return None;
    }
    final newPath = string.substring(prefix.string.length);
    return Some(UnixPath(newPath));
  }

  /// Returns the metadata for the symlink.
  /// Note: using this method means that the program can no longer compile for the web.
  Result<platform.Metadata, IoError> symlinkMetadataSync() =>
      platform.symlinkMetadataSync(string);

  /// Returns the metadata for the symlink.
  /// Note: using this method means that the program can no longer compile for the web.
  Future<Result<platform.Metadata, IoError>> symlinkMetadata() =>
      platform.symlinkMetadata(string);

// to_path_buf: Will not implement, implementing a PathBuf does not make sense at the present (equality cannot hold for extension types and a potential PathBuf would likely be `StringBuffer` or `List<String>`).
// to_str: Implemented by type
// to_string_lossy: Will not be implemented
// try_exists: Will not implement

  /// Creates an Path like this but with the given extension.
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

  /// Creates an PathBuf like this but with the given file name.
  UnixPath withFileName(String fileName) {
    final parentOption = parent();
    return switch (parentOption) {
      None => UnixPath(fileName),
      // ignore: pattern_never_matches_value_type
      Some(:final v) => v.join(UnixPath(fileName)),
    };
  }
}

UnixPath _joinComponents(Iterable<UnixComponent> components) {
  final buffer = StringBuffer();
  final iterator = components.iterator;
  forEachExceptFirstAndLast(iterator, doFirst: (e) {
    if (e is UnixRootDir) {
      buffer.write(_pathSeparator);
    } else {
      buffer.write(e);
      buffer.write(_pathSeparator);
    }
  }, doRest: (e) {
    buffer.write(e);
    buffer.write(_pathSeparator);
  }, doLast: (e) {
    buffer.write(e);
  }, doIfOnlyOne: (e) {
    buffer.write(e);
  }, doIfEmpty: () {
    return buffer.write("");
  });
  return UnixPath(buffer.toString());
}

//************************************************************************//

sealed class UnixComponent {
  const UnixComponent();
}

class UnixPrefix extends UnixComponent {
  final String value;
  const UnixPrefix(this.value);

  @override
  bool operator ==(Object other) =>
      other == value || (other is UnixPrefix && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

class UnixRootDir extends UnixComponent {
  const UnixRootDir();

  @override
  bool operator ==(Object other) => other == _pathSeparator || other is UnixRootDir;

  @override
  int get hashCode => _pathSeparator.hashCode;

  @override
  String toString() => _pathSeparator;
}

class UnixCurDir extends UnixComponent {
  const UnixCurDir();

  @override
  bool operator ==(Object other) => other == "." || other is UnixCurDir;

  @override
  int get hashCode => ".".hashCode;

  @override
  String toString() => ".";
}

class UnixParentDir extends UnixComponent {
  const UnixParentDir();

  @override
  bool operator ==(Object other) => other == ".." || other is UnixParentDir;

  @override
  int get hashCode => "..".hashCode;

  @override
  String toString() => "..";
}

class UnixNormal extends UnixComponent {
  final String value;
  UnixNormal(this.value);

  @override
  bool operator ==(Object other) =>
      other == value || (other is UnixNormal && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
