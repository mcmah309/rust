part of 'option.dart';

extension Option$FutureNullableExtension<T> on Future<T?> {
  /// Converts a Future<T?> to Future<Option<T>>.
  Future<Option<T>> toFutureOption() {
    return then((e) => Option.of(e));
  }
}

extension Option$ToFutureOptionExtension<T> on Option<T> {
  /// Converts a Option<T> to Future<Option<T>>.
  Future<Option<T>> toFutureOption() async {
    return this;
  }
}

extension Option$FutureOptionOptionExtension<T> on FutureOption<Option<T>> {
  /// Converts from FutureOption<Option<T>> to FutureOption<T>.
  Future<Option<T>> flatten() {
    return then((option) => option.flatten());
  }
}

extension Option$FutureOptionRecord2Extension<T, U> on FutureOption<(T, U)> {
  /// Unzips a FutureOption containing a tuple into a tuple of FutureOptions.
  Future<(Option<T>, Option<U>)> unzip() async {
    var optionTuple = await this;
    if (optionTuple.isSome()) {
      var (one, two) = optionTuple.unwrap();
      return (Some(one), Some(two));
    }
    return (_None(), _None());
  }
}
