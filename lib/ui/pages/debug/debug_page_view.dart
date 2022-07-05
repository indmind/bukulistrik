import 'package:bukulistrik/ui/pages/home_page/home_page_controller.dart';
import 'package:bukulistrik/ui/pages/home_page/widgets/kwh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DebugPageView extends GetView<HomePageController> {
  const DebugPageView({Key? key}) : super(key: key);

  final int fraction = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.updateData();
                        },
                        child: const Text('Update Data'),
                      ),
                      Text(controller.calculationTime.value),
                      SizedBox(
                        width: Get.width,
                        child: Table(
                          children: [
                            TableRow(
                              children: [
                                const Text('LAC:'),
                                Text(
                                  controller.lifetimeAverageConsumption.value
                                      .toStringAsFixed(fraction),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text('MinC:'),
                                Text(
                                  (controller.calculationService.dailyMeta
                                              .minConsumption ??
                                          0)
                                      .toStringAsFixed(fraction),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Text('MaxC:'),
                                Text(
                                  (controller.calculationService.dailyMeta
                                              .maxConsumption ??
                                          0)
                                      .toStringAsFixed(fraction),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Tanggal'),
                    ),
                    DataColumn(
                      label: Text('kW H'),
                    ),
                    DataColumn(
                      label: Text('Penggunaan'),
                    ),
                    DataColumn(
                      label: Text('Penggunaan/Jam'),
                    ),
                    DataColumn(
                      label: Text('Penggunaan/Hari[NORMAL]'),
                    ),
                    DataColumn(
                      label: Text('Biaya Penggunaan'),
                    ),
                    DataColumn(
                      label: Text('kW H dalam Rp'),
                    ),
                    DataColumn(
                      label: Text('Rupiah/kW H'),
                    ),
                    DataColumn(
                      label: Text('Pembelian'),
                    ),
                  ],
                  rows: controller.computedRecords.map((c) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                              '${c.record.createdAt.day}/${c.record.createdAt.month}/${c.record.createdAt.year}'),
                        ),
                        DataCell(
                          Kwh(
                            value: c.record.availableKwh,
                            fractions: fraction,
                          ),
                        ),
                        DataCell(
                          Kwh(
                            value: c.fromLastRecordUsage,
                            fractions: fraction,
                          ),
                        ),
                        DataCell(
                          Kwh(
                            value: c.hourlyUsage,
                            fractions: fraction,
                          ),
                        ),
                        DataCell(
                          Kwh(
                            value: c.dailyUsage,
                            fractions: fraction,
                          ),
                        ),
                        DataCell(
                          Text(c.fromLastRecordCost.toStringAsFixed(2)),
                        ),
                        DataCell(
                          Text(c.costOfAvailableKwh.toStringAsFixed(0)),
                        ),
                        DataCell(
                          Text(c.totalCostPerKwh.toStringAsFixed(1)),
                        ),
                        DataCell(
                          Text(
                              '${c.record.addedKwh ?? ''}@${c.record.addedKwhPrice ?? ''}'),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/add-record');
                    },
                    child: const Text('navigate')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
