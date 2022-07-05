import 'dart:math';

/// This class stores calculation meta such as average, min, and max
class CalculationMeta {
  double? averageConsumption;
  double? minConsumption;
  double? maxConsumption;
  double? totalConsumption;
  double? avgCost;
  double? minCost;
  double? maxCost;
  double? totalCost;

  CalculationMeta({
    this.averageConsumption,
    this.minConsumption,
    this.maxConsumption,
    this.avgCost,
    this.minCost,
    this.maxCost,
  });

  void calculate({
    required double consumption,
    required double cost,
  }) {
    // calculate average consumption
    if (averageConsumption == null) {
      averageConsumption = consumption;
    } else {
      averageConsumption = (averageConsumption! + consumption) / 2;
    }

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

    // calculate average cost
    if (avgCost == null) {
      avgCost = cost;
    } else {
      avgCost = (avgCost! + cost) / 2;
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

  void reset() {
    averageConsumption = null;
    minConsumption = null;
    maxConsumption = null;
    totalConsumption = null;
    avgCost = null;
    minCost = null;
    maxCost = null;
    totalCost = null;
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
