# Fs

Fs introduces [Fs](https://pub.dev/documentation/rust/latest/rust/Fs-class.html) and 
[OpenOptions](https://pub.dev/documentation/rust/latest/rust/OpenOptions-class.html).
`Fs` is a container of static methods for working with the file system in a safe manner.
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
`OpenOptions` is a more extensive builder pattern for opening files in place of `File(..).open(mode)`
```dart
OpenOptions options = OpenOptions()
    ..append(true)
    ..create(true)
    ..createNew(true)
    ..read(true)
    ..truncate(true)
    ..write(true)
RandomAccessFile randomAccessFile = options.openSync("path/to/file".asPath()).unwrap();
```