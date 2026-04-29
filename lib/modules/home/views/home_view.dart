import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todo_list_app/config/theme/theme.dart';
import 'package:flutter_todo_list_app/modules/home/views/add_task_view.dart';
import 'package:flutter_todo_list_app/modules/home/views/complete_view.dart';
import 'package:flutter_todo_list_app/modules/home/views/edit_view.dart';
import 'package:flutter_todo_list_app/modules/home/views/profile_view.dart';
import 'package:flutter_todo_list_app/modules/home/views/task_detail_view.dart';
import 'package:flutter_todo_list_app/modules/home/views/view_all_view.dart';
import 'package:flutter_todo_list_app/widgets/bottom_navigation_bar_widget.dart';
import 'package:flutter_todo_list_app/widgets/confirm_delete_dialog_wigdet.dart';
import 'package:flutter_todo_list_app/widgets/floating_action_button_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_todo_list_app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final views = [
        SlidableAutoCloseBehavior(
          closeWhenOpened: true,
          closeWhenTapped: true,
          child: _buildBody,
        ),
        CompleteView(),
        ProfileView(),
      ];
      final currentIndex = controller.getCurrentIndex;
      final currentView = views[currentIndex];
      return Scaffold(
        appBar: currentIndex == 0 ? _buildAppBar : null,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: currentView,
        ),
        floatingActionButton: currentIndex == 0
            ? FloatingActionButtonWidget(
                onPressed: () {
                  Get.to(() => AddTaskView());
                },
              )
            : null,
        bottomNavigationBar: BottomNavigationBarWidget(),
      );
    });
  }

  //! Build Appbar
  AppBar get _buildAppBar {
    return AppBar(
      backgroundColor: controller.isDarkMode.value
          ? AppTheme.darkBg
          : AppTheme.lightBg,
      actions: [
        Row(
          children: [
            Obx(
              () => IconButton(
                onPressed: () {
                  controller.toggleTheme();
                },
                icon: Icon(
                  controller.isDarkMode.value
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  size: 28,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications, size: 28),
            ),
          ],
        ),
      ],
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  controller.greetingDisplay,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: controller.isDarkMode.value
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
            Text(
              'Let\'s make today productive',
              style: TextStyle(fontSize: 15, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  //! Build body
  Widget get _buildBody {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
      child: SizedBox(
        height: Get.height,
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar(
              controller: controller.searchController,
              onChanged: (value) {
                controller.searchTask.value = value;
                controller.update();
              },
              padding: WidgetStatePropertyAll(
                EdgeInsets.only(left: 10, right: 20),
              ),
              hintText: 'Search tasks...',
              hintStyle: WidgetStatePropertyAll(
                TextStyle(
                  color: Colors.grey[400],
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: [
                Obx(() {
                  return controller.searchTask.value.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            controller.searchController.clear();
                            controller.searchTask.value = '';
                            controller.update();
                          },
                          icon: Icon(Icons.close),
                          iconSize: 25,
                          color: Colors.grey[400],
                        )
                      : Icon(Icons.search, color: Colors.grey[400], size: 25);
                }),
              ],
              keyboardType: TextInputType.text,
              elevation: WidgetStatePropertyAll(1.5), //* Box Shadow
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              backgroundColor: WidgetStatePropertyAll(
                controller.isDarkMode.value
                    ? AppTheme.darkCard
                    : AppTheme.lightCard,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: List.generate(controller.categories.length, (index) {
                return Expanded(
                  child: Container(
                    width: 115,
                    height: 110,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      // color: controller.isDarkMode.value
                      //     ? AppTheme.darkCard
                      //     : AppTheme.lightCard,
                      color: controller.categoryColors[index].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.categories[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: controller.categoryColors[index],
                            ),
                          ),
                          Text(
                            index ==
                                    0 //* Total Tasks Count
                                ? controller.tasks.length.toString()
                                : index ==
                                      1 //* Completed Tasks Count
                                ? controller.completedTasks.length.toString()
                                : controller.pendingTasks.length.toString(),
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: controller.categoryColors[index],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    controller.searchTask.value.isNotEmpty
                        ? 'Results for "${controller.searchTask.value}"'
                        : controller.tasks.isEmpty
                        ? 'No tasks available'
                        : 'Today\'s Tasks',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => ViewAllView());
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            GetBuilder<HomeController>(
              builder: (controller) {
                final list = controller.searchResults;
                if (list.isEmpty) {
                  return SizedBox(
                    height: Get.height * 0.5,
                    child: Center(
                      child: Text(
                        controller.searchTask.value.isEmpty
                            ? 'No tasks available'
                            : 'No results found for "${controller.searchTask.value}"',
                        style: TextStyle(
                          fontSize: 16,
                          color: controller.isDarkMode.value
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: List.generate(list.length, (index) {
                    final task = list[index];
                    final realIndex = controller.tasks.indexOf(task);
                    final priorityColor = controller.getPriorityColors(
                      task.priority ?? '',
                    );
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => TaskDetailView(index: realIndex));
                      },
                      child: Column(
                        children: [
                          Slidable(
                            key: ValueKey('${task.title}_$realIndex'),
                            groupTag: 'task_slidable',
                            closeOnScroll: true,
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              extentRatio: 0.5,
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    Get.to(() => EditView(index: realIndex));
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
                                          controller.deleteTask(realIndex);
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
                                    controller.markAsDone(realIndex);
                                    controller.update();
                                  },
                                ),
                              ),
                              title: Text(
                                task.title ?? '',
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
                                    task.priority ?? '',
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
          ],
        ),
      ),
    );
  }
}
