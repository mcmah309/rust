import 'package:rust/rust.dart';

extension Vec$IterableExtension<T> on Iterable<T> {
  @pragma('vm:prefer-inline')
  Vec<T> toVec() => toList(growable: true);
}

extension Vec$IteratorExtension<T> on Iterator<T> {
  @pragma('vm:prefer-inline')
  Vec<T> collectVec() {
    final list = <T>[];
    while (moveNext()) {
      list.add(current);
    }
    return list;
  }
}

extension Vec$ListListExtension<T> on List<List<T>> {
  @pragma('vm:prefer-inline')
  Vec<T> flatten() {
    return expand((element) => element).toList();
  }
}

extension Vec$ArrExtension<T> on Arr<T> {
  @pragma('vm:prefer-inline')
  Vec<T> asVec() {
    return list;
  }
}
