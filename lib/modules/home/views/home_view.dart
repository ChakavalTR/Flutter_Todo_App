import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todo_list_app/config/theme/theme.dart';
import 'package:flutter_todo_list_app/core/services/local_service.dart';
import 'package:flutter_todo_list_app/modules/home/views/complete_view.dart';
import 'package:flutter_todo_list_app/modules/home/views/edit_view.dart';
import 'package:flutter_todo_list_app/modules/home/views/profile_view.dart';
import 'package:flutter_todo_list_app/widgets/bottom_navigation_bar_widget.dart';
import 'package:flutter_todo_list_app/widgets/confirm_delete_dialog_widet.dart';
import 'package:flutter_todo_list_app/widgets/floating_action_button_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_todo_list_app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final views = [
        SingleChildScrollView(child: _buildBody),
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
            ? FloatingActionButtonWidget()
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
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.only(right: 18, left: 18),
          child: SizedBox(
            height: 50,
            child: SearchBar(
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
              trailing: [Icon(Icons.search_rounded, color: Colors.grey[400])],
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
          ),
        ),
      ),
    );
  }

  //! Build body
  Widget get _buildBody {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(controller.categories.length, (index) {
              return Expanded(
                child: Container(
                  width: 115,
                  height: 110,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: controller.isDarkMode.value
                        ? AppTheme.darkCard
                        : AppTheme.lightCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: controller.isDarkMode.value
                          ? Colors.grey[700]!
                          : Colors.grey[300]!,
                      width: 1.5,
                    ),
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
                              ? controller.isCheckBoxList
                                    .where((e) => e)
                                    .length
                                    .toString()
                              : controller
                                    .isCheckBoxList //* Pending Tasks Count
                                    .where((e) => !e)
                                    .length
                                    .toString(),
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
                  'Today\'s Tasks',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {},
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
          SizedBox(
            height: Get.height * 0.6,
            child: GetBuilder<HomeController>(
              builder: (controller) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.tasks.length,
                  itemBuilder: (context, index) {
                    if (index >= controller.isCheckBoxList.length) {
                      return SizedBox.shrink(); //* Safety check for out-of-range errors
                    }
                    return Slidable(
                      key: ValueKey(controller.tasks[index]),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
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
                            value: controller.isCheckBoxList[index],
                            onChanged: (value) {
                              controller.isCheckBoxList[index] = value!;
                              LocalServiceStorage.instance.setString(
                                'task_checked',
                                controller.isCheckBoxList.join(','),
                              );
                              controller.update();
                            },
                          ),
                        ),
                        title: Text(
                          controller.tasks[index],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: controller.isCheckBoxList[index]
                                // ignore: deprecated_member_use
                                ? Colors.grey.withOpacity(0.6)
                                : (controller.isDarkMode.value
                                      ? Colors.white
                                      : Colors.black),
                            decoration: controller.isCheckBoxList[index]
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor: controller.isDarkMode.value
                                ? Colors.white
                                // ignore: deprecated_member_use
                                : Colors.black.withOpacity(0.6),
                          ),
                        ),
                        subtitle: Text(
                          controller.taskTimes[index],
                          style: TextStyle(
                            fontSize: 13,
                            color: controller.isCheckBoxList[index]
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
                            color: controller.priorityColors[index].withOpacity(
                              0.2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              controller.priority[index],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: controller.priorityColors[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    thickness: 1.5,
                    color: controller.isDarkMode.value
                        ? Colors.grey[700]!
                        : Colors.grey[300]!,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
