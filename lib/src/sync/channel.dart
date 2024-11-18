import 'dart:async';

import 'package:rust/iter.dart';
import 'package:rust/result.dart';

/// Creates a new channel, returning the [Sender] and [LocalClosableReceiver]. Each item [T] sent by the [Sender]
/// will only be seen once by the [LocalClosableReceiver]. Even if the [Sender] calls [close] while the [LocalClosableReceiver]s buffer
/// is not empty, the [LocalClosableReceiver] will still yield the remaining items in the buffer until empty.
(LocalSender<T>, LocalReceiver<T>) channel<T>() {
  // broadcast so no buffer
  StreamController<T> controller = StreamController<T>.broadcast();
  final sender = LocalSender._(controller.sink);
  final receiver = LocalReceiver._(controller.stream, () => sender.close());
  sender._receiver = receiver;
  return (sender, receiver);
}

/// The sending-half of [channel].
abstract class Sender<T> {
  void send(T data);
}

/// The receiving-half of [channel]. [Receiver]s do not close if the [Sender] sends an error.
abstract class Receiver<T> {
  bool get isClosed;
  bool get isBufferEmpty;

  /// Attempts to wait for a value on this receiver, returning [Err] of:
  ///
  /// [DisconnectedError] if the [Sender] called [close] and the buffer is empty.
  ///
  /// [OtherError] if the item in the buffer is an error, indicated by the sender calling [addError].
  Future<Result<T, RecvError>> recv();

  /// Attempts to wait for a value on this receiver with a time limit, returning [Err] of:
  ///
  /// [DisconnectedError] if the [Sender] called [close] and the buffer is empty.
  ///
  /// [OtherError] if the item in the buffer is an error, indicated by the sender calling [addError].
  ///
  /// [TimeoutError] if the time limit is reached before the [Sender] sent any more data.
  Future<Result<T, RecvTimeoutError>> recvTimeout(Duration timeLimit);

  /// Returns an [Iter] that drains the current buffer.
  Iter<T> iter();

  /// Returns a [Stream] of values ending once [DisconnectedError] is yielded.
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
// ignore: deprecated_member_use_from_same_package
class LocalReceiver<T> extends ReceiverImpl<T> {
  LocalReceiver._(Stream<T> stream, Future Function() close)
      // ignore: deprecated_member_use_from_same_package
      : super.internal(stream, close);

  /// Stops any more messages from being sent.
  Future close() => _onDone.call();
}

@Deprecated("Internal. Do not use, this exposed for compatibility with web.")
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

  @Deprecated("Internal. Do not use, this exposed for compatibility with web.")
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
      return Err(OtherError(error));
    }
  }

  @override
  Future<Result<T, RecvTimeoutError>> recvTimeout(Duration timeLimit) async {
    try {
      return await _next()
          .timeout(timeLimit)
          .mapErr((error) => error as RecvTimeoutError);
    } on TimeoutException catch (timeoutException) {
      return Err(TimeoutError(timeoutException));
    } catch (error) {
      return Err(OtherError(error));
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
            case DisconnectedError():
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
        return _buffer.removeAt(0).mapErr((error) => OtherError(error));
      }
      if (_isClosed) {
        return const Err(DisconnectedError());
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

/// An error returned from the [recvTimeout] function on a [LocalClosableReceiver].
sealed class RecvTimeoutError {
  const RecvTimeoutError();
}

/// An error returned from the [recvTimeout] function on a [LocalClosableReceiver] when the time limit is reached before the [Sender] sends any data.
class TimeoutError implements RecvTimeoutError {
  final TimeoutException timeoutException;

  const TimeoutError(this.timeoutException);

  @override
  String toString() {
    return 'TimeoutError: $timeoutException';
  }

  @override
  bool operator ==(Object other) {
    return other is TimeoutError;
  }

  @override
  int get hashCode {
    return 0;
  }
}

/// An error returned from the [recv] function on a [LocalClosableReceiver] when the [Sender] called [close].
class DisconnectedError implements RecvTimeoutError, RecvError {
  const DisconnectedError();

  @override
  String toString() {
    return 'DisconnectedError';
  }

  @override
  bool operator ==(Object other) {
    return other is DisconnectedError;
  }

  @override
  int get hashCode {
    return 0;
  }
}

/// An error returned from the [recv] function on a [LocalClosableReceiver] when the [Sender] called [sendError].
class OtherError implements RecvTimeoutError, RecvError {
  final Object error;

  const OtherError(this.error);

  @override
  String toString() {
    return 'OtherError: $error';
  }

  @override
  bool operator ==(Object other) {
    return other is OtherError;
  }

  @override
  int get hashCode {
    return 0;
  }
}
