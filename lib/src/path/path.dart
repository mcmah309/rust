import 'package:rust/rust.dart';
import 'package:path/path.dart' as p;

import 'io/io.dart' as io;
import 'utils.dart';

part 'platform_path.dart';
part 'unix_path.dart';
part 'windows_path.dart';

extension Path$StringExtension on String {
  @pragma("vm:prefer-inline")
  Path asPath() => Path(this);

  @pragma("vm:prefer-inline")
  WindowsPath asWindowsPath() => WindowsPath(this);

  @pragma("vm:prefer-inline")
  UnixPath asUnixPath() => UnixPath(this);
}

/// {@template path.Component}
/// A component of a path. A [Component] roughly corresponds to a substring between path separators (/ or \).
/// e.g. `..`, `dir_name`, `file_name.txt`
/// {@endtemplate}
sealed class Component {
  const Component();
}

/// {@template path.Prefix}
/// A Windows path prefix, e.g., C: or \\server\share. Does not occur on Unix.
/// {@endtemplate}
class Prefix extends Component {
  final String value;
  const Prefix(this.value);

  @override
  bool operator ==(Object other) =>
      other == value || (other is Prefix && other.value == value);

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}

/// {@template path.RootDir}
/// The root directory component, appears after any prefix and before anything else.
/// It represents a separator that designates that a path starts from root.
/// {@endtemplate}
class RootDir extends Component {
  final bool isWindows;

  const RootDir(this.isWindows);

  @override
  bool operator ==(Object other) =>
      other is RootDir && isWindows == other.isWindows;

  @override
  int get hashCode => isWindows.hashCode;

  @override
  String toString() => isWindows ? WindowsPath.separator : UnixPath.separator;
}

/// {@template path.CurDir}
/// The current directory of a path. i.e. `.`
/// {@endtemplate}
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
