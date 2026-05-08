import 'package:flutter_todo_list_app/config/routes/app_page.dart';
import 'package:flutter_todo_list_app/modules/home/bindings/home_binding.dart';
import 'package:flutter_todo_list_app/modules/home/views/home_view.dart';
import 'package:flutter_todo_list_app/modules/home/views/notification_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';

class AppRouting {
  static final route = RouteView.values.map((e) {
    switch (e) {
      case RouteView.home:
        return GetPage(
          name: "/",
          page: () => HomeView(),
          transition: Transition.noTransition,
        );
      case RouteView.notification:
        return GetPage(
          name: "/notification",
          page: () => NotificationView(),
          binding: HomeBinding(),
          transition: Transition.native,
        );
    }
  }).toList();
}
