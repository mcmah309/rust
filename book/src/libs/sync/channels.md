# channel

rust supports two types of channels, "local" channels (same isolate) and "isolate" channels (different isolates).

## Local Channels
***
`localChannel` is used for communication between produces and consumers on the **same** isolate. `localChannel` is
similar to `StreamController` except it buffers data until read and will never throw.
In more detail, `localChannel` returns a `Sender` and `Receiver`. Each item `T` sent by the `Sender`
will only be seen once by the `Receiver`. Even if the `Sender` calls `close` while the `Receiver`'s buffer
is not empty, the `Receiver` will still yield the remaining items in the buffer until empty.

### Examples
#### Single Sender, Single Receiver

```dart
import 'package:rust/sync.dart';

void main() async {
  final (tx, rx) = localChannel<int>();

  // Sender sends data
  tx.send(1);
  tx.send(2);
  tx.send(3);

  // Receiver retrieves data
  for (int i = 0; i < 3; i++) {
    print(await rx.recv()); // Outputs: 1, 2, 3
  }
}
```

### Receiver with Timeout

```dart
import 'package:rust/sync.dart';

void main() async {
  final (tx, rx) = localChannel<int>();

  // Sender sends data
  tx.send(1);

  // Receiver retrieves data with a timeout
  final result = await rx.recvTimeout(Duration(milliseconds: 100));
  if (result.isOk()) {
    print(result.unwrap()); // Outputs: 1
  } else {
    print("Timeout"); // If timeout occurs
  }
}
```
### Receiver with Error Handling

```dart
import 'package:rust/sync.dart';

void main() async {
  final (tx, rx) = localChannel<int>();

  // Sender sends data and then an error
  tx.send(1);
  tx.send(2);
  tx.sendError(Exception("Test error"));

  // Receiver retrieves data and handles errors
  for (int i = 0; i < 3; i++) {
    final result = await rx.recv();
    if (result.isOk()) {
      print(result.unwrap()); // Outputs: 1, 2
    } else {
      print("Error: ${result.unwrapErr()}"); // Handles error
    }
  }
}
```
### Iterating Over Received Data

```dart
import 'package:rust/sync.dart';

void main() async {
  final (tx, rx) = localChannel<int>();

  // Sender sends data
  tx.send(1);
  tx.send(2);
  tx.send(3);

  // Receiver iterates over the data
  final iterator = rx.iter();
  for (final value in iterator) {
    print(value); // Outputs: 1, 2, 3
  }
}
```
### Using Receiver as a Stream

```dart
import 'package:rust/sync.dart';

void main() async {
  final (tx, rx) = localChannel<int>();

  // Sender sends data
  tx.send(1);
  tx.send(2);
  tx.send(3);

  // Close the sender after some delay
  () async {
    await Future.delayed(Duration(seconds: 1));
    tx.close();
  }();

  // Receiver processes the stream of data
  await for (final value in rx.stream()) {
    print(value); // Outputs: 1, 2, 3
  }
}
```

## Isolate Channels
***
`isolateChannel` is used for bi-directional isolate communication. The returned
`Sender` and `Receiver` can communicate with the spawned isolate and 
the spawned isolate is passed a `Sender` and `Receiver` to communicate with the original isolate.
Each item `T` sent by the `Sender` will only be seen once by the `Receiver`. Even if the `Sender` calls `close` while the `Receiver`'s buffer
is not empty, the `Receiver` will still yield the remaining items in the buffer until empty.
Types that can be sent over a `SendPort`, as defined [here](https://api.flutter.dev/flutter/dart-isolate/SendPort/send.html),
are allow to be sent between isolates. Otherwise a `toIsolateCodec` and/or a `fromIsolateCodec` can be passed
to encode and decode the messages.
> Note: Dart does not support isolates on web. Therefore, if your compilation target is web, you cannot use `isolateChannel`.

### Examples

#### Simple String Communication

```dart
void main() async {
  final (tx, rx) = await isolateChannel<String, String>((tx, rx) async {
    assert((await rx.recv()).unwrap() == "hello");
    tx.send("hi");
  });

  tx.send("hello");
  expect((await rx.recv()).unwrap(), "hi");
}
```
#### Different Codecs for Communication

```dart
void main() async {
  final (tx, rx) = await isolateChannel<String, int>((tx, rx) async {
    assert((await rx.recv()).unwrap() == "hello");
    tx.send(1);
  }, toIsolateCodec: const StringCodec(), fromIsolateCodec: const IntCodec());

  tx.send("hello");
  expect((await rx.recv()).unwrap(), 1);
}
```