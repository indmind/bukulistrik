import 'package:bukulistrik/domain/models/computed_record.dart';
import 'package:bukulistrik/ui/pages/home_page/widgets/kwh.dart';
import 'package:bukulistrik/ui/theme/helper.dart';
import 'package:bukulistrik/ui/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComputedRecordListItem extends StatelessWidget {
  const ComputedRecordListItem({
    Key? key,
    required this.computedRecord,
    required this.color,
    required this.icon,
    required this.status,
  }) : super(key: key);

  final ComputedRecord computedRecord;
  final Color color;
  final IconData icon;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            // Get.toNamed('/add-record', arguments: {
            //   'record': computedRecord.record,
            // });
            Get.toNamed('/detail', arguments: {
              'computedRecord': computedRecord,
            });
          },
          leading: CircleAvatar(
            backgroundColor: color,
            child: Container(
              padding: Spacing.p2,
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    Kwh(
                      value: computedRecord.dailyUsage,
                      size: 20,
                    ),
                    Spacing.w2,
                    RichText(
                      text: TextSpan(
                        text: "/ Rp. ",
                        style: TextStyle(
                          color: Get.theme.colorScheme.onBackground
                              .withOpacity(0.75),
                          fontSize: 9,
                        ),
                        children: [
                          TextSpan(
                            text: Helper.rp.format(
                              computedRecord.dailyCost,
                            ),
                            style: Get.theme.textTheme.caption!.copyWith(
                              fontSize: 12,
                              color: Get.theme.colorScheme.onBackground
                                  .withOpacity(0.75),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Spacing.w4,
              Text(
                Helper.df.format(computedRecord.record.createdAt),
                style: TextStyle(
                  color: Get.theme.colorScheme.onBackground,
                  fontSize: 12,
                ),
              )
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacing.h2,
              Text(
                status,
                style: const TextStyle(fontSize: 12),
              ),
              Spacing.h2,
              if (computedRecord.record.note != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Catatan: ",
                      style: Get.theme.textTheme.titleSmall,
                    ),
                    Expanded(
                      child: Text(
                        computedRecord.record.note!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ],
                ),
              if (computedRecord.record.addedPricePerKwh != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacing.h2,
                    Text(
                      "Pembelian".tr,
                      style: Get.theme.textTheme.titleSmall,
                    ),
                    Spacing.h2,
                    Row(
                      children: [
                        Icon(
                          Icons.add_rounded,
                          color: Get.theme.colorScheme.tertiary,
                          size: 18,
                        ),
                        Kwh(value: computedRecord.record.addedKwh!, size: 18),
                        const Spacer(),
                        Container(
                          height: 16,
                          width: 1,
                          color: Get.theme.colorScheme.onBackground
                              .withOpacity(0.5),
                        ),
                        const Spacer(),
                        RichText(
                          text: TextSpan(
                            text: "Rp. ",
                            style: TextStyle(
                              color: Get.theme.colorScheme.onBackground
                                  .withOpacity(0.75),
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: Helper.rp.format(
                                  computedRecord.record.addedKwhPrice,
                                ),
                                style: Get.theme.textTheme.caption!.copyWith(
                                  fontSize: 18,
                                  color: Get.theme.colorScheme.onBackground
                                      .withOpacity(0.75),
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
            ],
          ),
        ),
        const Divider(height: Spacing.height * 12),
      ],
    );
  }
}
