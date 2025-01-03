# KeyedMutex
***
`KeyedMutex` is used to ensure that only one task can perform a critical section of code at a time,
where the critical section of code is associated with an key. `KeyedMutex` uses a fifo model to prevent starvation.
e.g. Async IO operations -

```dart
final keyedMutex = KeyedMutex();

Future<void> deleteFileIfExists(File file) async {
  return keyedMutex.withLock(file.absolute, () async {
    if (await file.exists()) {
      await file.delete();
    }
  });
}
```
The alternative to not using `KeyedMutex` in the above code would be to use the synchronous
version of th IO api's or risk a scenario like below which would otherwise likely cause an exception.
```dart
deleteFileIfExists(File("path/to/file"));
deleteFileIfExists(File("path/to/file"));
```
