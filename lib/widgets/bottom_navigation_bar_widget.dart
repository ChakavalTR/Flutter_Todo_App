import 'package:flutter/material.dart';
import 'package:flutter_todo_list_app/config/theme/theme.dart';
import 'package:flutter_todo_list_app/modules/home/controllers/home_controller.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class BottomNavigationBarWidget extends GetView<HomeController> {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentIndex = controller.getCurrentIndex;
      return SizedBox(
        height: 93,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            controller.changeBotNavBar(index);
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: AppTheme.greyText,
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          items: [
            BottomNavigationBarItem(
              icon: currentIndex == 0
                  ? Icon(Icons.home, size: 30)
                  : Icon(Icons.home_outlined, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: currentIndex == 2
                  ? Icon(Icons.check_circle, size: 30)
                  : Icon(Icons.check_circle_outline, size: 30),
              label: 'Completed',
            ),
          ],
        ),
      );
    });
  }
}
