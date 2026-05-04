import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class NotificationView extends GetView<HomeController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(child: Text('Notification')),
    );
  }
}
