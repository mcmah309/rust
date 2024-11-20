import 'windows_path.dart';

/// {@macro path.Path}
typedef Path = WindowsPath;

/// {@macro path.Component}
typedef Component = WindowsComponent;

/// {@macro path.Prefix}
typedef Prefix = WindowsPrefix;

/// {@macro path.RootDir}
typedef RootDir = WindowsRootDir;

/// {@macro path.CurDir}
typedef CurDir = WindowsCurDir;

/// {@macro path.ParentDir}
typedef ParentDir = WindowsParentDir;

/// {@macro path.Normal}
typedef Normal = WindowsNormal;

extension PathStringExtension on String {
  Path asPath() => Path(this);
}