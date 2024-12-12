# Fs

Fs introduces `Fs`, a container of static methods for working with the file system in a safe manner.
`Fs` combines many of the functionalities in `File`/`Directory`/`Link`/`FileStat`/`FileSystemEntity`
into one location and will never throw an exception. Instead of using instances of the previous
entities, `Fs` works only on paths.

```dart
Result<(), IoError> = await Fs.createDir("path/to/dir".asPath());
// handle
```
rather than
```dart
try {
    await Directory("path/to/dir").create();
}
catch (e) {
// handle
}
// handle
```