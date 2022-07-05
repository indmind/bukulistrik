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
                _buildMeta(),
                DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Tanggal'),
                    ),
                    DataColumn(
                      label: Text('kW H'),
                    ),
                    DataColumn(
                      label: Text('Perbedaan'),
                    ),
                    DataColumn(
                      label: Text('Penggunaan/Menit'),
                    ),
                    DataColumn(
                      label: Text('Penggunaan/Jam'),
                    ),
                    DataColumn(
                      label: Text('Penggunaan/Hari'),
                    ),
                    DataColumn(
                      label: Text('Biaya Penggunaan/Hari'),
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
                            value: c.minutelyUsage,
                            fractions: 5,
                          ),
                        ),
                        DataCell(
                          Kwh(
                            value: c.hourlyUsage,
                            fractions: 3,
                          ),
                        ),
                        DataCell(
                          Kwh(
                            value: c.dailyUsage,
                            fractions: 2,
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

  Obx _buildMeta() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              controller.calculationService.calculate();
            },
            child: const Text('Update Data'),
          ),
          SizedBox(
            width: Get.width,
            child: Table(
              children: [
                _mr(
                  'Count',
                  controller.computedRecords.length.toString(),
                ),
                _mr(
                  'Dur',
                  controller.calculationService.calculationTime.toString(),
                ),
                _mr(
                  'DAvgC',
                  controller.lifetimeAverageConsumption.value
                      .toStringAsFixed(fraction),
                ),
                _mr(
                  'DMinC',
                  (controller.calculationService.dailyMeta.minConsumption ?? 0)
                      .toStringAsFixed(fraction),
                ),
                _mr(
                  'DMaxC',
                  (controller.calculationService.dailyMeta.maxConsumption ?? 0)
                      .toStringAsFixed(fraction),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _mr(String label, String val) {
    return TableRow(
      children: [
        Text('$label:'),
        Text(val),
      ],
    );
  }
}
