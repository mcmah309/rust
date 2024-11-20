import 'windows_path.dart';

typedef Path = WindowsPath;

typedef Component = WindowsComponent;

typedef RootDir = WindowsRootDir;

typedef CurDir = WindowsCurDir;

typedef ParentDir = WindowsParentDir;

typedef Normal = WindowsNormal;

extension PathStringExtension on String {
  Path asPath() => Path(this);
}