import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/modules/splash/controllers/splash_controller.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/app_splash_image.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
