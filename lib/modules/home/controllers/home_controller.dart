import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/config/theme/theme.dart';
import 'package:flutter_todo_list_app/core/services/local_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //! Declare Variables Here
  var currentIndex = 0.obs;
  var isDarkMode = false.obs;
  var isCheckBoxList = <bool>[].obs;

  List<String> categories = ['All Tasks', 'Completed', 'Pending'];
  List<Color> categoryColors = [
    AppTheme.primaryColor,
    Colors.green,
    Colors.orange,
  ];
  List<String> categoryNumbers = ['12', '5', '7'];
  List<String> tasks = [
    'Design login screen',
    'Fix bugs in dashboard',
    'Write unit tests',
    'Update user profile',
    'Plan next sprint',
  ];
  List<String> taskTimes = [
    'Today, 10:00 AM',
    'Today, 2:00 PM',
    'Tomorrow, 9:00 AM',
    'Tomorrow, 1:00 PM',
    'Next Monday, 11:00 AM',
  ];
  List<String> priority = ['High', 'Low', 'High', 'Medium', 'Low'];
  List<Color> priorityColors = [
    AppTheme.warningColor,
    AppTheme.successColor,
    AppTheme.warningColor,
    AppTheme.primaryColor,
    AppTheme.successColor,
  ];
  //!------------------------------------------

  //! OnInit Method
  @override
  void onInit() {
    super.onInit();
    isDarkMode.value =
        LocalServiceStorage.instance.getBool('dark_mode') ??
        false; //* Load Theme Data from Local Storage
    isCheckBoxList.value = List.generate(tasks.length, (index) => false);
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
