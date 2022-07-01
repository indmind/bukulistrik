import 'package:bukulistrik/ui/pages/home_page/home_page_view.dart';
import 'package:bukulistrik/ui/theme/helper.dart';
import 'package:bukulistrik/ui/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvailableKwh extends StatelessWidget {
  final double available;
  final double? inPrice;
  final int? predictedDayLeft;

  const AvailableKwh({
    Key? key,
    required this.available,
    this.inPrice,
    this.predictedDayLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onLongPress: () {
            Get.toNamed('/debug');
          },
          child: CircleAvatar(
            backgroundColor: Get.theme.colorScheme.secondary,
            child: Icon(
              Icons.electric_meter_outlined,
              color: Get.theme.colorScheme.onSecondary,
            ),
          ),
        ),
        Spacing.w8,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jumlah kW H'.tr,
                style: TextStyle(
                  color: Get.theme.colorScheme.onPrimary,
                  fontSize: 12,
                ),
              ),
              Spacing.h1,
              // display 3.2 kwh (kwh in small font)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Kwh(
                    value: available,
                    size: 20,
                    style: TextStyle(color: Get.theme.colorScheme.onPrimary),
                  ),
                  if (inPrice != null)
                    RichText(
                      text: TextSpan(
                        text: " / Rp. ",
                        style: TextStyle(
                          color:
                              Get.theme.colorScheme.onPrimary.withOpacity(0.75),
                          fontSize: 10,
                        ),
                        children: [
                          TextSpan(
                            text: Helper.rp.format(inPrice!),
                            style: Get.theme.textTheme.caption!.copyWith(
                              fontSize: 12,
                              color: Get.theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        // if (predictedDuration != null) const Spacer(),
        if (predictedDayLeft != null)
          RichText(
            text: TextSpan(
              text: predictedDayLeft!.toStringAsFixed(0),
              style: TextStyle(
                color: Get.theme.colorScheme.onPrimary,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: ' Hari',
                  style: Get.theme.textTheme.caption!.copyWith(
                    fontSize: 32 * 0.4,
                    color: Get.theme.colorScheme.onPrimary.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
