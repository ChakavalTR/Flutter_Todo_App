import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/config/theme/theme.dart';
import 'package:flutter_todo_list_app/modules/home/controllers/home_controller.dart';
import 'package:flutter_todo_list_app/modules/home/models/home_model.dart';
import 'package:get/get.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final controller = Get.find<HomeController>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedPriority = 'Low';
  final List<String> priorityLists = ['Low', 'Medium', 'High'];

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  Future<void> selecteDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: selectedDate,
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> selecteTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  String formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Color getPriorityColor(String priority) {
    if (priority == 'High') {
      return AppTheme.warningColor;
    }
    if (priority == 'Medium') {
      return AppTheme.primaryColor;
    } else {
      return AppTheme.successColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = formatDate(selectedDate);
    final timeText = selectedTime.format(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Add Task',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task Title',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Enter task title',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25),
                Text(
                  'Description (optional)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Enter description',
                    hintStyle: TextStyle(color: Colors.grey),
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                Text(
                  'Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: selecteDate,
                  child: Container(
                    width: Get.width,
                    height: 50,
                    decoration: BoxDecoration(
                      color: controller.isDarkMode.value
                          ? Colors.black.withOpacity(0.5)
                          : Colors.white.withOpacity(0.8),
                      border: Border.all(color: Colors.grey, width: 0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              color: controller.isDarkMode.value
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                            SizedBox(width: 8),
                            Text(
                              dateText,
                              style: TextStyle(
                                fontSize: 16,
                                color: controller.isDarkMode.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Time',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: selecteTime,
                  child: Container(
                    width: Get.width,
                    height: 50,
                    decoration: BoxDecoration(
                      color: controller.isDarkMode.value
                          ? Colors.black.withOpacity(0.5)
                          : Colors.white.withOpacity(0.8),
                      border: Border.all(color: Colors.grey, width: 0.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              color: controller.isDarkMode.value
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                            SizedBox(width: 8),
                            Text(
                              timeText,
                              style: TextStyle(
                                fontSize: 16,
                                color: controller.isDarkMode.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Priority',
                  style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 55,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: controller.isDarkMode.value
                        ? Colors.black.withOpacity(0.5)
                        : Colors.white.withOpacity(0.8),
                    border: Border.all(color: Colors.grey, width: 0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPriority,
                      items: priorityLists.map((priority) {
                        return DropdownMenuItem<String>(
                          value: priority,
                          child: Row(
                            children: [
                              Icon(
                                Icons.flag_outlined,
                                size: 25,
                                color: getPriorityColor(priority),
                              ),
                              SizedBox(width: 8),
                              Text(priority, style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final newTask = HomeModel(
                        title: titleController.text,
                        description: descriptionController.text,
                        date: dateText,
                        time: timeText,
                        status: 'Pending',
                        priority: selectedPriority,
                        isDone: false,
                      );
                      controller.addTask(newTask);
                      Get.back();
                      Future.delayed(Duration(milliseconds: 100), () {
                        Get.snackbar(
                          snackPosition: SnackPosition.BOTTOM,
                          margin: EdgeInsets.all(14),
                          'Task Added',
                          'Your task has been successfully added.',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.successColor,
                  ),
                  child: Text('Save Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
