import 'dart:io';
import 'package:rust/rust.dart';

/// A cross platform version of [Platform] with additional powers related to the environment
class Env {
  static Path get currentDirectory => Path(Directory.current.path);

  static set setCurrentDirectory(Path path) => Directory.current = path.asString();

  /// joins a collection of Paths appropriately for the PATH environment variable.
  static String joinPaths(Iterable<String> paths) {
    StringBuffer buf = StringBuffer();
    bool canAddToEnd = false;
    for (var path in paths) {
      if (canAddToEnd) {
        buf.write(envVarPathSeparator);
      }
      canAddToEnd = true;
      buf.write(path);
    }
    return buf.toString();
  }

  /// splits a PATH environment variable string into a collection of Paths.
  static Iterable<String> splitPaths(String paths) => paths.split(envVarPathSeparator);

  static Iterable<(String key, String val)> envVars() =>
      environment.entries.map((item) => (item.key, item.value));

  static String? envVar(String key) => environment[key];

  /// The PATH separator for the current platform.
  static final String envVarPathSeparator = isWindows ? ";" : ":";

  //************************************************************************//

  static final bool isWeb = false;

  // From `Platform`
  //************************************************************************//

  static final numberOfProcessors = Platform.numberOfProcessors;

  static final pathSeparator = Platform.pathSeparator;

  static final operatingSystem = Platform.operatingSystem;

  static final operatingSystemVersion = Platform.operatingSystemVersion;

  static final localHostname = Platform.localHostname;

  static final version = Platform.version;

  static String get localeName => Platform.localeName;

  static final bool isLinux = Platform.isLinux;

  static final bool isMacOS = Platform.isMacOS;

  static final bool isWindows = Platform.isWindows;

  static final bool isAndroid = Platform.isAndroid;

  static final bool isIOS = Platform.isIOS;

  static final bool isFuchsia = Platform.isFuchsia;

  static Map<String, String> get environment => Platform.environment;

  static String get executable => Platform.executable;

  static String get resolvedExecutable => Platform.resolvedExecutable;

  static Uri get script => Platform.script;

  static List<String> get executableArguments => Platform.executableArguments;

  static String? get packageConfig => Platform.packageConfig;

  static String get lineTerminator => Platform.lineTerminator;
}
