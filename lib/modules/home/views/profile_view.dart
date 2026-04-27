import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class ProfileView extends GetView<HomeController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(child: Center(child: Text('User Profile'))),
    );
  }
}
