import 'package:intl/intl.dart';

abstract class Helper {
  // format as 20 Jul, 2020 13:45
  static final DateFormat df = DateFormat('E, d MMM yyyy HH:mm', 'id');

  static final NumberFormat rp =
      NumberFormat.currency(locale: 'id', symbol: '', decimalDigits: 0);
}
