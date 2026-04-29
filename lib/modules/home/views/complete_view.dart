import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class CompleteView extends GetView<HomeController> {
  const CompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Completed Tasks',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GetBuilder<HomeController>(
        builder: (controller) {
          if (controller.completedTasks.isEmpty) {
            return Center(
              child: Text(
                'No completed tasks yet!',
                style: TextStyle(
                  fontSize: 18,
                  color: controller.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            );
          }
          final completedTask = controller.completedTasks;
          return ListView.builder(
            itemCount: completedTask.length,
            itemBuilder: (context, index) {
              final task = completedTask[index];
              final priorityColor = controller.getPriorityColors(
                task.priority ?? '',
              );
              return Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 30,
                    ),
                    title: Text(
                      task.title.toString(),
                      style: TextStyle(
                        color: controller.isDarkMode.value
                            ? Colors.white
                            : Colors.black,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: controller.isDarkMode.value
                            ? Colors.white
                            // ignore: deprecated_member_use
                            : Colors.black.withOpacity(0.6),
                      ),
                    ),
                    subtitle: Text(
                      '${task.date}, ${task.time}',
                      style: TextStyle(
                        color: controller.isDarkMode.value
                            // ignore: deprecated_member_use
                            ? Colors.grey.withOpacity(0.6)
                            : Colors.grey[500],
                      ),
                    ),
                    trailing: Container(
                      width: 70,
                      height: 30,
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: priorityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          task.priority.toString(),
                          style: TextStyle(
                            color: priorityColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 26, right: 26),
                    child: Divider(
                      thickness: 1.5,
                      color: controller.isDarkMode.value
                          ? Colors.grey[700]!
                          : Colors.grey[300]!,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
