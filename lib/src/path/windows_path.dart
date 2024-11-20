import 'package:path/path.dart' as p;
import 'package:rust/rust.dart';

import 'platform/platform.dart' as platform;
import 'utils.dart';

const _pathSeparator = "\\";

extension UnixStringExtension on String {
  WindowsPath asWindowsPath() => WindowsPath(this);
}

/// A Windows Path.
/// {@macro path.Path}
extension type WindowsPath._(String string) implements Object {
  /// {@macro path.Path.isIoSupported}
  static bool isIoSupported() => platform.isIoSupported();

  static final RegExp _regularPathComponent = RegExp(r'^[ .\w-]+$');
  static final RegExp _oneOrMoreSlashes = RegExp(r'\\+');
  static final p.Context _windows = p.Context(style: p.Style.windows);

  WindowsPath(this.string);

  /// {@macro path.Path.ancestors}
  Iterable<WindowsPath> ancestors() sync* {
    yield this;
    WindowsPath? current = parent().v;
    while (current != null) {
      yield current;
      current = current.parent().v;
    }
  }

  /// {@macro path.Path.canonicalize}
  WindowsPath canonicalize() => WindowsPath(_windows.canonicalize(string));

  /// {@macro path.Path.components}
  Iterable<WindowsComponent> components() sync* {
    bool removeLast;
    // trailing slash does not matter
    if (string.endsWith(_pathSeparator)) {
      if (string.length == 1) {
        yield WindowsRootDir();
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
        yield WindowsRootDir();
        break;
      case ".":
        yield WindowsCurDir();
        break;
      case "..":
        yield WindowsParentDir();
        break;
      default:
        if (_regularPathComponent.hasMatch(current)) {
          yield WindowsNormal(current);
        } else {
          yield WindowsPrefix(current);
        }
    }
    while (iterator.moveNext()) {
      current = iterator.current;
      switch (current) {
        case ".":
          yield WindowsCurDir();
          break;
        case "..":
          yield WindowsParentDir();
          break;
        default:
          yield WindowsNormal(current);
      }
    }
  }

  /// {@macro path.Path.endsWith}
  bool endsWith(WindowsPath other) => string.endsWith(other.string);

  /// {@macro path.Path.existsSync}
  bool existsSync() => platform.existsSync(string);

  /// {@macro path.Path.exists}
  Future<bool> exists() => platform.exists(string);

  /// {@macro path.Path.extension}
  String extension() {
    String extensionWithDot = _windows.extension(string);
    if (extensionWithDot.isNotEmpty) {
      assert(extensionWithDot.startsWith("."));
      return extensionWithDot.replaceFirst(".", "");
    }
    return extensionWithDot;
  }

  /// {@macro path.Path.fileName}
  String fileName() => _windows.basename(string);

  /// {@macro path.Path.filePrefix}
  Option<String> filePrefix() {
    final value = _windows.basename(string);
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

  /// {@macro path.Path.fileStem}
  Option<String> fileStem() {
    final fileStem = _windows.basenameWithoutExtension(string);
    if (fileStem.isEmpty) {
      return None;
    }
    return Some(fileStem);
  }

  /// {@macro path.Path.hasRoot}
  bool hasRoot() => _windows.rootPrefix(string) == _pathSeparator;

  /// {@macro path.Path.isAbsolute}
  bool isAbsolute() => _windows.isAbsolute(string);

  /// {@macro path.Path.isDirSync}
  bool isDirSync() => platform.isDirSync(string);

  /// {@macro path.Path.isDir}
  Future<bool> isDir() => platform.isDir(string);

  /// {@macro path.Path.isFileSync}
  bool isFileSync() => platform.isFileSync(string);

  /// {@macro path.Path.isFile}
  Future<bool> isFile() => platform.isFile(string);

  /// {@macro path.Path.isRelative}
  bool isRelative() => _windows.isRelative(string);

  /// {@macro path.Path.isSymlinkSync}
  bool isSymlinkSync() => platform.isSymlinkSync(string);

  /// {@macro path.Path.isSymlink}
  Future<bool> isSymlink() => platform.isSymlink(string);

  /// {@macro path.Path.iter}
  Iter<String> iter() => Iter.fromIterable(components().map((e) => e.toString()));

  /// {@macro path.Path.join}
  WindowsPath join(WindowsPath other) => WindowsPath(_windows.join(string, other.string));

  /// {@macro path.Path.metadataSync}
  platform.Metadata metadataSync() => platform.metadataSync(string);

  /// {@macro path.Path.metadata}
  Future<platform.Metadata> metadata() => platform.metadata(string);

  /// {@macro path.Path.normalize}
  Option<WindowsPath> parent() {
    final comps = components().toList();
    if (comps.length == 1) {
      switch (comps.first) {
        case WindowsRootDir():
        case WindowsPrefix():
          return None;
        case WindowsParentDir():
        case WindowsCurDir():
        case WindowsNormal():
          return Some(WindowsPath(""));
      }
    }
    if (comps.length > 1) {
      comps.removeLast();
    } else {
      return None;
    }
    return Some(_joinComponents(comps));
  }

  /// {@macro path.Path.readDirSync}
  Result<platform.ReadDir, IoError> readDirSync() => platform.readDirSync(string);

  /// {@macro path.Path.readDir}
  Future<Result<platform.ReadDir, IoError>> readDir() => platform.readDir(string);

  /// {@macro path.Path.readLinkSync}
  Result<WindowsPath, IoError> readLinkSync() =>
      platform.readLinkSync(string) as Result<WindowsPath, IoError>;

  /// {@macro path.Path.readLink}
  Future<Result<WindowsPath, IoError>> readLink() =>
      platform.readLink(string) as Future<Result<WindowsPath, IoError>>;

  /// {@macro path.Path.startsWith}
  bool startsWith(WindowsPath other) => string.startsWith(other.string);

  /// {@macro path.Path.stripPrefix}
  Option<WindowsPath> stripPrefix(WindowsPath prefix) {
    if (!startsWith(prefix)) {
      return None;
    }
    final newPath = string.substring(prefix.string.length);
    return Some(WindowsPath(newPath));
  }

  /// {@macro path.Path.symlinkMetadataSync}
  Result<platform.Metadata, IoError> symlinkMetadataSync() => platform.symlinkMetadataSync(string);

  /// {@macro path.Path.symlinkMetadata}
  Future<Result<platform.Metadata, IoError>> symlinkMetadata() => platform.symlinkMetadata(string);

  /// {@macro path.Path.withExtension}
  WindowsPath withExtension(String extension) {
    final stem = fileStem().unwrapOr("");
    final parentOption = parent();
    if (parentOption.isNone()) {
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
      return parentOption.unwrap().join(WindowsPath(extension));
    }
    if (extension.isEmpty) {
      return parentOption.unwrap().join(WindowsPath(stem));
    }
    return parentOption.unwrap().join(WindowsPath("$stem.$extension"));
  }

  /// {@macro path.Path.withFileName}
  WindowsPath withFileName(String fileName) {
    final parentOption = parent();
    return switch (parentOption) {
      None => WindowsPath(fileName),
      // ignore: pattern_never_matches_value_type
      Some(:final v) => v.join(WindowsPath(fileName)),
    };
  }
}

WindowsPath _joinComponents(Iterable<WindowsComponent> components) {
  final buffer = StringBuffer();
  final iterator = components.iterator;
  forEachExceptFirstAndLast(iterator, doFirst: (e) {
    if (e is WindowsRootDir) {
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
  return WindowsPath(buffer.toString());
}

//************************************************************************//

/// {@macro path.Component}
sealed class WindowsComponent {
  const WindowsComponent();
}

/// {@macro path.Prefix}
class WindowsPrefix extends WindowsComponent {
  final String value;
  const WindowsPrefix(this.value);

  @override
  bool operator ==(Object other) =>
      other == value || (other is WindowsPrefix && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

/// {@macro path.RootDir}
class WindowsRootDir extends WindowsComponent {
  const WindowsRootDir();

  @override
  bool operator ==(Object other) => other == _pathSeparator || other is WindowsRootDir;

  @override
  int get hashCode => _pathSeparator.hashCode;

  @override
  String toString() => _pathSeparator;
}

/// {@macro path.CurDir}
class WindowsCurDir extends WindowsComponent {
  const WindowsCurDir();

  @override
  bool operator ==(Object other) => other == "." || other is WindowsCurDir;

  @override
  int get hashCode => ".".hashCode;

  @override
  String toString() => ".";
}

/// {@macro path.ParentDir}
class WindowsParentDir extends WindowsComponent {
  const WindowsParentDir();

  @override
  bool operator ==(Object other) => other == ".." || other is WindowsParentDir;

  @override
  int get hashCode => "..".hashCode;

  @override
  String toString() => "..";
}

/// {@macro path.Normal}
class WindowsNormal extends WindowsComponent {
  final String value;
  WindowsNormal(this.value);

  @override
  bool operator ==(Object other) =>
      other == value || (other is WindowsNormal && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
