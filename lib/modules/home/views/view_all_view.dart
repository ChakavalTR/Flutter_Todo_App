import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todo_list_app/core/services/local_service.dart';
import 'package:flutter_todo_list_app/modules/home/controllers/home_controller.dart';
import 'package:flutter_todo_list_app/modules/home/views/add_task_view.dart';
import 'package:flutter_todo_list_app/modules/home/views/edit_view.dart';
import 'package:flutter_todo_list_app/modules/home/views/task_detail_view.dart';
import 'package:flutter_todo_list_app/widgets/confirm_delete_dialog_wigdet.dart';
import 'package:flutter_todo_list_app/widgets/floating_action_button_widget.dart';
import 'package:get/get.dart';

class ViewAllView extends GetView<HomeController> {
  const ViewAllView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Tasks',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        closeWhenTapped: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GetBuilder<HomeController>(
            builder: (controller) {
              if (controller.tasks.isEmpty) {
                return Center(
                  child: Text(
                    'No tasks available',
                    style: TextStyle(
                      fontSize: 16,
                      color: controller.isDarkMode.value
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                );
              }
              return Column(
                children: List.generate(controller.tasks.length, (index) {
                  final task = controller.tasks[index];
                  final priorityColor = controller.getPriorityColors(
                    task.priority ?? '',
                  );

                  return GestureDetector(
                    onTap: () {
                      Get.to(() => TaskDetailView(index: index));
                    },
                    child: Column(
                      children: [
                        Slidable(
                          key: ValueKey('${controller.tasks[index]}_$index'),
                          groupTag: 'task_slidable',
                          closeOnScroll: true,
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            extentRatio: 0.5,
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  Get.to(() => EditView(index: index));
                                },
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                icon: Icons.edit,
                                label: 'Edit',
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  Get.dialog(
                                    ConfirmDeleteDialogWidget(
                                      onDelete: () {
                                        controller.deleteTask(index);
                                      },
                                    ),
                                  );
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Transform.scale(
                              scale: 1.5,
                              child: Checkbox(
                                value: task.isDone,
                                onChanged: (value) {
                                  task.isDone = value!;
                                  LocalServiceStorage.instance.setString(
                                    'task_checked',
                                    controller.tasks
                                        .map((e) => e.isDone)
                                        .toList()
                                        .toString(),
                                  );
                                  controller.update();
                                },
                              ),
                            ),
                            title: Text(
                              task.title.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: task.isDone
                                    ? Colors.grey.withOpacity(0.6)
                                    : controller.isDarkMode.value
                                    ? Colors.white
                                    : Colors.black,
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: controller.isDarkMode.value
                                    ? Colors.white
                                    : Colors.black.withOpacity(0.6),
                              ),
                            ),
                            subtitle: Text(
                              '${task.date} at ${task.time}',
                              style: TextStyle(
                                fontSize: 13,
                                color: task.isDone
                                    ? Colors.grey.withOpacity(0.6)
                                    : Colors.grey[500],
                              ),
                            ),
                            trailing: Container(
                              width: 70,
                              height: 30,
                              decoration: BoxDecoration(
                                color: priorityColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  task.priority.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: priorityColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1.5,
                          color: controller.isDarkMode.value
                              ? Colors.grey[700]!
                              : Colors.grey[300]!,
                        ),
                      ],
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButtonWidget(
        onPressed: () {
          Get.to(() => AddTaskView());
        },
      ),
    );
  }
}
