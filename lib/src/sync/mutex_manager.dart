part of 'mutex.dart';

/// Managed mutual exclusion based on id.
///
/// The [withLock] method is a convenience method for acquiring a lock before
/// running critical code, and then releasing the lock afterwards, where the critical
/// section of the code is associate with an [Id]. e.g. Checking for file existence
/// and deleting asynchronously, where the id is the file path. Using the [withLock]
/// convenience method will ensure the lock is always released after use.
///
/// Usage:
///
///     m = MutexManager();
///
///     await m.withLock(id, () async {
///       // critical section
///     });
///
/// Alternatively, a lock can be explicitly acquired and managed. In this
/// situation, the program is responsible for releasing the lock after it
/// have been used. Failure to release the lock will prevent other code for
/// ever acquiring the lock.
///
///     m = MutexManager();
///
///     await m.lock(id);
///     try {
///       // critical section
///     }
///     finally {
///       m.release(id);
///     }
class MutexManager<Id> {
  final Map<Id, RwLock> _rwMutexes = {};

  /// Indicates if a lock has been acquired and not released.
  bool isLocked(Id id) => _rwMutexes[id]?.isLocked ?? false;

  /// Acquire a lock
  ///
  /// Returns a future that will be completed when the lock has been acquired.
  ///
  /// Consider using the convenience method [withLock], otherwise the caller
  /// is responsible for making sure the lock is released after it is no longer
  /// needed. Failure to release the lock means no other code can acquire the
  /// lock.
  Future lock(Id id) {
    var lock = _rwMutexes[id];
    if (lock == null) {
      lock = RwLock();
      _rwMutexes[id] = lock;
    }
    return lock.write();
  }

  /// Release a lock.
  ///
  /// Release a lock that has been acquired.
  void release(Id id) {
    final lock = _rwMutexes[id];
    if (lock == null) {
      throw StateError('`release` called for lock with `$id`, when no lock to release.');
    }
    if (lock._waiting.isEmpty) {
      _rwMutexes.remove(id);
    } else {
      lock.release();
    }
  }

  /// Convenience method for protecting a function with a lock.
  ///
  /// This method guarantees a lock is always acquired before invoking the
  /// [criticalSection] function. It also guarantees the lock is always
  /// released. The lock acquired is unique for each different [id].
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
  Future<T> withLock<T>(Id id, Future<T> Function() criticalSection) async {
    await lock(id);
    try {
      return await criticalSection();
    } finally {
      release(id);
    }
  }
}
