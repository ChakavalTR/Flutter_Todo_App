import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/core/services/local_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //! Declare Variables Here
  var currentIndex = 0.obs;
  var isDarkMode = false.obs;

  //! OnInit Method
  @override
  void onInit() {
    super.onInit();
    isDarkMode.value =
        LocalServiceStorage.instance.getBool('dark_mode') ??
        false; //* Load Theme Data from Local Storage
  }

  //! BottomNavigationBar Route
  int get getCurrentIndex => currentIndex.value;
  void changeBotNavBar(int index) {
    currentIndex.value = index;
  }

  //! DarkMode/LightMode Toggle
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    LocalServiceStorage.instance.setBool('dark_mode', isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void loadThemeData() {
    //* Load Theme Data from Local Storage
    isDarkMode.value =
        LocalServiceStorage.instance.getBool('dark_mode') ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
