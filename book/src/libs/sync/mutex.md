# Mutex
***
`Mutex` is used to ensure that only one task can perform a critical section of code at a time.
Dart being single threaded, means it is less common to need a `Mutex`, but they are still useful
e.g. Async IO operations. `Mutex` uses a fifo model to prevent starvation.

```dart
final mutex = Mutex();

Future<void> deleteFileIfExists(File file) async {
  return mutex.withLock(() async {
    if (await file.exists()) {
      await file.delete();
    }
  });
}
```

