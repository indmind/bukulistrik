import 'package:bukulistrik/domain/models/record.dart';
import 'package:get/get.dart';

/// This class is used for storing computed
class MemoizationService extends GetxService {
  final Map<Record, Map<String, dynamic>> _memoization = {};

  /// This method is used to store computed
  /// [record] is the record that is used for calculation
  /// [key] is the key that is used for storing computed
  /// [value] is the value that is used for storing computed
  dynamic memoize(Record record, String key, dynamic value) {
    if (_memoization[record] == null) {
      _memoization[record] = {};
    }

    _memoization[record]![key] = value;

    return value;
  }

  /// This method is used to get computed
  /// [record] is the record that is used for calculation
  /// [key] is the key that is used for storing computed
  dynamic getMemoized(Record record, String key) {
    if (_memoization[record] == null) {
      return null;
    }

    return _memoization[record]![key];
  }
}
