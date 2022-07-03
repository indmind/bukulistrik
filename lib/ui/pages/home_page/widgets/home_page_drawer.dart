import 'package:bukulistrik/routes.dart';
import 'package:bukulistrik/ui/controllers/auth_controller.dart';
import 'package:bukulistrik/ui/pages/add_record_page/add_record_page_tutorial.dart';
import 'package:bukulistrik/ui/pages/home_page/home_page_controller.dart';
import 'package:bukulistrik/ui/pages/home_page/home_page_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomePageDrawer extends StatelessWidget {
  final HomePageController controller = Get.find();

  HomePageDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Obx(
            () {
              final user = Get.find<AuthController>().user.value;

              return UserAccountsDrawerHeader(
                accountName: Text(user?.displayName ?? 'Guest'),
                accountEmail: Text(user?.email ?? ''),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Get.theme.colorScheme.secondary,
                  foregroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                ),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primary,
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Tutorial antar muka'),
            leading: Icon(
              Icons.info_outline_rounded,
              color: Get.theme.colorScheme.primary,
            ),
            onTap: () async {
              await GetStorage().write(HomePageTutorial.storageKey, false);
              Get.back();
              controller.tutorial.start();
            },
          ),
          ListTile(
            title: const Text('Tutorial tambah data'),
            leading: Icon(
              Icons.info_outline_rounded,
              color: Get.theme.colorScheme.primary,
            ),
            onTap: () async {
              await GetStorage().write(AddRecordPageTutorial.storageKey, false);
              Get.back();
              Get.toNamed(Routes.addRecord.name);
            },
          ),
          ListTile(
            title: const Text('Logout'),
            leading: Icon(
              Icons.exit_to_app,
              color: Get.theme.colorScheme.error,
            ),
            onTap: () {
              Get.find<AuthController>().signOut();
            },
          ),
        ],
      ),
    );
  }
}
