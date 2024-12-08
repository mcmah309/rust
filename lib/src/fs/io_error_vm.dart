part of 'vm.dart';

/// Represents an error that occurred during an IO operation.
sealed class IoError {
  factory IoError.ioException(IOException error) = FsIoError$IOException._;
  factory IoError.unknown(Object error) = FsIoError$Unknown._;
}

class FsIoError$IOException implements IoError {
  final IOException error;

  FsIoError$IOException._(this.error);

  @override
  String toString() => 'IoError\$IOException: $error';
}

/// Represents an error that occurred during an IO operation that is not an [IOException].
/// This state may never be possible but is needed to ensure a value does not leak past the guard.
class FsIoError$Unknown implements IoError {
  final Object error;

  FsIoError$Unknown._(this.error);

  @override
  String toString() => 'IoError\$Unknown: $error';
}