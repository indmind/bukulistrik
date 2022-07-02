import 'package:bukulistrik/domain/models/record.dart';
import 'package:bukulistrik/domain/services/memoization_service.dart';
import 'package:equatable/equatable.dart';

/// This model is used to represent electricity usage from the record
class ComputedRecord extends Equatable {
  final Record record;
  final ComputedRecord? prevRecord;
  final MemoizationService memoizationService;

  const ComputedRecord({
    required this.record,
    this.prevRecord,
    required this.memoizationService,
  });

  bool get isFirst => prevRecord == null;

  /// representing the lifetime cost per kwh
  double get totalCostPerKwh {
    final memoized = memoizationService.getMemoized(record, 'totalCostPerKwh');

    if (memoized is double) {
      return memoized;
    }

    final double result;

    if (isFirst) {
      // if it is the first record, then it is the same as the added price per kwh
      result = record.addedPricePerKwh ?? 0;
    } else if (record.addedPricePerKwh != null) {
      // if new kwh is added, adjust the cost/kwh
      result = (record.addedPricePerKwh! + prevRecord!.totalCostPerKwh) / 2;
    } else {
      // if nothing is changed, just use the previous data
      result = prevRecord!.totalCostPerKwh;
    }

    return memoizationService.memoize(record, 'totalCostPerKwh', result);
  }

  /// representing the lifetime 'price' available kwh
  double get costOfAvailableKwh {
    final memoized =
        memoizationService.getMemoized(record, 'costOfAvailableKwh');

    if (memoized is double) {
      return memoized;
    }

    final cost = record.availableKwh * totalCostPerKwh;

    return memoizationService.memoize(record, 'costOfAvailableKwh', cost);
  }

  double get dailyUsage {
    final memoized = memoizationService.getMemoized(record, 'dailyUsage');

    if (memoized is double) {
      return memoized;
    }

    if (isFirst) {
      // return 0;

      if (record.addedKwh != null) {
        return (record.addedKwh ?? 0) - record.availableKwh;
      }

      return 0;
    }

    final usage = prevRecord!.record.availableKwh -
        record.availableKwh +
        (record.addedKwh ?? 0);

    return memoizationService.memoize(record, 'dailyUsage', usage);
  }

  double get dailyCost {
    final memoized = memoizationService.getMemoized(record, 'dailyCost');

    if (memoized is double) {
      return memoized;
    }

    if (isFirst) {
      return dailyUsage * totalCostPerKwh;
    }

    // final cost = dailyUsage * prevRecord!.totalCostPerKwh;
    final cost = dailyUsage * totalCostPerKwh;

    return memoizationService.memoize(record, 'dailyCost', cost);
  }

  @override
  List<Object?> get props => [record, prevRecord];

  /// call all getters that need to be memoized
  void initialize() {
    totalCostPerKwh;
    costOfAvailableKwh;
    dailyUsage;
    dailyCost;
  }
}
