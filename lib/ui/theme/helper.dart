import 'package:intl/intl.dart';

abstract class Helper {
  // format as 20 Jul, 2020 13:45
  static final DateFormat df = DateFormat('E, d MMM yyyy HH:mm', 'id');

  static final NumberFormat rp =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);

  static double? parseDouble(String? value) {
    if (value == null) return null;
    return double.tryParse(value.replaceAll(',', '.'));
  }

  static String? fromDouble(double? value, [int? fractionDigits]) {
    if (value == null) return null;

    String result = fractionDigits != null
        ? value.toStringAsFixed(fractionDigits)
        : value.toString();
    return result.replaceAll('.', ',');
  }
}
