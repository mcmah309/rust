part of 'option.dart';

/// {@macro futureOption}
typedef FutureOption<T> = Future<Option<T>>;

/// {@template futureOption}
/// [FutureOption] represents an asynchronous [Option]. And as such, inherits all of [Option]'s methods.
/// {@endtemplate}
extension Option$FutureOptionExtension<T> on FutureOption<T> {
  @pragma("vm:prefer-inline")
  Future<Option<U>> and<U>(Option<U> other) {
    return then((option) => option.and(other));
  }

  @pragma("vm:prefer-inline")
  Future<Option<U>> andThen<U>(FutureOr<Option<U>> Function(T) f) {
    return then((option) => switch (option) {
          Some(:final v) => f(v),
          _ => Future.value(None),
        });
  }

  @pragma("vm:prefer-inline")
  Future<T> expect(String msg) {
    return then((option) => option.expect(msg));
  }

  @pragma("vm:prefer-inline")
  Future<Option<T>> filter(FutureOr<bool> Function(T) predicate) {
    return then((option) async {
      switch (option) {
        case Some(:final v):
          return (await predicate(v)) ? option : None;
        default:
          return None;
      }
    });
  }

  @pragma("vm:prefer-inline")
  Future<Option<T>> inspect(FutureOr<void> Function(T) f) {
    return then((option) => option.inspect(f));
  }

  @pragma("vm:prefer-inline")
  Future<bool> isNone() {
    return then((option) => option.isNone());
  }

  @pragma("vm:prefer-inline")
  Future<bool> isSome() {
    return then((option) => option.isSome());
  }

  @pragma("vm:prefer-inline")
  Future<bool> isSomeAnd(FutureOr<bool> Function(T) f) {
    return then((option) => switch (option) {
          Some(:final v) => f(v),
          _ => false,
        });
  }

  @pragma("vm:prefer-inline")
  Future<Iter<T>> iter() {
    return then((option) => option.iter());
  }

  @pragma("vm:prefer-inline")
  Future<Option<U>> map<U>(U Function(T) f) {
    return then((option) => option.map(f));
  }

  @pragma("vm:prefer-inline")
  Future<U> mapOr<U>(U defaultValue, U Function(T) f) {
    return then((option) => switch (option) {
          Some(:final v) => f(v),
          _ => defaultValue,
        });
    // return then((option) => option.isSome() ? f(option) : defaultValue);
  }

  @pragma("vm:prefer-inline")
  Future<U> mapOrElse<U>(U Function() defaultFn, U Function(T) f) {
    return then((option) => switch (option) {
          Some(:final v) => f(v),
          _ => defaultFn(),
        });
  }

  @pragma("vm:prefer-inline")
  Future<Result<T, E>> okOr<E extends Object>(E err) {
    return then((option) => option.okOr(err));
  }

  @pragma("vm:prefer-inline")
  Future<Result<T, E>> okOrElse<E extends Object>(E Function() errFn) {
    return then((option) => option.okOrElse(errFn));
  }

  @pragma("vm:prefer-inline")
  Future<Option<T>> or(Option<T> other) {
    return then((option) => option.isNone() ? other : option);
  }

  @pragma("vm:prefer-inline")
  Future<Option<T>> orElse(Option<T> Function() f) {
    return then((option) => option.isNone() ? f() : option);
  }

  @pragma("vm:prefer-inline")
  Future<T> unwrap() {
    return then((option) => option.unwrap());
  }

  @pragma("vm:prefer-inline")
  Future<T> unwrapOr(T defaultValue) {
    return then((option) => option.unwrapOr(defaultValue));
  }

  @pragma("vm:prefer-inline")
  Future<T> unwrapOrElse(T Function() f) {
    return then((option) => option.unwrapOrElse(f));
  }

  @pragma("vm:prefer-inline")
  Future<Option<T>> xor(Option<T> other) {
    return then((option) => option.xor(other));
  }

  @pragma("vm:prefer-inline")
  Future<Option<(T, U)>> zip<U>(Option<U> other) {
    return then((option) => option.zip(other));
  }

  @pragma("vm:prefer-inline")
  Future<Option<R>> zipWith<U, R>(Option<U> other, R Function(T, U) f) {
    return then((option) => option.zipWith(other, f));
  }

  //************************************************************************//

  @pragma("vm:prefer-inline")
  Future<T?> toNullable() {
    return then((option) => option.toNullable());
  }

  @pragma("vm:prefer-inline")
  // ignore: library_private_types_in_public_api
  Future<T> operator [](_OptionEarlyReturnKey op) {
    return then((value) => value[op]);
  }
}
