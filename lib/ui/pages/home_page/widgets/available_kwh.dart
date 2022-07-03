import 'package:bukulistrik/ui/pages/home_page/widgets/kwh.dart';
import 'package:bukulistrik/ui/theme/helper.dart';
import 'package:bukulistrik/ui/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvailableKwh extends StatelessWidget {
  final double available;
  final double? inPrice;
  final int? predictedDayLeft;

  final Key? availableKwhKey;
  final Key? availableMoneyKey;
  final Key? availableDayleftKey;

  const AvailableKwh({
    Key? key,
    required this.available,
    this.inPrice,
    this.predictedDayLeft,
    this.availableKwhKey,
    this.availableMoneyKey,
    this.availableDayleftKey,
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
                    key: availableKwhKey,
                    value: available,
                    size: 20,
                    style: TextStyle(color: Get.theme.colorScheme.onPrimary),
                  ),
                  if (inPrice != null)
                    RichText(
                      key: availableMoneyKey,
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
            key: availableDayleftKey,
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
