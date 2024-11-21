import 'package:rust/rust.dart';
import 'package:rust/src/path/is_windows/web.dart';

import 'io/io.dart' as io;

// This is a stub. The correct Path implementation will be imported on compilation.
/// {@template path.Path}
/// [Path] is for handling file paths in a type-safe manner.
/// This type supports a number of operations for inspecting a path, including breaking the path into its components,
/// extracting the file name, determining whether the path is absolute, and so on.
/// {@endtemplate}
/// Platform Independent.
extension type Path._(String string) implements Object {
  static String get separator => isWindows ? WindowsPath.separator : UnixPath.separator;

  /// {@template path.Path.isIoSupported}
  /// Returns whether io operations are supported. If false, is currently running on the web.
  /// {@endtemplate}
  static const bool isIoSupported = io.isIoSupported;

  const Path(this.string);

  /// {@template path.Path.ancestors}
  /// Produces an iterator over Path and its ancestors. e.g. `/a/b/c` will produce `/a/b/c`, `/a/b`, `/a`, and `/`.
  /// {@endtemplate}
  Iterable<Path> ancestors() => isWindows
      ? WindowsPath(string).ancestors().map((e) => Path(e.string))
      : UnixPath(string).ancestors().map((e) => Path(e.string));

// as_mut_os_str : will not be implemented
// as_os_str : will not be implemented

  /// {@template path.Path.canonicalize}
  /// Returns the canonical, absolute form of the path with all intermediate components normalized.
  /// {@endtemplate}
  Path canonicalize() => isWindows
      ? Path(WindowsPath(string).canonicalize().string)
      : Path(UnixPath(string).canonicalize().string);

  /// {@template path.Path.components}
  /// Produces an iterator over the Components of the path.
  /// {@endtemplate}
  Iterable<Component> components() =>
      isWindows ? WindowsPath(string).components() : UnixPath(string).components();

  /// {@template path.Path.endsWith}
  /// Determines whether other is a suffix of this.
  /// {@endtemplate}
  bool endsWith(Path other) => isWindows
      ? WindowsPath(string).endsWith(WindowsPath(other.string))
      : UnixPath(string).endsWith(UnixPath(other.string));

  /// {@template path.Path.existsSync}
  /// Determines whether file exists on disk.
  /// {@endtemplate}
  bool existsSync() => isWindows ? WindowsPath(string).existsSync() : UnixPath(string).existsSync();

  /// {@template path.Path.exists}
  /// Determines whether file exists on disk.
  /// {@endtemplate}
  Future<bool> exists() => isWindows ? WindowsPath(string).exists() : UnixPath(string).exists();

  /// {@template path.Path.extension}
  /// Extracts the extension (without the leading dot) of self.file_name, if possible.
  /// {@endtemplate}
  String extension() => isWindows ? WindowsPath(string).extension() : UnixPath(string).extension();

  /// {@template path.Path.fileName}
  /// Returns the final component of the Path, if there is one.
  /// {@endtemplate}
  String fileName() => isWindows ? WindowsPath(string).fileName() : UnixPath(string).fileName();

  /// {@template path.Path.filePrefix}
  /// Extracts the portion of the file name before the first "." -
  ///
  /// None, if there is no file name;
  /// The entire file name if there is no embedded .;
  /// The portion of the file name before the first non-beginning .;
  /// The entire file name if the file name begins with . and has no other .s within;
  /// The portion of the file name before the second . if the file name begins with .
  /// {@endtemplate}
  Option<String> filePrefix() =>
      isWindows ? WindowsPath(string).filePrefix() : UnixPath(string).filePrefix();

  /// {@template path.Path.fileStem}
  /// Extracts the portion of the file name before the last "." -
  ///
  /// None, if there is no file name;
  /// The entire file name if there is no embedded .;
  /// The entire file name if the file name begins with . and has no other .s within;
  /// Otherwise, the portion of the file name before the final .
  /// {@endtemplate}
  Option<String> fileStem() =>
      isWindows ? WindowsPath(string).fileStem() : UnixPath(string).fileStem();

