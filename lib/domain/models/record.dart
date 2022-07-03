import 'package:equatable/equatable.dart';

/// This model is used to store electricity records
class Record extends Equatable {
  final String? id;
  final DateTime createdAt;
  final double availableKwh;
  final double? addedKwh;
  final double? addedKwhPrice;
  final String? note;

  const Record({
    this.id,
    required this.createdAt,
    required this.availableKwh,
    this.addedKwh,
    this.addedKwhPrice,
    this.note,
  });

  double? get addedPricePerKwh => addedKwhPrice != null && addedKwh != null
      ? addedKwhPrice! / addedKwh!
      : null;

  // to json
  Map<String, dynamic> toJson() => {
        'createdAt': createdAt.millisecondsSinceEpoch,
        'availableKwh': availableKwh,
        'addedKwh': addedKwh,
        'addedKwhPrice': addedKwhPrice,
        'note': note,
      };

  // from firesotre
  factory Record.fromJson(Map<String, dynamic> json) => Record(
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          json['createdAt'] as int,
        ),
        availableKwh: (json['availableKwh'] as num).toDouble(),
        addedKwh: (json['addedKwh'] as num?)?.toDouble(),
        addedKwhPrice: (json['addedKwhPrice'] as num?)?.toDouble(),
        note: json['note'] as String?,
      );

  @override
  List<Object> get props => [createdAt, availableKwh];

  //copyWith
  Record copyWith({
    String? id,
    DateTime? createdAt,
    double? availableKwh,
    double? addedKwh,
    double? addedKwhPrice,
    String? note,
  }) {
    return Record(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      availableKwh: availableKwh ?? this.availableKwh,
      addedKwh: addedKwh ?? this.addedKwh,
      addedKwhPrice: addedKwhPrice ?? this.addedKwhPrice,
      note: note ?? this.note,
    );
  }

  Record withId(String id) {
    return copyWith(id: id);
  }
}
