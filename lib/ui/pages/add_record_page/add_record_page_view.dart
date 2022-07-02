import 'package:bukulistrik/ui/pages/add_record_page/add_record_page_controller.dart';
import 'package:bukulistrik/ui/theme/helper.dart';
import 'package:bukulistrik/ui/theme/spacing.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddRecordPageView extends GetView<AddRecordPageController> {
  const AddRecordPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Get.theme.colorScheme.background,
        foregroundColor: Get.theme.colorScheme.onBackground,
        title: controller.record == null
            ? const Text("Tambah")
            : const Text("Perbarui"),
        elevation: 0,
        centerTitle: true,
        actions: [
          if (controller.record != null)
            IconButton(
              icon: Icon(
                Icons.delete_rounded,
                color: Get.theme.colorScheme.error,
              ),
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text("Hapus data ini?"),
                    insetPadding: Spacing.p8 * 2,
                    titlePadding: Spacing.p8,
                    contentPadding: Spacing.px8,
                    content: const Text(
                        "Harap diperhatikan ini akan mempengaruhi perhitungan data lainnya."),
                    actions: [
                      TextButton(
                        child: const Text("Tidak"),
                        onPressed: () => Get.back(),
                      ),
                      ElevatedButton(
                        child: const Text("Ya"),
                        onPressed: () {
                          controller.deleteRecord();
                          Get.back();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: Spacing.p8,
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.kwhController,
                    decoration: InputDecoration(
                      labelText: "*Sisa kW H",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                        color: Get.theme.colorScheme.onBackground,
                      ),
                      hintText: "Contoh: 78.21",
                      helperText:
                          "Nilai kW H yang tertera pada meteran listrik rumah Anda",
                      helperMaxLines: 2,
                      suffix: Text("kW H", style: Get.textTheme.bodySmall),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Harap isi sisa kW H";
                      }

                      if (Helper.parseDouble(value.replaceAll(",", ".")) ==
                          null) {
                        return "Harap isi sisa kW H dengan angka, gunakan koma (,) untuk desimal";
                      }

                      return null;
                    },
                  ),
                  Spacing.h8,
                  DateTimeField(
                    controller: controller.dateController,
                    format: Helper.df,
                    initialValue: controller.dateController.value.text.isEmpty
                        ? DateTime.now()
                        : Helper.df.parse(controller.dateController.value.text),
                    onShowPicker: (context, current) async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: current ?? DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime:
                              TimeOfDay.fromDateTime(current ?? DateTime.now()),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return current;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "*Waktu Pencatatan",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                        color: Get.theme.colorScheme.onBackground,
                      ),
                      helperText:
                          "Pastikan tanggal dan waktu pencatatan sesuai untuk menjaga keakuratan data",
                      helperMaxLines: 2,
                    ),
                    validator: (value) {
                      if (value == null) {
                        return "Harap isi waktu pencatatan";
                      }

                      return null;
                    },
                  ),
                  Spacing.h8,
                  TextFormField(
                    controller: controller.noteController,
                    decoration: InputDecoration(
                      labelText: "Catatan",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(
                        color: Get.theme.colorScheme.onBackground,
                      ),
                      hintText: "Contoh: Mati listrik seharian",
                      helperText:
                          "Keterangan atau catatan tambahan yang Anda inginkan",
                      helperMaxLines: 2,
                    ),
                  ),
                  // Expansion for more options
                  Theme(
                    data: Get.theme.copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: controller.initiallyExpanded,
                      title: const Text("Pembelian"),
                      tilePadding: EdgeInsets.zero,
                      textColor: Get.theme.colorScheme.onBackground,
                      children: [
                        TextFormField(
                          controller: controller.addedKwhPriceController,
                          decoration: InputDecoration(
                            labelText: "Nominal Pembelian",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle: TextStyle(
                              color: Get.theme.colorScheme.onBackground,
                            ),
                            helperText:
                                "Masukkan nominal total pembelian tanpa biaya administrasi.",
                            helperMaxLines: 3,
                            prefix: Text("Rp ", style: Get.textTheme.bodySmall),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (controller.addedKwhController.text.isEmpty) {
                              return null;
                            }

                            if (value == null || value.isEmpty) {
                              return "Harap isi nominal pembelian";
                            }

                            if (Helper.parseDouble(
                                    value.replaceAll(",", ".")) ==
                                null) {
                              return "Harap isi nominal pembelian dengan angka, gunakan koma (,) untuk desimal";
                            }

                            return null;
                          },
                        ),
                        Spacing.h6,
                        TextFormField(
                          controller: controller.addedKwhController,
                          decoration: InputDecoration(
                            labelText: "kW H yang didapat",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelStyle: TextStyle(
                              color: Get.theme.colorScheme.onBackground,
                            ),
                            helperText:
                                "Masukkan jumlah kW H yang didapat dari pembelian.",
                            helperMaxLines: 2,
                            suffix:
                                Text("kW H", style: Get.textTheme.bodySmall),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (controller
                                .addedKwhPriceController.text.isEmpty) {
                              return null;
                            }

                            if (value == null || value.isEmpty) {
                              return "Harap isi jumlah kW H yang didapat";
                            }

                            if (Helper.parseDouble(
                                    value.replaceAll(",", ".")) ==
                                null) {
                              return "Harap isi jumlah kW H yang didapat dengan angka, gunakan koma (,) untuk desimal";
                            }

                            return null;
                          },
                        ),
                        Spacing.h6,
                      ],
                    ),
                  ),
                  Spacing.h8,
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: controller.onSave,
                      child: controller.record == null
                          ? const Text("Tambah")
                          : const Text("Perbarui"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
