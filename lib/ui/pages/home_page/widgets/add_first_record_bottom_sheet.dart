import 'package:bukulistrik/domain/models/record.dart';
import 'package:bukulistrik/ui/theme/helper.dart';
import 'package:bukulistrik/ui/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddFirstRecordBottomSheet extends StatefulWidget {
  const AddFirstRecordBottomSheet({
    Key? key,
    required this.onAdd,
  }) : super(key: key);

  final void Function(Record record) onAdd;

  @override
  State<AddFirstRecordBottomSheet> createState() =>
      _AddFirstRecordBottomSheetState();

  static void show(void Function(Record record) onAdd) {
    Get.bottomSheet(
      AddFirstRecordBottomSheet(
        onAdd: onAdd,
      ),
      isDismissible: false,
      enableDrag: false,
      ignoreSafeArea: true,
    );
  }
}

class _AddFirstRecordBottomSheetState extends State<AddFirstRecordBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _kwhController = TextEditingController();
  final _rateController = TextEditingController(text: '1400');

  Record? _record;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_record == null) {
          // Prevent popping
          return false;
        }

        return true;
      },
      child: Container(
        color: Get.theme.colorScheme.background,
        height: Get.height * 0.6,
        padding: Spacing.p8,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Catatan Pertama".tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(height: Spacing.height * 16),
                TextFormField(
                  controller: _kwhController,
                  decoration: InputDecoration(
                    labelText: "kW H Tertera",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      color: Get.theme.colorScheme.onBackground,
                    ),
                    helperText:
                        "Masukkan jumlah kW H yang tertera di meteran rumah Anda",
                    helperMaxLines: 2,
                    hintText: "Contoh: 120,5",
                    suffix: Text("kW H", style: Get.textTheme.bodySmall),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Harap isi jumlah kW H yang tertera saat ini";
                    }

                    if (Helper.parseDouble(value) == null) {
                      return "Harap isi dengan angka, gunakan koma (,) untuk desimal";
                    }

                    return null;
                  },
                ),
                Spacing.h6,
                TextFormField(
                  controller: _rateController,
                  decoration: InputDecoration(
                    labelText: "Tarif per kW H",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: TextStyle(
                      color: Get.theme.colorScheme.onBackground,
                    ),
                    helperText:
                        "Masukkan tarif per kW H, Anda dapat melihat nota pembelian terakhir atau mencarinya di internet untuk data yang lebih akurat",
                    helperMaxLines: 3,
                    prefix: Text("Rp ", style: Get.textTheme.bodySmall),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Harap isi tarif per kW H";
                    }

                    if (Helper.parseDouble(value) == null) {
                      return "Harap isi dengan angka, gunakan koma (,) untuk desimal";
                    }

                    return null;
                  },
                ),
                Spacing.h8,
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final kwh = Helper.parseDouble(_kwhController.text);
                        final rate = Helper.parseDouble(_rateController.text);

                        if (kwh == null || rate == null) {
                          return;
                        }

                        final record = Record(
                          availableKwh: kwh,
                          addedKwh: kwh,
                          addedKwhPrice: kwh * rate,
                          createdAt: DateTime.now(),
                          note: 'Catatan pertama',
                        );

                        widget.onAdd(record);

                        Get.back();
                      }
                    },
                    child: const Text("Tambah"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
