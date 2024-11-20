@pragma('vm:prefer-inline')
void forEachExceptFirstAndLast<E>(Iterator<E> iterator,
    {required Function(E)? doFirst,
    required Function(E)? doRest,
    required Function(E)? doLast,
    required Function(E)? doIfOnlyOne,
    required Function()? doIfEmpty}) {
  if (iterator.moveNext()) {
    E current = iterator.current;
    if (iterator.moveNext()) {
      doFirst?.call(current);
      current = iterator.current;
      if (iterator.moveNext()) {
        E next = iterator.current;
        while (iterator.moveNext()) {
          doRest?.call(current);
          current = next;
          next = iterator.current;
        }
        doRest?.call(current);
        doLast?.call(next);
      } else {
        doLast?.call(current);
      }
    } else {
      doIfOnlyOne?.call(current);
    }
  } else {
    doIfEmpty?.call();
  }
}
