import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/config/theme/theme.dart';
import 'package:flutter_todo_list_app/widgets/bottom_navigation_bar_widget.dart';
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
        SizedBox.expand(child: Center(child: Text('Completed Tasks'))),
        SizedBox.expand(child: Center(child: Text('User Profile'))),
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
                  'Hello, ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  'User👋',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
    List<String> categories = ['All Tasks', 'Completed', 'Pending'];
    List<Color> categoryColors = [
      AppTheme.primaryColor,
      Colors.green,
      Colors.orange,
    ];
    List<String> categoryNumbers = ['12', '5', '7'];
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
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(categories.length, (index) {
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
                          categories[index],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: categoryColors[index],
                          ),
                        ),
                        Text(
                          categoryNumbers[index],
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: categoryColors[index],
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
            child: ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: priority.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Transform.scale(
                    scale: 1.5,
                    child: Checkbox(value: false, onChanged: (value) {}),
                  ),
                  title: Text(
                    tasks[index],
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    taskTimes[index],
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  trailing: Container(
                    width: 70,
                    height: 30,
                    decoration: BoxDecoration(
                      color: priorityColors[index].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        priority[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: priorityColors[index],
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
            ),
          ),
        ],
      ),
    );
  }
}
