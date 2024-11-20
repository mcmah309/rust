part of 'cell.dart';

extension Cell$ConstCellBoolExtension on ConstCell<bool> {
  /// Equal to
  bool eq(bool val) {
    return _val == val;
  }
}

extension Cell$CellBoolExtension on Cell<bool> {
  /// "!" on the inner bool value. e.g. val = !val;
  void not() {
    _val = !_val;
  }
}
