import 'dart:math';

/// This class stores calculation meta such as average, min, and max
class CalculationMeta {
  double? minConsumption;
  double? maxConsumption;
  double? totalConsumption;
  double? minCost;
  double? maxCost;
  double? totalCost;

  int _dataCount = 0;

  CalculationMeta({
    this.minConsumption,
    this.maxConsumption,
    this.minCost,
    this.maxCost,
  });

  void calculate({
    required double consumption,
    required double cost,
  }) {
    _dataCount++;

    // calculate min consumption
    if (minConsumption == null) {
      minConsumption = consumption;
    } else {
      minConsumption = min(minConsumption!, consumption);
    }

    // calculate max consumption
    if (maxConsumption == null) {
      maxConsumption = consumption;
    } else {
      maxConsumption = max(maxConsumption!, consumption);
    }

    // calculate total consumption
    if (totalConsumption == null) {
      totalConsumption = consumption;
    } else {
      totalConsumption = totalConsumption! + consumption;
    }

    // calculate min cost
    if (minCost == null) {
      minCost = cost;
    } else {
      minCost = min(minCost!, cost);
    }

    // calculate max cost
    if (maxCost == null) {
      maxCost = cost;
    } else {
      maxCost = max(maxCost!, cost);
    }

    // calculate total cost
    if (totalCost == null) {
      totalCost = cost;
    } else {
      totalCost = totalCost! + cost;
    }
  }

  double get averageConsumption {
    if (_dataCount == 0 || totalConsumption == null) return 0;
    return totalConsumption! / _dataCount;
  }

  double get averageCost {
    if (_dataCount == 0 || totalCost == null) return 0;
    return totalCost! / _dataCount;
  }

  void reset() {
    minConsumption = null;
    maxConsumption = null;
    totalConsumption = null;
    minCost = null;
    maxCost = null;
    totalCost = null;
    _dataCount = 0;
  }

  // set min(double value) {
  //   if (minConsumption == null) {
  //     minConsumption = value;
  //     return;
  //   }

  //   minConsumption = value < minConsumption! ? value : minConsumption;
  // }

  // set max(double value) {
  //   if (maxConsumption == null) {
  //     maxConsumption = value;
  //     return;
  //   }

  //   maxConsumption = value > maxConsumption! ? value : maxConsumption;
  // }

  // set avg(double value) {
  //   if (averageConsumption == null) {
  //     averageConsumption = value;
  //   } else {
  //     averageConsumption = (averageConsumption! + value) / 2;
  //   }
  // }
}
