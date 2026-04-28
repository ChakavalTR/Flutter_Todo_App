import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/config/theme/theme.dart';
import 'package:flutter_todo_list_app/modules/home/controllers/home_controller.dart';
import 'package:flutter_todo_list_app/modules/home/views/edit_view.dart';
import 'package:flutter_todo_list_app/widgets/confirm_delete_dialog_wigdet.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

class TaskDetailView extends GetView<HomeController> {
  final int index;
  const TaskDetailView({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_outlined, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: controller.isDarkMode.value
                        ? AppTheme.primaryColor.withOpacity(0.3)
                        : AppTheme.primaryColor.withOpacity(0.3),
                    child: Icon(
                      Icons.assignment_outlined,
                      size: 40,
                      color: controller.isDarkMode.value
                          ? AppTheme.primaryColor
                          : AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    controller.tasks[index],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: controller.isDarkMode.value
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: controller.priorityColors[index].withOpacity(
                            0.2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${controller.priority[index]} Priority',
                            style: TextStyle(
                              color: controller.priorityColors[index],
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Description',
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  color: controller.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              // ignore: unnecessary_string_interpolations
              '${controller.taskDescriptions[index]}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: controller.isDarkMode.value
                    ? Colors.white
                    : Colors.grey[600],
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                _info(
                  Icons.calendar_today_rounded,
                  'Date',
                  controller.taskDates[index],
                ),
                SizedBox(height: 15),
                _info(
                  Icons.access_time_rounded,
                  'Time',
                  controller.taskTimes[index].split(', ')[1],
                ),
                SizedBox(height: 15),
                _info(
                  Icons.check_box_outlined,
                  'Status',
                  controller.taskStatus[index],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: OutlinedButton(
                        onPressed: () {
                          controller.markAsDone(index);
                          Get.back();
                          Get.snackbar(
                            'Success',
                            'Task marked as done successfully',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppTheme.successColor,
                            colorText: Colors.white,
                            margin: EdgeInsets.all(14),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: AppTheme.successColor,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: FittedBox(
                          child: Row(
                            children: [
                              Icon(
                                Icons.check,
                                size: 20,
                                color: AppTheme.successColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Mark as Done',
                                style: TextStyle(
                                  color: AppTheme.successColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.to(() => EditView(index: index));
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: AppTheme.primaryColor,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: FittedBox(
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                size: 20,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Get.dialog(
                            ConfirmDeleteDialogWidget(
                              onDelete: () {
                                controller.deleteTask(index);
                                Get.back();
                              },
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: AppTheme.dangerColor,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: FittedBox(
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                size: 20,
                                color: AppTheme.dangerColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Delete',
                                style: TextStyle(
                                  color: AppTheme.dangerColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //! Information Widget for Date and Time
  Widget _info(IconData icon, String date, String time) {
    return Row(
      children: [
        Icon(
          icon,
          size: 28,
          color: controller.isDarkMode.value ? Colors.white : Colors.grey[600],
        ),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: TextStyle(
                color: controller.isDarkMode.value
                    ? Colors.white
                    : Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              time,
              style: TextStyle(
                color: controller.isDarkMode.value
                    ? Colors.white
                    : Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
