part of 'cell.dart';

extension Cell$ConstCellStringExtension on ConstCell<String> {
  Cell<String> operator +(ConstCell<String> other) {
    return Cell<String>(_val + other._val);
  }

  /// Equal to
  bool eq(String val) {
    return _val == val;
  }
}

extension Cell$CellStringExtension on Cell<String> {
  /// Add
  void add(String val) {
    _val = _val + val;
  }
}
