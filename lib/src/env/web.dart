import 'package:rust/rust.dart';

/// A cross platform version of [Platform] with additional powers related to the environment
class Env {
  static Path get currentDirectory => throw UnsupportedError(
      "'currentDirectory' is not supported on on this platform");

  static set currentDirectory(Path path) => throw UnsupportedError(
      "'setCurrentDirectory' is not supported on on this platform");

  static String joinPaths(Iterable<String> paths) => throw UnsupportedError(
      "'joinPaths' is not supported on on this platform");

  static Iterable<String> splitPaths(String paths) => throw UnsupportedError(
      "'splitPaths' is not supported on on this platform");

  static Iterable<(String key, String val)> envVars() =>
      throw UnsupportedError("'envVars' is not supported on on this platform");

  static String? envVar(String key) =>
      throw UnsupportedError("'envVar' is not supported on on this platform");

  static String get envVarPathSeparator => throw UnsupportedError(
      "'envVarPathSeparator' is not supported on on this platform");

  //************************************************************************//

  static final bool isWeb = true;

  // From `Platform`
  //************************************************************************//

  static final numberOfProcessors = throw UnsupportedError(
      "'numberOfProcessors' is not supported on on this platform");

  static final pathSeparator = throw UnsupportedError(
      "'pathSeparator' is not supported on on this platform");

  static final operatingSystem = throw UnsupportedError(
      "'operatingSystem' is not supported on on this platform");

  static final operatingSystemVersion = throw UnsupportedError(
      "'operatingSystemVersion' is not supported on on this platform");

  static final localHostname = throw UnsupportedError(
      "'localHostname' is not supported on on this platform");

  static final version =
      throw UnsupportedError("'version' is not supported on on this platform");

  static String get localeName => throw UnsupportedError(
      "'localeName' is not supported on on this platform");

  static final bool isLinux = false;

  static final bool isMacOS = false;

  static final bool isWindows = false;

  static final bool isAndroid = false;

  static final bool isIOS = false;

  static final bool isFuchsia = false;

  static Map<String, String> get environment => throw UnsupportedError(
      "'environment' is not supported on on this platform");

  static String get executable => throw UnsupportedError(
      "'executable' is not supported on on this platform");

  static String get resolvedExecutable => throw UnsupportedError(
      "'resolvedExecutable' is not supported on on this platform");

  static Uri get script =>
      throw UnsupportedError("'script' is not supported on on this platform");

  static List<String> get executableArguments => throw UnsupportedError(
      "'executableArguments' is not supported on on this platform");

  static String? get packageConfig => throw UnsupportedError(
      "'packageConfig' is not supported on on this platform");

  static String get lineTerminator => throw UnsupportedError(
      "'lineTerminator' is not supported on on this platform");
}
