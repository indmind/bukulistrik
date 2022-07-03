import 'package:bukulistrik/ui/pages/home_page/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DebugPageView extends GetView<HomePageController> {
  const DebugPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        controller.updateData();
                      },
                      child: const Text('Update Data'),
                    ),
                    Text(controller.calculationTime.value),
                    Text(
                        controller.lifetimeAverageConsumption.value.toString()),
                  ],
                ),
              ),
              Table(
                children: [
                  // table header
                  const TableRow(
                    children: [
                      Text('Tanggal'),
                      Text('kW H'),
                      Text('Penggunaan'),
                      Text('Biaya Penggunaan'),
                      Text('kW H dalam Rp'),
                      Text('Rupiah/kW H'),
                      Text('Pembelian'),
                    ],
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  // table body
                  ...controller.computedRecords.map(
                    (c) => TableRow(
                      children: [
                        Text(
                            '${c.record.createdAt.day}/${c.record.createdAt.month}/${c.record.createdAt.year}'),
                        Text(c.record.availableKwh.toStringAsFixed(2)),
                        Text(c.dailyUsage.toStringAsFixed(2)),
                        Text(c.dailyCost.toStringAsFixed(2)),
                        Text(c.costOfAvailableKwh.toStringAsFixed(0)),
                        Text(c.totalCostPerKwh.toStringAsFixed(1)),
                        Text(
                            '${c.record.addedKwh ?? ''}@${c.record.addedKwhPrice ?? ''}'),
                      ],
                    ),
                  ),
                ],
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
    );
  }
}
