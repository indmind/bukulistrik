import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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

  static bool isToday(DateTime date) {
    DateTime today = DateTime.now();
    return today.year == date.year &&
        today.month == date.month &&
        today.day == date.day;
  }

  static TargetFocus buildSimpleTarget(
    GlobalKey target,
    String message, {
    ShapeLightFocus shape = ShapeLightFocus.RRect,
    ContentAlign contentAlign = ContentAlign.bottom,
  }) {
    return TargetFocus(
      identify: target,
      keyTarget: target,
      shape: shape,
      alignSkip: Alignment.topRight,
      enableOverlayTab: true,
      contents: [
        TargetContent(
          align: contentAlign,
          builder: (context, controller) {
            return IgnorePointer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
