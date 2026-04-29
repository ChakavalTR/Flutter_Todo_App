import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/config/theme/theme.dart';
import 'package:flutter_todo_list_app/core/services/local_service.dart';
import 'package:flutter_todo_list_app/modules/home/models/home_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //! Declare Variables Here
  var currentIndex = 0.obs;
  var isDarkMode = false.obs;
  Timer? timer;
  var greeting = ''.obs;
  var tasks = <HomeModel>[].obs;
  var searchTask = ''.obs;
  final searchController = TextEditingController();

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
      tasks.value = decoded.map((e) => HomeModel.fromJson(e)).toList();
    }
  }

  //! Save Task
  void saveTask() {
    final encode = jsonEncode(
      tasks.map((element) => element.toJson()).toList(),
    );
    LocalServiceStorage.instance.setString('tasks', encode);
  }

  //! Completed Task
  List<HomeModel> get completedTasks =>
      tasks.where((task) => task.isDone == true).toList();

  List<HomeModel> get pendingTasks =>
      tasks.where((task) => task.isDone == false).toList();

  //! Mark as Done Task
  void markAsDone(int index) {
    if (index < 0 || index >= tasks.length) {
      return; //*Safety check to prevent out-of-range errors
    }
    tasks[index].isDone = !tasks[index].isDone;
    tasks[index].status = tasks[index].isDone ? 'Completed' : 'Pending';
    tasks.refresh();
    saveTask();
    update();
  }

  //! Search Task
  List<HomeModel> get searchResults {
    if (searchTask.value.isEmpty) return tasks;
    return tasks.where((task) {
      return task.title.toString().toLowerCase().contains(
        searchTask.value.toLowerCase(),
      );
    }).toList();
  }

  //! Add Task
  void addTask(HomeModel task) {
    tasks.add(task);
    saveTask();
    update();
  }

  //! Edit Task
  void editTask(int index, HomeModel updateTask) {
    if (index < 0 || index >= tasks.length) {
      return; //*Safety check to prevent out-of-range errors
    }
    tasks[index] = updateTask;
    saveTask();
    update();
  }

  //! Delete Task
  void deleteTask(int index) {
    if (index < 0 || index >= tasks.length) {
      return; //*Safety check to prevent out-of-range errors
    }
    tasks.removeAt(index);
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
}