  /// {@template path.Path.hasRoot}
  /// Returns true if the Path has a root.
  /// {@endtemplate}
  bool hasRoot() => isWindows ? WindowsPath(string).hasRoot() : UnixPath(string).hasRoot();

  // into_path_buf : will not be implemented

  /// {@template path.Path.isAbsolute}
  /// Returns true if the Path is absolute, i.e., if it is independent of the current directory.
  /// {@endtemplate}
  bool isAbsolute() => isWindows ? WindowsPath(string).isAbsolute() : UnixPath(string).isAbsolute();

  /// {@template path.Path.isDirSync}
  /// Returns true if the path exists on disk and is pointing at a directory. Does not follow links.
  /// {@endtemplate}
  bool isDirSync() => isWindows ? WindowsPath(string).isDirSync() : UnixPath(string).isDirSync();

  /// {@template path.Path.isDir}
  /// Returns true if the path exists on disk and is pointing at a directory. Does not follow links.
  /// {@endtemplate}
  Future<bool> isDir() => isWindows ? WindowsPath(string).isDir() : UnixPath(string).isDir();

  /// {@template path.Path.isFileSync}
  /// Returns true if the path exists on disk and is pointing at a regular file. Does not follow links.
  /// {@endtemplate}
  bool isFileSync() => isWindows ? WindowsPath(string).isFileSync() : UnixPath(string).isFileSync();

  /// {@template path.Path.isFile}
  /// Returns true if the path exists on disk and is pointing at a regular file. Does not follow links.
  /// {@endtemplate}
  Future<bool> isFile() => isWindows ? WindowsPath(string).isFile() : UnixPath(string).isFile();

  /// {@template path.Path.isRelative}
  /// Returns true if the Path is relative, i.e., not absolute.
  /// {@endtemplate}
  bool isRelative() => isWindows ? WindowsPath(string).isRelative() : UnixPath(string).isRelative();

  /// {@template path.Path.isRoot}
  /// Returns true if the path exists on disk and is pointing at a symlink. Does not follow links.
  /// {@endtemplate}
  bool isSymlinkSync() =>
      isWindows ? WindowsPath(string).isSymlinkSync() : UnixPath(string).isSymlinkSync();

  /// {@template path.Path.isSymlink}
  /// Returns true if the path exists on disk and is pointing at a symlink. Does not follow links.
  /// {@endtemplate}
  Future<bool> isSymlink() =>
      isWindows ? WindowsPath(string).isSymlink() : UnixPath(string).isSymlink();

  /// {@template path.Path.iter}
  /// Produces an iterator over the path’s components viewed as Strings
  /// {@endtemplate}
  Iter<String> iter() => isWindows ? WindowsPath(string).iter() : UnixPath(string).iter();

  /// {@template path.Path.join}
  /// Creates an Path with path adjoined to this.
  /// {@endtemplate}
  Path join(Path other) => isWindows
      ? Path(WindowsPath(string).join(WindowsPath(other.string)).string)
      : Path(UnixPath(string).join(UnixPath(other.string)).string);

  /// {@template path.Path.metadataSync}
  /// Queries the file system to get information about a file, directory, etc.
  /// Note: using this method means that the program can no longer compile for the web.
  /// {@endtemplate}
  io.Metadata metadataSync() =>
      isWindows ? WindowsPath(string).metadataSync() : UnixPath(string).metadataSync();

  /// {@template path.Path.metadata}
  /// Queries the file system to get information about a file, directory, etc.
  /// Note: using this method means that the program can no longer compile for the web.
  /// {@endtemplate}
  Future<io.Metadata> metadata() =>
      isWindows ? WindowsPath(string).metadata() : UnixPath(string).metadata();

// new : will not be implemented

  /// {@template path.Path.parent}
  /// Returns the Path without its final component, if there is one.
  /// This means it returns Some("") for relative paths with one component.
  /// Returns None if the path terminates in a root or prefix, or if it’s the empty string.
  /// {@endtemplate}
  Option<Path> parent() => isWindows
      ? WindowsPath(string).parent().map((e) => Path(e.string))
      : UnixPath(string).parent().map((e) => Path(e.string));

