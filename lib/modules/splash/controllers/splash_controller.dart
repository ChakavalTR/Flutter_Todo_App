import 'package:flutter_todo_list_app/config/routes/app_route.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future.delayed(Duration(seconds: 2), () {
      RouteView.home.go(clearAll: true);
    });
  }
}
