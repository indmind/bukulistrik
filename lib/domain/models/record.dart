import 'package:equatable/equatable.dart';

/// This model is used to store electricity records
class Record extends Equatable {
  final DateTime createdAt;
  final double availableKwh;
  final double? addedKwh;
  final double? addedKwhPrice;
  final String? note;

  const Record({
    required this.createdAt,
    required this.availableKwh,
    this.addedKwh,
    this.addedKwhPrice,
    this.note,
  });

  double? get addedPricePerKwh => addedKwhPrice != null && addedKwh != null
      ? addedKwhPrice! / addedKwh!
      : null;

  @override
  List<Object> get props => [createdAt, availableKwh];
}
