import 'package:bukulistrik/ui/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvailableKwh extends StatelessWidget {
  final double usage;

  const AvailableKwh({
    Key? key,
    required this.usage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Get.theme.colorScheme.secondary,
          child: Icon(
            Icons.electric_meter_outlined,
            color: Get.theme.colorScheme.onSecondary,
          ),
        ),
        Spacing.w8,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jumlah kW H Terakhir'.tr,
                style: TextStyle(
                  color: Get.theme.colorScheme.onPrimary,
                  fontSize: 12,
                ),
              ),
              Spacing.h1,
              // display 3.2 kwh (kwh in small font)
              RichText(
                text: TextSpan(
                  text: usage.toStringAsFixed(2),
                  style: TextStyle(
                    color: Get.theme.colorScheme.onPrimary,
                    fontSize: 20,
                  ),
                  children: [
                    TextSpan(
                      text: ' kW H',
                      style: TextStyle(
                        color: Get.theme.colorScheme.onPrimary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
