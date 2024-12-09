part of 'path.dart';

/// A platform dependent [Path] type. Thus, will use windows paths on windows and unix paths on all other platforms.
/// {@template path.Path}
/// [Path] is for handling file paths in a type-safe manner.
/// This type supports a number of operations for inspecting a path, including breaking the path into its components,
/// extracting the file name, determining whether the path is absolute, and so on.
/// {@endtemplate}
extension type Path._(String _string) implements Object {
  static String get separator =>
      Env.isWindows ? WindowsPath.separator : UnixPath.separator;

  const Path(this._string);

  @pragma("vm:prefer-inline")
  String asString() => _string;

  /// {@template path.Path.ancestors}
  /// Produces an iterator over Path and its ancestors. e.g. with UnixPath, `/a/b/c` will produce `/a/b/c`, `/a/b`, `/a`, and `/`.
  /// {@endtemplate}
  Iterable<Path> ancestors() => Env.isWindows
      ? WindowsPath(_string).ancestors().map((e) => Path(e._string))
      : UnixPath(_string).ancestors().map((e) => Path(e._string));

// as_mut_os_str : will not be implemented
// as_os_str : will not be implemented

  /// {@template path.Path.canonicalize}
  /// Returns the canonical, absolute form of the path with all intermediate components normalized.
  /// {@endtemplate}
  Path canonicalize() => Env.isWindows
      ? Path(WindowsPath(_string).canonicalize()._string)
      : Path(UnixPath(_string).canonicalize()._string);

  /// {@template path.Path.components}
  /// Produces an iterator over the Components of the path.
  /// {@endtemplate}
  Iterable<Component> components() => Env.isWindows
      ? WindowsPath(_string).components()
      : UnixPath(_string).components();

  /// {@template path.Path.endsWith}
  /// Determines whether other is a suffix of this.
  /// {@endtemplate}
  bool endsWith(Path other) => Env.isWindows
      ? WindowsPath(_string).endsWith(WindowsPath(other._string))
      : UnixPath(_string).endsWith(UnixPath(other._string));

  /// {@template path.Path.existsSync}
  /// Determines whether file exists on disk.
  /// {@endtemplate}
  bool existsSync() => Env.isWindows
      ? WindowsPath(_string).existsSync()
      : UnixPath(_string).existsSync();

  /// {@template path.Path.exists}
  /// Determines whether file exists on disk.
  /// {@endtemplate}
  Future<bool> exists() =>
      Env.isWindows ? WindowsPath(_string).exists() : UnixPath(_string).exists();

  /// {@template path.Path.extension}
  /// Extracts the extension (without the leading dot) of self.file_name, if possible.
  /// {@endtemplate}
  String extension() => Env.isWindows
      ? WindowsPath(_string).extension()
      : UnixPath(_string).extension();

  /// {@template path.Path.fileName}
  /// Returns the final component of the Path, if there is one.
  /// {@endtemplate}
  String fileName() => Env.isWindows
      ? WindowsPath(_string).fileName()
      : UnixPath(_string).fileName();

  /// {@template path.Path.filePrefix}
  /// Extracts the portion of the file name before the first "." -
  ///
  /// None/null, if there is no file name;
  /// The entire file name if there is no embedded .;
  /// The portion of the file name before the first non-beginning .;
  /// The entire file name if the file name begins with . and has no other .s within;
  /// The portion of the file name before the second . if the file name begins with .
  /// {@endtemplate}
  String? filePrefix() => Env.isWindows
      ? WindowsPath(_string).filePrefix()
      : UnixPath(_string).filePrefix();

  /// {@macro path.Path.filePrefix}
  Option<String> filePrefixOpt() => Env.isWindows
      ? WindowsPath(_string).filePrefixOpt()
      : UnixPath(_string).filePrefixOpt();

  /// {@template path.Path.fileStem}
  /// Extracts the portion of the file name before the last "." -
  ///
  /// None/null, if there is no file name;
  /// The entire file name if there is no embedded .;
  /// The entire file name if the file name begins with . and has no other .s within;
  /// Otherwise, the portion of the file name before the final .
  /// {@endtemplate}
  String? fileStem() => Env.isWindows
      ? WindowsPath(_string).fileStem()
      : UnixPath(_string).fileStem();

  /// {@macro path.Path.fileStem}
  Option<String> fileStemOpt() => Env.isWindows
      ? WindowsPath(_string).fileStemOpt()
      : UnixPath(_string).fileStemOpt();

