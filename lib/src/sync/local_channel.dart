import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rust/rust.dart';

/// Creates a new channel, returning the [Sender] and [LocalClosableReceiver]. Each item [T] sent by the [Sender]
/// will only be seen once by the [LocalClosableReceiver]. Even if the [Sender] calls [close] while the [LocalClosableReceiver]s buffer
/// is not empty, the [LocalClosableReceiver] will still yield the remaining items in the buffer until empty.
(LocalSender<T>, LocalReceiver<T>) localChannel<T>() {
  // broadcast so no buffer
  StreamController<T> controller = StreamController<T>.broadcast();
  final sender = LocalSender._(controller.sink);
  final receiver = LocalReceiver._(controller.stream, () => sender.close());
  sender._receiver = receiver;
  return (sender, receiver);
}

/// The sending-half of [localChannel].
abstract class Sender<T> {
  void send(T data);
}

/// The receiving-half of [localChannel]. [Receiver]s do not close if the [Sender] sends an error.
abstract class Receiver<T> {
  bool get isClosed;
  bool get isBufferEmpty;

  /// Attempts to wait for a value on this receiver, returning [Err] of:
  ///
  /// [RecvError$Disconnected] if the [Sender] called [close] and the buffer is empty.
  ///
  /// [RecvError$Other] if the item in the buffer is an error, indicated by the sender calling [addError].
  Future<Result<T, RecvError>> recv();

  /// Attempts to wait for a value on this receiver with a time limit, returning [Err] of:
  ///
  /// [RecvError$Disconnected] if the [Sender] called [close] and the buffer is empty.
  ///
  /// [RecvError$Other] if the item in the buffer is an error, indicated by the sender calling [addError].
  ///
  /// [RecvError$Timeout] if the time limit is reached before the [Sender] sent any more data.
  Future<Result<T, RecvError>> recvTimeout(Duration timeLimit);

  /// Returns an [Iter] that drains the current buffer.
  Iter<T> iter();

  /// Returns a [Stream] of values ending once [RecvError$Disconnected] is yielded.
  Stream<T> stream();
}

//************************************************************************//

/// [Sender] for a single isolate.
class LocalSender<T> implements Sender<T> {
  final StreamSink<T> _sink;
  late final LocalReceiver<T> _receiver;

  LocalSender._(this._sink);

  @override
  Result<(), SendError> send(T data) {
    if (_receiver.isClosed) {
      return const Err(SendError());
    }
    _sink.add(data);
    return const Ok(());
  }

  Result<(), SendError> sendError(Object error) {
    if (_receiver.isClosed) {
      return const Err(SendError());
    }
    _sink.addError(error);
    return const Ok(());
  }

  /// Stops any more messages from being sent and releases any waiting [LocalClosableReceiver].
  Future close() => _sink.close();
}

/// [Receiver] for a single isolate.
class LocalReceiver<T> extends ReceiverImpl<T> {
  LocalReceiver._(Stream<T> stream, Future Function() close)
      : super.internal(stream, close);

  /// Stops any more messages from being sent.
  Future close() => _onDone.call();
}

@internal // Exposed for compatibility with web.
class ReceiverImpl<T> implements Receiver<T> {
  late final StreamSubscription<T> _streamSubscription;
  final Future Function() _onDone;
  final List<Result<T, Object>> _buffer = [];
  bool _isClosed = false;
  Completer _waker = Completer();

  @override
  bool get isClosed => _isClosed;

  @override
  bool get isBufferEmpty => _buffer.isEmpty;

  @internal // Exposed for compatibility with web.
  ReceiverImpl.internal(Stream<T> stream, this._onDone) {
    _streamSubscription = stream.listen((data) {
      assert(!_isClosed);
      _buffer.add(Ok(data));
      if (!_waker.isCompleted) {
        _waker.complete();
      }
    }, onError: (Object object, StackTrace stackTrace) {
      assert(!_isClosed);
      _buffer.add(Err(object));
      if (!_waker.isCompleted) {
        _waker.complete();
      }
    }, onDone: () {
      assert(!_isClosed);
      _isClosed = true;
      _onDone.call();
      _streamSubscription.cancel();
      if (!_waker.isCompleted) {
        _waker.complete();
      }
    }, cancelOnError: false);
  }

  @override
  Future<Result<T, RecvError>> recv() async {
    try {
      return await _next();
    } catch (error) {
      return Err(RecvError$Other(error));
    }
  }

  @override
  Future<Result<T, RecvError>> recvTimeout(Duration timeLimit) async {
    try {
      return await _next()
          .timeout(timeLimit);
    } on TimeoutException catch (timeoutException) {
      return Err(RecvError$Timeout(timeoutException));
    } catch (error) {
      return Err(RecvError$Other(error));
    }
  }

  @override
  Iter<T> iter() {
    return Iter.fromIterable(_iter());
  }

  Iterable<T> _iter() sync* {
    while (_buffer.isNotEmpty) {
      final item = _buffer.removeAt(0);
      switch (item) {
        case Ok(:final ok):
          yield ok;
        case Err():
      }
    }
  }

  @override
  Stream<T> stream() async* {
    while (true) {
      final rec = await recv();
      switch (rec) {
        case Ok(:final ok):
          yield ok;
        case Err(:final err):
          switch (err) {
            case RecvError$Disconnected():
              return;
            default:
          }
      }
    }
  }

  Future<Result<T, RecvError>> _next() async {
    while (true) {
      await _waker.future;
      if (_buffer.isNotEmpty) {
        return _buffer.removeAt(0).mapErr((error) => RecvError$Other(error));
      }
      if (_isClosed) {
        return const Err(RecvError$Disconnected());
      }
      _waker = Completer();
    }
  }
}

//************************************************************************//

/// A [SendError] can only happen if the channel is disconnected,
/// implying that the data could never be received.
class SendError {
  const SendError();

  @override
  String toString() => "SendError";

  @override
  bool operator ==(Object other) => other is SendError;

  @override
  int get hashCode => 0;
}

/// An error returned from the [recv] function on a [LocalClosableReceiver].
sealed class RecvError {
  const RecvError();
}

/// An error returned from the [recvTimeout] function on a [LocalClosableReceiver] when the time limit is reached before the [Sender] sends any data.
class RecvError$Timeout implements RecvError {
  final TimeoutException timeoutException;

  const RecvError$Timeout(this.timeoutException);

  @override
  String toString() {
    return 'RecvError\$Timeout: $timeoutException';
  }

  @override
  bool operator ==(Object other) {
    return other is RecvError$Timeout;
  }

  @override
  int get hashCode {
    return 0;
  }
}

/// An error returned from the [recv] function on a [LocalClosableReceiver] when the [Sender] called [close].
class RecvError$Disconnected implements RecvError {
  const RecvError$Disconnected();

  @override
  String toString() {
    return 'RecvError\$Disconnected';
  }

  @override
  bool operator ==(Object other) {
    return other is RecvError$Disconnected;
  }

  @override
  int get hashCode {
    return 0;
  }
}

/// An error returned from the [recv] function on a [LocalClosableReceiver] when the [Sender] called [sendError].
class RecvError$Other implements RecvError {
  final Object error;

  const RecvError$Other(this.error);

  @override
  String toString() {
    return 'RecvError\$Other: $error';
  }

  @override
  bool operator ==(Object other) {
    return other is RecvError$Other;
  }

  @override
  int get hashCode {
    return 0;
  }
}
