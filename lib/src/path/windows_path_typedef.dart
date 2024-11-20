import 'windows_path.dart';

/// {@macro path.Path}
/// Platform Independent.
typedef Path = WindowsPath;

/// {@macro path.Component}
/// Platform Independent.
typedef Component = WindowsComponent;

/// {@macro path.Prefix}
/// Platform Independent.
typedef Prefix = WindowsPrefix;

/// {@macro path.RootDir}
/// Platform Independent.
typedef RootDir = WindowsRootDir;

/// {@macro path.CurDir}
/// Platform Independent.
typedef CurDir = WindowsCurDir;

/// {@macro path.ParentDir}
/// Platform Independent.
typedef ParentDir = WindowsParentDir;

/// {@macro path.Normal}
/// Platform Independent.
typedef Normal = WindowsNormal;

extension PathStringExtension on String {
  Path asPath() => Path(this);
}