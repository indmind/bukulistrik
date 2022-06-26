import 'package:bukulistrik/domain/models/record.dart';
import 'package:equatable/equatable.dart';

// INFO: this class is not used just for reference purpose
/// This model is used to represent electricity usage from the record
class ComputedRecord extends Equatable {
  final Record record;
  final ComputedRecord? prevRecord;

  const ComputedRecord({
    required this.record,
    this.prevRecord,
  });

  bool get isFirst => prevRecord == null;

  /// representing the lifetime 'price' available kwh
  double get costOfAvailableKwh {
    if (isFirst) {
      return record.availableKwh * (record.addedPricePerKwh ?? 0);
    }

    // if kwh is added, calculate price per kwh of available kwh
    // based on the price of added kwh, then add the last costOfAvailableKwh
    if (record.addedPricePerKwh != null) {
      // final kwhBeforeAdded = record.availableKwh - record.addedKwh!;
      // return (kwhBeforeAdded * (record.addedPricePerKwh ?? 0) +
      //     prevRecord!.costOfAvailableKwh);

      //  return (record.availableKwh  * (record.addedPricePerKwh ?? 0) +
      // prevRecord!.costOfAvailableKwh);

    }

    return prevRecord!.costOfAvailableKwh - dailyCost;
  }

  /// representing the lifetime cost per kwh
  double get totalCostPerKwh {
    // if it is the first record, then it is the same as the added price per kwh
    if (isFirst) {
      return record.addedPricePerKwh ?? 0;
    }

    // if there is no kwh available, we cant calculate the total cost/kwh
    // therefore, just use the previous data
    if (record.availableKwh == 0) {
      return prevRecord!.totalCostPerKwh;
    }

    return costOfAvailableKwh / record.availableKwh;
  }

  double get dailyUsage {
    if (isFirst) {
      return 0;
    }

    return prevRecord!.record.availableKwh -
        record.availableKwh +
        (record.addedKwh ?? 0);
  }

  double get dailyCost {
    if (isFirst) {
      return 0;
    }

    return dailyUsage * prevRecord!.totalCostPerKwh;
  }

  @override
  List<Object?> get props => [record, prevRecord];
}