  /// {@template path.Path.hasRoot}
  /// Returns true if the Path has a root.
  /// {@endtemplate}
  bool hasRoot() =>
      Env.isWindows ? WindowsPath(_string).hasRoot() : UnixPath(_string).hasRoot();

  // into_path_buf : will not be implemented

  /// {@template path.Path.isAbsolute}
  /// Returns true if the Path is absolute, i.e., if it is independent of the current directory.
  /// {@endtemplate}
  bool isAbsolute() => Env.isWindows
      ? WindowsPath(_string).isAbsolute()
      : UnixPath(_string).isAbsolute();

  /// {@template path.Path.isDirSync}
  /// Returns true if the path exists on disk and is pointing at a directory. Does not follow links.
  /// {@endtemplate}
  bool isDirSync() => Env.isWindows
      ? WindowsPath(_string).isDirSync()
      : UnixPath(_string).isDirSync();

  /// {@template path.Path.isDir}
  /// Returns true if the path exists on disk and is pointing at a directory. Does not follow links.
  /// {@endtemplate}
  Future<bool> isDir() =>
      Env.isWindows ? WindowsPath(_string).isDir() : UnixPath(_string).isDir();

  /// {@template path.Path.isFileSync}
  /// Returns true if the path exists on disk and is pointing at a regular file. Does not follow links.
  /// {@endtemplate}
  bool isFileSync() => Env.isWindows
      ? WindowsPath(_string).isFileSync()
      : UnixPath(_string).isFileSync();

  /// {@template path.Path.isFile}
  /// Returns true if the path exists on disk and is pointing at a regular file. Does not follow links.
  /// {@endtemplate}
  Future<bool> isFile() =>
      Env.isWindows ? WindowsPath(_string).isFile() : UnixPath(_string).isFile();

  /// {@template path.Path.isRelative}
  /// Returns true if the Path is relative, i.e., not absolute.
  /// {@endtemplate}
  bool isRelative() => Env.isWindows
      ? WindowsPath(_string).isRelative()
      : UnixPath(_string).isRelative();

  /// {@template path.Path.isRoot}
  /// Returns true if the path exists on disk and is pointing at a symlink. Does not follow links.
  /// {@endtemplate}
  bool isSymlinkSync() => Env.isWindows
      ? WindowsPath(_string).isSymlinkSync()
      : UnixPath(_string).isSymlinkSync();

  /// {@template path.Path.isSymlink}
  /// Returns true if the path exists on disk and is pointing at a symlink. Does not follow links.
  /// {@endtemplate}
  Future<bool> isSymlink() => Env.isWindows
      ? WindowsPath(_string).isSymlink()
      : UnixPath(_string).isSymlink();

  /// {@template path.Path.iter}
  /// Produces an iterator over the path’s components viewed as Strings
  /// {@endtemplate}
  Iter<String> iter() =>
      Env.isWindows ? WindowsPath(_string).iter() : UnixPath(_string).iter();

  /// {@template path.Path.join}
  /// Creates an Path with path adjoined to this.
  /// {@endtemplate}
  Path join(Path other) => Env.isWindows
      ? Path(WindowsPath(_string).join(WindowsPath(other._string))._string)
      : Path(UnixPath(_string).join(UnixPath(other._string))._string);

  /// {@template path.Path.metadataSync}
  /// Queries the file system to get information about a file, directory, etc.
  /// Note: using this method means that the program can no longer compile for the web.
  /// {@endtemplate}
  Result<Metadata, IoError>  metadataSync() => Env.isWindows
      ? WindowsPath(_string).metadataSync()
      : UnixPath(_string).metadataSync();

  /// {@template path.Path.metadata}
  /// Queries the file system to get information about a file, directory, etc.
  /// Note: using this method means that the program can no longer compile for the web.
  /// {@endtemplate}
  FutureResult<Metadata, IoError>  metadata() => Env.isWindows
      ? WindowsPath(_string).metadata()
      : UnixPath(_string).metadata();

// new : will not be implemented

  /// {@template path.Path.parent}
  /// Returns the Path without its final component, if there is one.
  /// This means it returns Some("")/"" for relative paths with one component.
  /// Returns None/null if the path terminates in a root or prefix, or if it’s the empty string.
  /// {@endtemplate}
  Path? parent() => Env.isWindows
      ? WindowsPath(_string).parent()?._string.asPath()
      : UnixPath(_string).parent()?._string.asPath();

