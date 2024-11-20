import 'unix_path.dart';

typedef Path = UnixPath;

typedef Component = UnixComponent;

typedef RootDir = UnixRootDir;

typedef CurDir = UnixCurDir;

typedef ParentDir = UnixParentDir;

typedef Normal = UnixNormal;

extension PathStringExtension on String {
  Path asPath() => Path(this);
}