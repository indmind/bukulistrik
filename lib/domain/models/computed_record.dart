import 'package:bukulistrik/common/state_status.dart';
import 'package:bukulistrik/domain/models/record.dart';
import 'package:bukulistrik/domain/services/memoization_service.dart';
import 'package:equatable/equatable.dart';

/// This model is used to represent electricity usage from the record
class ComputedRecord extends Equatable {
  final Record record;
  final ComputedRecord? prevRecord;
  final MemoizationService? memoizationService;

  const ComputedRecord({
    required this.record,
    this.prevRecord,
    this.memoizationService,
  });

  bool get isFirst => prevRecord == null;

  /// representing the lifetime cost per kwh
  double get totalCostPerKwh {
    final memoized = memoizationService?.getMemoized(record, 'totalCostPerKwh');

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

    return memoizationService?.memoize(record, 'totalCostPerKwh', result) ??
        result;
  }

  /// representing the lifetime 'price' available kwh
  double get costOfAvailableKwh {
    final memoized =
        memoizationService?.getMemoized(record, 'costOfAvailableKwh');

    if (memoized is double) {
      return memoized;
    }

    final cost = record.availableKwh * totalCostPerKwh;

    return memoizationService?.memoize(record, 'costOfAvailableKwh', cost) ??
        cost;
  }

  double get fromLastRecordUsage {
    final memoized =
        memoizationService?.getMemoized(record, 'fromLastRecordUsage');

    if (memoized is double) {
      return memoized;
    }

    if (isFirst) {
      if (record.addedKwh != null) {
        return (record.addedKwh ?? 0) - record.availableKwh;
      }

      return 0;
    }

    // usage based on the difference between the previous record and the current record
    final usage = prevRecord!.record.availableKwh -
        record.availableKwh +
        (record.addedKwh ?? 0);

    return memoizationService?.memoize(record, 'fromLastRecordUsage', usage) ??
        usage;
  }

  double get fromLastRecordCost {
    final memoized =
        memoizationService?.getMemoized(record, 'fromLastRecordCost');

    if (memoized is double) {
      return memoized;
    }

    if (isFirst) {
      return fromLastRecordUsage * totalCostPerKwh;
    }

    // final cost = dailyUsage * prevRecord!.totalCostPerKwh;
    final cost = fromLastRecordUsage * totalCostPerKwh;

    return memoizationService?.memoize(record, 'fromLastRecordCost', cost) ??
        cost;
  }

  Duration get durationFromLastRecord => isFirst
      ? Duration.zero
      : record.createdAt.difference(prevRecord!.record.createdAt);

  double get minutelyUsage {
    final memoized = memoizationService?.getMemoized(record, 'minutelyUsage');

    if (memoized is double) {
      return memoized;
    }

    if (isFirst) {
      return fromLastRecordUsage / 24 / 60;
    }

    final duration = durationFromLastRecord;

    final usage = fromLastRecordUsage / duration.inMinutes;

    return memoizationService?.memoize(record, 'minutelyUsage', usage) ?? usage;
  }

  double get hourlyUsage {
    final memoized = memoizationService?.getMemoized(record, 'hourlyUsage');

    if (memoized is double) {
      return memoized;
    }

    final usage = minutelyUsage * 60;

    return memoizationService?.memoize(record, 'hourlyUsage', usage) ?? usage;
  }

  double get hourlyCost {
    final memoized = memoizationService?.getMemoized(record, 'hourlyCost');

    if (memoized is double) {
      return memoized;
    }

    final cost = hourlyUsage * totalCostPerKwh;

    return memoizationService?.memoize(record, 'hourlyCost', cost) ?? cost;
  }

  /// daily usage is calculated based from hourly usage * 24
  double get dailyUsage {
    final memoized = memoizationService?.getMemoized(record, 'dailyUsage');

    if (memoized is double) {
      return memoized;
    }

    final usage = hourlyUsage * 24;

    return memoizationService?.memoize(record, 'dailyUsage', usage) ?? usage;
  }

  double get dailyCost {
    final memoized = memoizationService?.getMemoized(record, 'dailyCost');

    if (memoized is double) {
      return memoized;
    }

    final cost = dailyUsage * totalCostPerKwh;

    return memoizationService?.memoize(record, 'dailyCost', cost) ?? cost;
  }

  @override
  List<Object?> get props => [record, prevRecord];

  StateStatus _getStatus(double val, double prevVal) {
    if (val > prevVal) {
      return StateStatus.up;
    } else if (val < prevVal) {
      return StateStatus.down;
    } else {
      return StateStatus.none;
    }
  }

  // status changes (no need to memoize because it's only using computed records)
  StateStatus get fromLastRecordUsageStatus {
    if (isFirst) {
      return StateStatus.none;
    }

    return _getStatus(fromLastRecordUsage, prevRecord!.fromLastRecordUsage);
  }

  StateStatus get usageFromLastRecordCostStatus {
    if (isFirst) {
      return StateStatus.none;
    }

    return _getStatus(fromLastRecordCost, prevRecord!.fromLastRecordCost);
  }

  StateStatus get minutelyUsageStatus {
    if (isFirst) {
      return StateStatus.none;
    }

    return _getStatus(minutelyUsage, prevRecord!.minutelyUsage);
  }

  StateStatus get hourlyUsageStatus {
    if (isFirst) {
      return StateStatus.none;
    }

    return _getStatus(hourlyUsage, prevRecord!.hourlyUsage);
  }

  StateStatus get hourlyCostStatus {
    if (isFirst) {
      return StateStatus.none;
    }

    return _getStatus(hourlyCost, prevRecord!.hourlyCost);
  }

  StateStatus get dailyUsageStatus {
    if (isFirst) {
      return StateStatus.none;
    }

    return _getStatus(dailyUsage, prevRecord!.dailyUsage);
  }

  StateStatus get dailyCostStatus {
    if (isFirst) {
      return StateStatus.none;
    }

    return _getStatus(dailyCost, prevRecord!.dailyCost);
  }

  StateStatus get totalCostPerKwhStatus {
    if (isFirst) {
      return StateStatus.none;
    }

    return _getStatus(totalCostPerKwh, prevRecord!.totalCostPerKwh);
  }

  StateStatus get costOfAvailableKwhStatus {
    if (isFirst) {
      return StateStatus.none;
    }

    return _getStatus(costOfAvailableKwh, prevRecord!.costOfAvailableKwh);
  }

  /// call all getters that need to be memoized
  void initialize() {
    totalCostPerKwh;
    costOfAvailableKwh;
    fromLastRecordUsage;
    fromLastRecordCost;
    hourlyUsage;
    hourlyCost;
    dailyUsage;
    dailyCost;
  }
}
