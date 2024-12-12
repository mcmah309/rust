part of 'vm.dart';

/// Represents an error that occurred during an IO operation.
sealed class IoError {
  /// {@macro IoError$IOException}
  factory IoError.ioException(IOException error) = IoError$IOException._;

  /// {@macro FsIoError$Unknown}
  factory IoError.unknown(Object error) = IoError$Unknown._;
}

/// {@template IoError$IOException}
/// All IO related exceptions.
/// {@endtemplate}
class IoError$IOException implements IoError {
  final IOException error;

  IoError$IOException._(this.error);

  @override
  String toString() => 'IoError\$IOException: $error';
}

/// {@template FsIoError$Unknown}
/// Represents an error that occurred during an IO operation that is not an [IOException].
/// This state may never be possible but is needed to ensure a value does not leak past the guard.
/// {@endtemplate}
class IoError$Unknown implements IoError {
  final Object error;

  IoError$Unknown._(this.error);

  @override
  String toString() => 'IoError\$Unknown: $error';
}
