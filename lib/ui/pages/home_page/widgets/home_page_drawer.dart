import 'package:bukulistrik/ui/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageDrawer extends StatelessWidget {
  const HomePageDrawer({
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
