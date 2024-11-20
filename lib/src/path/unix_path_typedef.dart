import 'unix_path.dart';

/// {@template path.Path}
/// [Path] is for handling file paths in a type-safe manner.
/// This type supports a number of operations for inspecting a path, including breaking the path into its components,
/// extracting the file name, determining whether the path is absolute, and so on.
/// {@endtemplate}
/// Platform Independent.
typedef Path = UnixPath;

/// {@template path.Component}
/// A component of a path. A [Component] roughly corresponds to a substring between path separators (/ or \). 
/// e.g. `..`, `dir_name`, `file_name.txt`
/// {@endtemplate}
/// Platform Independent.
typedef Component = UnixComponent;

/// {@template path.Prefix}
/// A Windows path prefix, e.g., C: or \\server\share. Does not occur on Unix.
/// {@endtemplate}
/// Platform Independent.
typedef Prefix = UnixPrefix;

/// {@template path.RootDir}
/// The root directory of a path.
/// {@endtemplate}
/// Platform Independent.
typedef RootDir = UnixRootDir;

/// {@template path.CurDir}
/// The current directory of a path. i.e. `.`
/// {@endtemplate}
/// Platform Independent.
typedef CurDir = UnixCurDir;

/// {@template path.ParentDir}
/// The parent directory of a path. i.e. `..`
/// {@endtemplate}
/// Platform Independent.
typedef ParentDir = UnixParentDir;

/// {@template path.Normal}
/// A normal component, e.g., `a` and `b` in `a/b`
/// {@endtemplate}
/// Platform Independent.
typedef Normal = UnixNormal;


extension PathStringExtension on String {
  Path asPath() => Path(this);
}