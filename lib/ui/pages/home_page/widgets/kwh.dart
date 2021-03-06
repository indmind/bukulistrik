import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Kwh extends StatelessWidget {
  final double? value;
  final double size;
  final TextStyle? style;
  final int fractions;

  const Kwh({
    Key? key,
    required this.value,
    this.size = 16,
    this.style,
    this.fractions = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mergedStyle = TextStyle(
      color: Get.theme.colorScheme.onBackground.withOpacity(0.9),
      fontSize: size,
      fontWeight: FontWeight.bold,
    ).merge(style);

    return RichText(
      text: TextSpan(
        text: value != null ? value!.toStringAsFixed(fractions) : '-',
        style: mergedStyle,
        children: [
          TextSpan(
            text: ' kW H',
            style: Get.theme.textTheme.caption!.copyWith(
              fontSize: size * 0.4,
              color: mergedStyle.color?.withOpacity(0.75),
            ),
          ),
        ],
      ),
    );
  }
}
