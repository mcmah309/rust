part of 'mutex.dart';

/// Managed mutual exclusion based on keys.
///
/// The [withLock] method is a convenience method for acquiring a lock before
/// running critical code, and then releasing the lock afterwards, where the critical
/// section of the code is associate with an [K]. e.g. Checking for file existence
/// and deleting asynchronously, where the key is the file path. Using the [withLock]
/// convenience method will ensure the lock is always released after use.
///
/// Usage:
///
///     m = KeyedMutex();
///
///     await m.withLock(key, () async {
///       // critical section
///     });
///
/// Alternatively, a lock can be explicitly acquired and managed. In this
/// situation, the program is responsible for releasing the lock after it
/// have been used. Failure to release the lock will prevent other code for
/// ever acquiring the lock.
///
///     m = KeyedMutex();
///
///     await m.lock(key);
///     try {
///       // critical section
///     }
///     finally {
///       m.release(key);
///     }
class KeyedMutex<K> {
  final Map<K, RwLock> _rwMutexes = {};

  /// Indicates if a lock has been acquired and not released.
  bool isLocked(K key) => _rwMutexes[key]?.isLocked ?? false;

  /// Acquire a lock
  ///
  /// Returns a future that will be completed when the lock has been acquired.
  ///
  /// Consider using the convenience method [withLock], otherwise the caller
  /// is responsible for making sure the lock is released after it is no longer
  /// needed. Failure to release the lock means no other code can acquire the
  /// lock.
  Future lock(K key) {
    var lock = _rwMutexes[key];
    if (lock == null) {
      lock = RwLock();
      _rwMutexes[key] = lock;
    }
    return lock.write();
  }

  /// Release a lock.
  ///
  /// Release a lock that has been acquired.
  void release(K key) {
    final lock = _rwMutexes[key];
    if (lock == null) {
      throw StateError('`release` called for lock with key `$key`, when no lock to release.');
    }
    if (lock._waiting.isEmpty) {
      _rwMutexes.remove(key);
    } else {
      lock.release();
    }
  }

  /// Convenience method for protecting a function with a lock.
  ///
  /// This method guarantees a lock is always acquired before invoking the
  /// [criticalSection] function. It also guarantees the lock is always
  /// released. The lock acquired is unique for each different [key].
  ///
  /// A critical section should always contain asynchronous code, since purely
  /// synchronous code does not need to be protected inside a critical section.
  ///
  /// Returns a _Future_ whose value is the value of the _Future_ returned by
  /// the critical section.
  ///
  /// An exception is thrown if the critical section throws an exception,
  /// or an exception is thrown while waiting for the _Future_ returned by
  /// the critical section to complete. The lock is released, when those
  /// exceptions occur.
  Future<T> withLock<T>(K key, Future<T> Function() criticalSection) async {
    await lock(key);
    try {
      return await criticalSection();
    } finally {
      release(key);
    }
  }
}