  /// {@template path.Path.readDirSync}
  /// Returns an iterator over the entries within a directory.
  /// Note: using this method results in the program no longer being able to compile to web.
  /// {@endtemplate}
  Result<io.ReadDir, PathIoError> readDirSync() =>
      isWindows ? WindowsPath(string).readDirSync() : UnixPath(string).readDirSync();

  /// {@template path.Path.readDir}
  /// Returns an iterator over the entries within a directory.
  /// Note: using this method results in the program no longer being able to compile to web.
  /// {@endtemplate}
  Future<Result<io.ReadDir, PathIoError>> readDir() =>
      isWindows ? WindowsPath(string).readDir() : UnixPath(string).readDir();

  /// {@template path.Path.readLinkSync}
  /// Reads a symbolic link, returning the file that the link points to.
  /// {@endtemplate}
  Result<Path, PathIoError> readLinkSync() => isWindows
      ? WindowsPath(string).readLinkSync().map((e) => Path(e.string))
      : UnixPath(string).readLinkSync().map((e) => Path(e.string));

  /// {@template path.Path.readLink}
  /// Reads a symbolic link, returning the file that the link points to.
  /// {@endtemplate}
  Future<Result<Path, PathIoError>> readLink() => isWindows
      ? WindowsPath(string).readLink().map((e) => Path(e.string))
      : UnixPath(string).readLink().map((e) => Path(e.string));

  /// {@template path.Path.relativeTo}
  /// Determines whether other is a prefix of this.
  /// {@endtemplate}
  bool startsWith(Path other) => isWindows
      ? WindowsPath(string).startsWith(WindowsPath(other.string))
      : UnixPath(string).startsWith(UnixPath(other.string));

  /// {@template path.Path.stripPrefix}
  /// Returns a path that, when joined onto base, yields this. Returns None if [prefix] is not a subpath of base.
  /// {@endtemplate}
  Option<Path> stripPrefix(Path prefix) => isWindows
      ? WindowsPath(string).stripPrefix(WindowsPath(prefix.string)).map((e) => Path(e.string))
      : UnixPath(string).stripPrefix(UnixPath(prefix.string)).map((e) => Path(e.string));

  /// {@template path.Path.symlinkMetadataSync}
  /// Returns the metadata for the symlink.
  /// Note: using this method means that the program can no longer compile for the web.
  /// {@endtemplate}
  Result<io.Metadata, PathIoError> symlinkMetadataSync() => isWindows
      ? WindowsPath(string).symlinkMetadataSync()
      : UnixPath(string).symlinkMetadataSync();

  /// {@template path.Path.symlinkMetadata}
  /// Returns the metadata for the symlink.
  /// Note: using this method means that the program can no longer compile for the web.
  /// {@endtemplate}
  Future<Result<io.Metadata, PathIoError>> symlinkMetadata() =>
      isWindows ? WindowsPath(string).symlinkMetadata() : UnixPath(string).symlinkMetadata();

// to_path_buf: Will not implement, implementing a PathBuf does not make sense at the present (equality cannot hold for extension types and a potential PathBuf would likely be `StringBuffer` or `List<String>`).
// to_str: Implemented by type
// to_string_lossy: Will not be implemented
// try_exists: Will not implement

  /// {@template path.Path.withExtension}
  /// Creates an Path like this but with the given extension.
  /// {@endtemplate}
  Path withExtension(String extension) => isWindows
      ? Path(WindowsPath(string).withExtension(extension).string)
      : Path(UnixPath(string).withExtension(extension).string);

  /// {@template path.Path.withFileName}
  /// Creates an PathBuf like this but with the given file name.
  /// {@endtemplate}
  Path withFileName(String fileName) => isWindows
      ? Path(WindowsPath(string).withFileName(fileName).string)
      : Path(UnixPath(string).withFileName(fileName).string);
}
