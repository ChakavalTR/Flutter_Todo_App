import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/config/theme/theme.dart';
import 'package:flutter_todo_list_app/core/services/local_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //! Declare Variables Here
  var currentIndex = 0.obs;
  var isDarkMode = false.obs;
  var isCheckBoxList = <bool>[].obs;
  String? saved = LocalServiceStorage.instance.getString('task_checked');
  Timer? timer;
  var greeting = ''.obs;

  List<String> categories = ['All Tasks', 'Completed', 'Pending'];
  List<Color> categoryColors = [
    AppTheme.primaryColor,
    Colors.green,
    Colors.orange,
  ];
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

    if (saved != null && saved!.isNotEmpty) {
      //* Load Checkbox State from Local Storage
      final loaded = saved?.split(',').map((e) => e == 'true').toList();
      isCheckBoxList.value = List.generate(tasks.length, (index) {
        return (loaded != null && index < loaded.length)
            ? loaded[index]
            : false;
      });
    } else {
      isCheckBoxList.value = List.generate(tasks.length, (index) => false);
    }

    greeting.value = greetingDisplay;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      greeting.value = greetingDisplay;
    });
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

  //! Edit Task
  void editTask(int index, String title, String time, String priorityLevel) {
    if (index < 0 || index >= tasks.length) {
      return; //*Safety check to prevent out-of-range errors
    }
    tasks[index] = title;
    taskTimes[index] = time;
    priority[index] = priorityLevel;
    update();
  }

  //! Delete Task
  void deleteTask(int index) {
    if (index < 0 || index >= tasks.length) {
      return; //*Safety check to prevent out-of-range errors
    }
    tasks.removeAt(index);
    if (index < taskTimes.length) {
      taskTimes.removeAt(index);
    }
    if (index < priority.length) {
      priority.removeAt(index);
    }
    if (index < priorityColors.length) {
      priorityColors.removeAt(index);
    }
    if (index < isCheckBoxList.length) {
      isCheckBoxList.removeAt(index);
    }
    LocalServiceStorage.instance.setString(
      'task_checked',
      isCheckBoxList.join(','),
    );
    update();
  }

  //! Completed Task
  List<int> get completedTasks {
    List<int> result = [];
    for (int i = 0; i < isCheckBoxList.length; i++) {
      if (isCheckBoxList[i]) {
        result.add(i);
      }
    }
    return result;
  }

  //! DateTime Display
  String get greetingDisplay {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning 🌅';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon ☀️';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening 🌇';
    } else {
      return 'Good Night 🌙';
    }
  }
}
