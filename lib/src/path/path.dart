import 'platform_path.dart';
import 'unix_path.dart';
import 'windows_path.dart';

export 'platform_path.dart';
export 'windows_path.dart';
export 'unix_path.dart';
export 'io_error.dart';

extension Path$StringExtension on String {
  Path asPath() => Path(this);

  WindowsPath asWindowsPath() => WindowsPath(this);

  UnixPath asUnixPath() => UnixPath(this);
}

/// {@template path.Component}
/// A component of a path. A [Component] roughly corresponds to a substring between path separators (/ or \).
/// e.g. `..`, `dir_name`, `file_name.txt`
/// {@endtemplate}
/// Platform Independent.
sealed class Component {
  const Component();
}

/// {@template path.Prefix}
/// A Windows path prefix, e.g., C: or \\server\share. Does not occur on Unix.
/// {@endtemplate}
/// Platform Independent.
class Prefix extends Component {
  final String value;
  const Prefix(this.value);

  @override
  bool operator ==(Object other) => other == value || (other is Prefix && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

/// {@template path.RootDir}
/// The root directory component, appears after any prefix and before anything else.
/// It represents a separator that designates that a path starts from root.
/// {@endtemplate}
/// Platform Independent.
class RootDir extends Component {
  final bool isWindows;

  const RootDir(this.isWindows);

  @override
  bool operator ==(Object other) => other is RootDir && isWindows == other.isWindows;

  @override
  int get hashCode => isWindows.hashCode;

  @override
  String toString() => isWindows ? WindowsPath.separator : UnixPath.separator;
}

/// {@template path.CurDir}
/// The current directory of a path. i.e. `.`
/// {@endtemplate}
/// Platform Independent.
class CurDir extends Component {
  const CurDir();

  @override
  bool operator ==(Object other) => other is CurDir;

  @override
  int get hashCode => ".".hashCode;

  @override
  String toString() => ".";
}

/// {@template path.ParentDir}
/// The parent directory of a path. i.e. `..`
/// {@endtemplate}
/// Platform Independent.
class ParentDir extends Component {
  const ParentDir();

  @override
  bool operator ==(Object other) => other is ParentDir;

  @override
  int get hashCode => "..".hashCode;

  @override
  String toString() => "..";
}

/// {@template path.Normal}
/// A normal component, e.g., `a` and `b` in `a/b`
/// {@endtemplate}
/// Platform Independent.
class Normal extends Component {
  final String value;
  Normal(this.value);

  @override
  bool operator ==(Object other) => other is Normal && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
