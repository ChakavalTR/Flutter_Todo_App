import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/config/theme/theme.dart';
import 'package:flutter_todo_list_app/core/services/local_service.dart';
import 'package:flutter_todo_list_app/modules/home/models/home_model.dart';
import 'package:flutter_todo_list_app/modules/home/models/notification_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  //! Declare Variables Here
  var currentIndex = 0.obs;
  var isDarkMode = false.obs;
  Timer? timer;
  var greeting = ''.obs;
  var homes = <HomeModel>[].obs;
  var searchTask = ''.obs;
  final searchController = TextEditingController();
  var notifications = <NotificationModel>[].obs;

  List<String> categories = ['All Tasks', 'Completed', 'Pending'];
  List<Color> categoryColors = [
    AppTheme.primaryColor,
    Colors.green,
    Colors.orange,
  ];

  Color getPriorityColors(String priority) {
    if (priority == 'High') {
      return AppTheme.warningColor;
    }
    if (priority == 'Medium') {
      return AppTheme.primaryColor;
    } else {
      return AppTheme.successColor;
    }
  }
  //!------------------------------------------------------------------------------------

  //! OnInit Method
  @override
  void onInit() {
    super.onInit();
    isDarkMode.value =
        LocalServiceStorage.instance.getBool('dark_mode') ??
        false; //* Load Theme Data from Local Storage
    loadTask();
    loadNotifications();
    greeting.value = greetingDisplay;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      greeting.value = greetingDisplay;
    });
  }

  //! OnClose Method
  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
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

  //! Load Tasks from Local Storage
  void loadTask() {
    final savedTask = LocalServiceStorage.instance.getString('tasks');
    if (savedTask != null && savedTask.isNotEmpty) {
      final decoded = jsonDecode(savedTask) as List<dynamic>;
      homes.value = decoded.map((e) => HomeModel.fromJson(e)).toList();
    }
  }

  //! Save Task
  void saveTask() {
    final encode = jsonEncode(
      homes.map((element) => element.toJson()).toList(),
    );
    LocalServiceStorage.instance.setString('tasks', encode);
  }

  //! Completed Task
  List<HomeModel> get completedTasks =>
      homes.where((task) => task.isDone == true).toList();

  List<HomeModel> get pendingTasks =>
      homes.where((task) => task.isDone == false).toList();

  //! Mark as Done Task
  void markAsDone(int index) {
    if (index < 0 || index >= homes.length) {
      return; //*Safety check to prevent out-of-range errors
    }
    homes[index].isDone = !homes[index].isDone;
    homes[index].status = homes[index].isDone ? 'Completed' : 'Pending';
    //! Add Notification to Notification List
    addNotification(
      title: homes[index].isDone ? 'Task Completed' : 'Task Pending',
      message: '"${homes[index].title}" is now ${homes[index].status}',
    );
    homes.refresh();
    saveTask();
    update();
  }

  //! Search Task
  List<HomeModel> get searchResults {
    if (searchTask.value.isEmpty) return homes;
    return homes.where((task) {
      return task.title.toString().toLowerCase().contains(
        searchTask.value.toLowerCase(),
      );
    }).toList();
  }

  //! Add Task
  void addTask(HomeModel task) {
    homes.add(task);
    //! Add Notification to Notification List
    addNotification(
      title: 'Task Created',
      message: 'You created \'${task.title}\'',
    );
    saveTask();
    update();
  }

  //! Edit Task
  void editTask(int index, HomeModel updateTask) {
    if (index < 0 || index >= homes.length) {
      return; //*Safety check to prevent out-of-range errors
    }
    homes[index] = updateTask;
    //! Add Notification to Notification List
    addNotification(
      title: 'Task Updated',
      message: 'You updated \'${updateTask.title}\'',
    );
    homes.refresh();
    saveTask();
    update();
  }

  //! Delete Task
  void deleteTask(int index) {
    if (index < 0 || index >= homes.length) {
      return; //*Safety check to prevent out-of-range errors
    }
    //! Add Notification to Notification List
    addNotification(
      title: 'Task Deleted',
      message: 'You deleted \'${homes[index].title}\'',
    );
    homes.removeAt(index);
    saveTask();
    update();
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

  //! Add Notification to Notification List
  void addNotification({required String title, required String message}) {
    notifications.insert(
      0,
      NotificationModel(
        title: title,
        message: message,
        time: DateFormat('MMM d, h:mm a').format(DateTime.now()),
      ),
    );
    saveNotifications();
  }

  //! Load & Save Notifications from Local Storage
  void loadNotifications() {
    final savedNotifications = LocalServiceStorage.instance.getString(
      'notifications',
    );
    if (savedNotifications != null && savedNotifications.isNotEmpty) {
      final decoded = jsonDecode(savedNotifications) as List<dynamic>;
      notifications.value = decoded
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    }
  }

  void saveNotifications() {
    final encode = jsonEncode(notifications.map((e) => e.toJson()).toList());
    LocalServiceStorage.instance.setString('notifications', encode);
  }

  //! Clear All Notifications
  void clearNotifications() {
    notifications.clear();
    saveNotifications();
  }
}
