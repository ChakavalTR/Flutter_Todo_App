import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/modules/home/controllers/home_controller.dart';
import 'package:flutter_todo_list_app/widgets/confirm_delete_dialog_wigdet%20copy.dart';
import 'package:get/get.dart';

class NotificationView extends GetView<HomeController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(
                ConfirmDeleteNotificationDialogWidget(
                  onDelete: () {
                    controller.clearNotifications();
                    Get.snackbar(
                      'Success',
                      'All notifications have been deleted',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                ),
              );
            },
            icon: Icon(Icons.delete),
            color: Colors.red,
            iconSize: 28,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return Center(
            child: Text("No Notifications", style: TextStyle(fontSize: 16)),
          );
        }
        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getIconColor(notification.title),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getIcon(notification.title), color: Colors.white),
              ),
              title: Text(
                notification.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                notification.message,
                style: TextStyle(
                  fontSize: 14,
                  color: controller.isDarkMode.value
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),
              trailing: Text(
                notification.time,
                style: TextStyle(
                  fontSize: 12,
                  color: controller.isDarkMode.value
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  //! Helper Method to Get Icon Based on Notification Title
  IconData _getIcon(String title) {
    if (title.contains('Created')) {
      return Icons.add;
    } else if (title.contains('Updated')) {
      return Icons.edit;
    } else if (title.contains('Deleted')) {
      return Icons.delete;
    } else if (title.contains('Completed')) {
      return Icons.check;
    } else {
      return Icons.notifications;
    }
  }

  //! Helper Method to Get Icon Color Based on Notification Title
  Color _getIconColor(String title) {
    if (title.contains('Created')) {
      return Colors.blue;
    } else if (title.contains('Updated') || title.contains('Edited')) {
      return Colors.orange;
    } else if (title.contains('Deleted')) {
      return Colors.red;
    } else if (title.contains('Completed')) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }
}