  /// {@macro path.Path.parent}
  Option<Path> parentOpt() => Env.isWindows
      ? WindowsPath(_string).parentOpt().map((e) => Path(e._string))
      : UnixPath(_string).parentOpt().map((e) => Path(e._string));

  /// {@template path.Path.readDirSync}
  /// Returns an iterator over the entries within a directory.
  /// Note: using this method results in the program no longer being able to compile to web.
  /// {@endtemplate}
  Result<ReadDir, IoError> readDirSync() => Env.isWindows
      ? WindowsPath(_string).readDirSync()
      : UnixPath(_string).readDirSync();

  /// {@template path.Path.readDir}
  /// Returns an iterator over the entries within a directory.
  /// Note: using this method results in the program no longer being able to compile to web.
  /// {@endtemplate}
  Future<Result<ReadDir, IoError>> readDir() =>
      Env.isWindows ? WindowsPath(_string).readDir() : UnixPath(_string).readDir();

  /// {@template path.Path.readLinkSync}
  /// Reads a symbolic link, returning the file that the link points to.
  /// {@endtemplate}
  Result<Path, IoError> readLinkSync() => Env.isWindows
      ? WindowsPath(_string).readLinkSync().map((e) => Path(e._string))
      : UnixPath(_string).readLinkSync().map((e) => Path(e._string));

  /// {@template path.Path.readLink}
  /// Reads a symbolic link, returning the file that the link points to.
  /// {@endtemplate}
  Future<Result<Path, IoError>> readLink() => Env.isWindows
      ? WindowsPath(_string).readLink().map((e) => Path(e._string))
      : UnixPath(_string).readLink().map((e) => Path(e._string));

  /// {@template path.Path.relativeTo}
  /// Determines whether other is a prefix of this.
  /// {@endtemplate}
  bool startsWith(Path other) => Env.isWindows
      ? WindowsPath(_string).startsWith(WindowsPath(other._string))
      : UnixPath(_string).startsWith(UnixPath(other._string));

  /// {@template path.Path.stripPrefix}
  /// Returns a path that, when joined onto base, yields this. Returns None/null if [prefix] is not a subpath of base.
  /// {@endtemplate}
  Path? stripPrefix(Path prefix) => Env.isWindows
      ? WindowsPath(_string)
          .stripPrefix(WindowsPath(prefix._string))?._string.asPath()
      : UnixPath(_string)
          .stripPrefix(UnixPath(prefix._string))?._string.asPath();

  /// {@macro path.Path.stripPrefix}
  Option<Path> stripPrefixOpt(Path prefix) => Env.isWindows
      ? WindowsPath(_string)
          .stripPrefixOpt(WindowsPath(prefix._string))
          .map((e) => Path(e._string))
      : UnixPath(_string)
          .stripPrefixOpt(UnixPath(prefix._string))
          .map((e) => Path(e._string));

  /// {@template path.Path.symlinkMetadataSync}
  /// Returns the metadata for the symlink.
  /// Note: using this method means that the program can no longer compile for the web.
  /// {@endtemplate}
  Result<Metadata, IoError> symlinkMetadataSync() => Env.isWindows
      ? WindowsPath(_string).symlinkMetadataSync()
      : UnixPath(_string).symlinkMetadataSync();

  /// {@template path.Path.symlinkMetadata}
  /// Returns the metadata for the symlink.
  /// Note: using this method means that the program can no longer compile for the web.
  /// {@endtemplate}
  Future<Result<Metadata, IoError>> symlinkMetadata() => Env.isWindows
      ? WindowsPath(_string).symlinkMetadata()
      : UnixPath(_string).symlinkMetadata();

// to_path_buf: Will not implement, implementing a PathBuf does not make sense at the present (equality cannot hold for extension types and a potential PathBuf would likely be `StringBuffer` or `List<String>`).
// to_str: Implemented by type
// to_string_lossy: Will not be implemented
// try_exists: Will not implement

  /// {@template path.Path.withExtension}
  /// Creates an Path like this but with the given extension.
  /// {@endtemplate}
  Path withExtension(String extension) => Env.isWindows
      ? Path(WindowsPath(_string).withExtension(extension)._string)
      : Path(UnixPath(_string).withExtension(extension)._string);

  /// {@template path.Path.withFileName}
  /// Creates an PathBuf like this but with the given file name.
  /// {@endtemplate}
  Path withFileName(String fileName) => Env.isWindows
      ? Path(WindowsPath(_string).withFileName(fileName)._string)
      : Path(UnixPath(_string).withFileName(fileName)._string);
}
