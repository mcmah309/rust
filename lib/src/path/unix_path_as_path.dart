import 'unix_path.dart';
import 'windows_path.dart';

/// {@macro path.Path}
typedef Path = UnixPath;

/// {@macro path.Component}
typedef Component = UnixComponent;

/// {@macro path.Prefix}
typedef Prefix = UnixPrefix;

/// {@macro path.RootDir}
typedef RootDir = UnixRootDir;

/// {@macro path.CurDir}
typedef CurDir = UnixCurDir;

/// {@macro path.ParentDir}
typedef ParentDir = UnixParentDir;

/// {@macro path.Normal}
typedef Normal = UnixNormal;


extension Path$StringExtension on String {
  Path asPath() => Path(this);

  WindowsPath asWindowsPath() => WindowsPath(this);

  UnixPath asUnixPath() => UnixPath(this);
}