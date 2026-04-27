import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

class EditView extends StatelessWidget {
  final int index;
  const EditView({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final titleController = TextEditingController(
      text: controller.tasks[index],
    );
    final timeController = TextEditingController(
      text: controller.taskTimes[index],
    );
    final priorityController = TextEditingController(
      text: controller.priority[index],
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Task',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Text(
                'Task Title',
                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: titleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Enter task title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
