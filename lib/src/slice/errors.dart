sealed class GetManyError implements Exception {
  const GetManyError();

  @override
  String toString() {
    return "GetManyError";
  }

  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

final class GetManyError$IndexOutOfBounds extends GetManyError {
  const GetManyError$IndexOutOfBounds();

  @override
  String toString() {
    return "GetManyError\$IndexOutOfBounds: The requested index out of bounds";
  }
}
